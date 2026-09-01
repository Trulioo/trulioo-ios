# Trulioo iOS SDK Guide

## Quick Summary

The Trulioo iOS SDK initializes a shortcode-backed session and exposes base verification capabilities for iOS applications.

Customer applications can expect the SDK to:

- resolve session configuration and authorization from the active shortcode
- support configured Device Intelligence and eID capabilities
- return iOS-native results, identifiers, errors, and diagnostic trace data for host routing and support

A standard iOS integration looks like this:

1. add the `Trulioo` Swift package
2. initialize with a shortcode
3. start the required capability: Device Intelligence or eID
4. use the result to continue, retry, or route the journey for review

## Package And Compatibility

- public-facing product name: `Trulioo`
- Swift package product: `Trulioo`
- package name: `Trulioo`
- minimum iOS version: `15.0`

## Installation

Add the package:

```swift
dependencies: [
    .package(url: "https://github.com/Trulioo/trulioo-ios.git", from: "X.Y.Z")
]
```

For beta builds, depend on the prerelease tag explicitly:

```swift
dependencies: [
    .package(url: "https://github.com/Trulioo/trulioo-ios.git", exact: "X.Y.Z-beta.N")
]
```

Then link the product:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Trulioo", package: "Trulioo")
    ]
)
```

## Before You Start

Before using the SDK, make sure the host application:

- has a valid shortcode generated through the Trulioo customer handoff flow using the [Customer API 3.0 handoff operation](https://developer.trulioo.com/reference/posthandoff)
- uses a shortcode configured for the capabilities required by the journey, such as Device Intelligence or eID
- initializes a new SDK session for each verification journey

## Initialization

iOS initialization is callback-based over async work:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    onComplete: { result in
        // Persist the result for later collection
    },
    onError: { error in
        // Initialization failed
    }
)
```

### What Initialization Does

Initialization:

1. resolves the service host from the shortcode
2. establishes an authorized SDK session
3. retrieves the session configuration
4. retains Device Intelligence configuration for later native collection when enabled
5. returns the initialization result for the current verification journey

### Initialization Result

The `onComplete` callback receives the current `Trulioo.InitializationResult`.

| Field | Type | Meaning |
|---|---|---|
| `transactionId` | `String` | Identifier for the verification journey. |
| `debugTrace` | `[DebugTraceEntry]` | SDK diagnostic entries for support and troubleshooting. |

The SDK retains the session configuration, resolved service host, and authorization token internally for the active session. Call `reset()` to clear that session before starting another journey.

## Verification Capabilities

Beta - changes are possible.

### Threading Requirement

The following APIs are annotated `@MainActor` and must be called from the main thread (or with `await MainActor.run {}`):

- `Trulioo.verifyEid(...)`
- `Trulioo.listEidProviders(...)`
- `Trulioo.reset()`

Calling these from a background task without `@MainActor` context will produce a compiler warning or runtime error.

### Device Intelligence

Use Device Intelligence when your iOS flow needs device-risk telemetry from the current app session.

#### Choose An Integration Mode

| Entry point | Use it when | Returns |
|---|---|---|
| `collectDeviceIntelligence(...)` | The application needs to submit DI and wait for lifecycle processing. | A lifecycle-only `deviceEvent` and `debugTrace`. |
| `sendDeviceInformation(...)` | DI should be submitted in the background without waiting for lifecycle processing. | An accepted or failed submission receipt. |

#### Recommended: `collectDeviceIntelligence(...)`

The normal iOS sequence is:

1. initialize once
2. call `collectDeviceIntelligence(...)` when the host needs an explicit device result
3. inspect the lifecycle status and diagnostics

For most integrations, use `collectDeviceIntelligence(...)`. It performs collection, submission, and polling in one async call. It returns a terminal event when processing completes or fails; if the configured polling limit is reached first, it returns the latest non-terminal lifecycle event and records the timeout in `debugTrace`.

If polling exhausts, the result contains the last non-terminal lifecycle state and `debugTrace` contains a `device_event_terminal` timeout entry. Wait and retrieve the detailed result only after the status is `.completed`. If the event fails, use `deviceEvent.failureReason` for the failure detail.

Explicit collection example:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    onComplete: { initialized in
        Task {
            let result = try await Trulioo.collectDeviceIntelligence(
                polling: DeviceIntelligencePollingOptions()
            )

            print("device event", result.deviceEvent)

            if result.deviceEvent?.status == .completed {
                let eventId = result.deviceEvent?.eventId
                let transactionId = result.deviceEvent?.transactionId
            }
        }
    },
    onError: { error in
        print(error)
    }
)
```

`collectDeviceIntelligence(...)` returns an enriched `Trulioo.InitializationResult` for the same session.

| Field | Type | Meaning |
|---|---|---|
| `deviceEvent` | `DeviceEventResult?` | Device-event lifecycle result, when Device Intelligence was collected. |
| `deviceEvent.eventId` | `String` | Identifier for the submitted device event. |
| `deviceEvent.transactionId` | `String` | Identifier used to retrieve the detailed device result after processing completes. |
| `deviceEvent.status` | `DeviceEventStatus` | Current device-event state: `.queued`, `.running`, `.completed`, or `.failed`. |
| `deviceEvent.failureReason` | `String?` | Failure explanation when the device event fails. |
| `debugTrace` | `[DebugTraceEntry]` | SDK diagnostic entries for troubleshooting. |

#### Background Submission: `sendDeviceInformation(...)`

Use `sendDeviceInformation(...)` when the application should submit DI without waiting for server evaluation or a final risk result.

```swift
let submission = try await Trulioo.sendDeviceInformation()
```

It returns after Trulioo accepts the event, rather than waiting for a terminal DI outcome.

The submission result is one of two cases.

##### Accepted Response Fields

| Field | Type | Meaning |
|---|---|---|
| case | `.accepted` | Trulioo accepted the device-event submission. Evaluation may still be processing. |
| `transactionId` | `String` | Transaction identifier for the submitted device event. |
| `eventId` | `String` | Device-event identifier for the submitted device event. |
| `debugTrace` | `[DebugTraceEntry]` | SDK diagnostic entries captured while collecting and submitting the payload. |

##### Failed Response Fields

| Field | Type | Meaning |
|---|---|---|
| case | `.failed` | The SDK could not initialize the runtime, collect the payload, or submit the device event. |
| `code` | `SendDeviceInformationFailureCode` | Stable failure code. |
| `stage` | `String` | SDK stage at which the failure occurred. |
| `message` | `String` | Failure detail. |
| `transactionId` | `String?` | Transaction identifier, when one was available before the failure. |
| `eventId` | `String?` | Device-event identifier, when one was available before the failure. |
| `debugTrace` | `[DebugTraceEntry]` | SDK diagnostic entries captured before the failure. |

#### Retrieve the Detailed Result

Both integration modes provide `transactionId` after submission. Call `GET /transactions/{transactionId}/devices` with that value after device processing is complete to retrieve the detailed device result.

- `collectDeviceIntelligence(...)` normally returns after reaching `.completed` or `.failed`. If its configured polling limit is reached first, it returns the latest non-terminal lifecycle state and records the timeout in `debugTrace`.
- `sendDeviceInformation(...)` returns after Trulioo accepts the event, before evaluation completes.

Retrieve details after the event is `.completed`. If `collectDeviceIntelligence(...)` returns a non-terminal status, wait and retry the endpoint until processing completes.

See [Get transaction devices](https://developer.trulioo.com/reference/gettransactiondevices) for authentication, request requirements, and the detailed result fields.

#### Device Intelligence Options

Device Intelligence options customize explicit DI collection. They are optional; the SDK manages the device runtime automatically.

`collectDeviceIntelligence(...)` accepts optional polling controls:

| Option | Type | Use |
|---|---|---|
| `polling` | `DeviceIntelligencePollingOptions` | Controls how long explicit collection waits for a terminal result. Defaults to 32 attempts, 1,250 ms apart. If the event remains non-terminal after the limit, the result contains the last lifecycle-only `deviceEvent` and records the timeout in `debugTrace`. |

Provide options directly to explicit collection:

```swift
let result = try await Trulioo.collectDeviceIntelligence(
    polling: DeviceIntelligencePollingOptions(
        maxAttempts: 10,
        intervalMilliseconds: 1000
    )
)
```

### eID Verification

Use the eID entrypoints when your iOS flow needs an interactive provider-backed identity verification from the same initialized session.

#### iOS Setup

Customer-app integrations must use a globally unique callback scheme. Register it in `Info.plist`, then pass the same value as `callbackScheme` to `EidVerificationConfig`. The provider redirects to this scheme when the customer finishes, and the SDK's system authentication session receives the callback.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.example.app.eid</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.example.app.eid</string>
        </array>
    </dict>
</array>
```

`Trulioo.listEidProviders(...)` is optional and can be used to inspect licensed providers for a country before launch.

#### Start a Verification

The normal iOS sequence is:

1. initialize once
2. optionally list providers for a country
3. call `Trulioo.verifyEid(...)` when the customer continues
4. inspect the terminal result; call `Trulioo.reset()` and initialize a new session before retrying

`verifyEid(...)` presents Apple's system browser-authentication session, rather than an embedded WebView. The SDK receives the callback and waits for the backend result.

Example:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    options: Trulioo.InitializationOptions(),
    onComplete: { _ in
        Task {
            do {
                let result = try await Trulioo.verifyEid(
                    config: EidVerificationConfig(
                        countryCode: "SE",
                        callbackScheme: "com.example.app.eid"
                    ),
                    options: EidVerificationOptions(timeoutMs: 240_000) // optional; defaults to 180,000 ms
                )

                print("eid reached terminal status \(result.status): \(result.transactionId)")
            } catch {
                // The provider flow could not complete, for example because the
                // customer cancelled, the flow timed out, or a request failed.
                print("eid verification failed", error)
            }
        }
    },
    onError: { error in
        print(error)
    }
)
```

`EidVerificationOptions.timeoutMs` controls the client-side wait for that verification. It defaults to **180,000 ms (three minutes)** and is capped by an earlier provider-session expiry; it does not extend the provider's server-side session.

#### Cancel a Verification

Call `Trulioo.cancelEid()` on the main actor to cancel an ongoing `verifyEid(...)` call, including while the provider flow is active or the SDK is polling. It cancels the local EID operation, dismisses the active browser-authentication session, and the pending `verifyEid(...)` call throws `EidError.cancelled`. The initialized SDK session remains available for a retry.

```swift
Button("Cancel verification") {
    Trulioo.cancelEid()
}
```

#### Result

`verifyEid(...)` returns after the provider flow and result polling reach a terminal result. It contains only the transaction ID and typed terminal status; fetch the detailed result for the EID outcome and identity details.

| Field | Type | Meaning |
|---|---|---|
| `transactionId` | `String` | Trulioo transaction that owns the verification. |
| `status` | `EidVerificationStatus` | `.completed`, `.denied`, `.userDenied`, `.timedOut`, or `.unknown`. `.unknown` is used when a terminal server status is not recognized by this SDK version. |

Apply policy using the detailed result retrieved with `transactionId`, rather than inferring it from the terminal status.

#### Retrieve the Detailed Result

After `verifyEid(...)` reaches a terminal result, call `GET /transactions/{transactionId}/eid/result` with `result.transactionId` to retrieve the detailed eID result.

See [Get eID result](https://developer.trulioo.com/reference/geteidresult) for authentication, request requirements, and the detailed result fields.

#### Input

| Input | Type | Format and behavior |
|---|---|---|
| `countryCode` | `String` | Required. Use the two-letter uppercase ISO 3166-1 alpha-2 code configured for the eID journey. |
| `providerIdentifier` | `String` | Optional. Omit it for server-side provider selection; set it only when the journey intentionally pins a licensed provider. |
| `callbackScheme` | `String` | Required for customer-app integrations. It must match the scheme registered in `Info.plist`. |

#### Optional: Choosing a specific Provider

Provider discovery is optional. When `providerIdentifier` is omitted, Trulioo selects the healthiest licensed provider for the configured country. Call `listEidProviders(countryCode:)` only when the application needs to show a provider picker.

```swift
let providers = try await Trulioo.listEidProviders(countryCode: "SE")

let config = EidVerificationConfig(
    countryCode: "SE",
    providerIdentifier: providers.first?.id,
    callbackScheme: "com.example.app.eid"
)
```

| Provider field | Type | Meaning |
|---|---|---|
| `id` | `String` | Provider identifier. Pass this value as `providerIdentifier` after the customer chooses it. |
| `name` | `String` | Display name suitable for the picker. |
| `countries` | `[String]` | Countries supported by the provider. |
| `health` | `String` | Current provider health. |

## Resetting State

Call `Trulioo.reset()` to clear all internal session state. Use this for logout flows or before re-initializing with a new shortcode:

```swift
Trulioo.reset()
// Can now call Trulioo.initialize(...) again
```

Note: Calling `verifyEid` or `listEidProviders` after `reset()` (without re-initializing) will throw `NotInitializedError`.

`reset()` also clears SDK-owned eID state.

## Error Handling

Not-initialized errors:

- `NotInitializedError` is thrown when calling any method before `initialize()` completes or after `reset()`
- Affected methods: `collectDeviceIntelligence`, `verifyEid`, `listEidProviders`

Initialization errors are delivered through the `onError` callback.

Send errors:

- return `SendDeviceInformationResult.failed`
- include a stable failure code, failed stage, message, identifiers when known, and `debugTrace`

Device collection throws on failure. When troubleshooting, inspect:

- the thrown error
- `deviceEvent?.failureReason`
- `debugTrace`

eID errors:

- `verifyEid(...)` throws when preparation, provider handoff, callback handling, or result polling fails
- `verifyEid(...)` also throws when the customer cancels, the provider flow times out, or another eID verification is already in progress

## Troubleshooting

If Device Intelligence does not appear:

1. Confirm initialization completed successfully.
2. Confirm Device Intelligence is enabled for the account and verification journey.
3. Confirm you explicitly called `collectDeviceIntelligence(...)` or `sendDeviceInformation(...)`.
4. Inspect `debugTrace`.

If results are incomplete:

1. Inspect `deviceEvent?.failureReason`.
2. Inspect `debugTrace` for a polling timeout or failed stage.
3. After the event completes, retrieve the detailed result with `GET /transactions/{transactionId}/devices`.

If eID does not start or complete:

1. Confirm initialization completed successfully and the selected country is configured for eID.
2. Call `verifyEid(...)` from the customer's action so iOS can present the provider authentication session.
3. Inspect a returned result's `status`, or handle the thrown error when provider handoff, callback handling, or result polling fails.
4. Call `reset()`, initialize a new session, then retry an interrupted eID flow.
