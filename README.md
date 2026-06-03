# Trulioo iOS SDK Guide

## Quick Summary

A standard iOS integration looks like this:

1. add the `Trulioo` Swift package
2. initialize with a shortcode
3. call `collectDeviceIntelligence(...)`
4. optionally provide subject reference data
5. branch on accepted or failed and log the returned identifiers and `debugTrace`

The published base `Trulioo` iOS SDK covers three primary integration flows:

- Device Intelligence through `Trulioo.collectDeviceIntelligence(...)` and `Trulioo.getDeviceInformation(...)`
- KYC Data verification through `Trulioo.verifyData(...)`
- eID verification through `Trulioo.listEidProviders(...)`, `Trulioo.prepareEid(...)`, and `Trulioo.verifyEid(...)`

## Package And Compatibility

- public-facing product name: `Trulioo`
- Swift package product: `Trulioo`
- package name: `Trulioo`
- minimum iOS version: `15.0`

The package includes the runtime components required by the public Trulioo API.

Supported iOS integrations must use the Trulioo-supported runtime contract for the current package version.

- the Trulioo iOS SDK requires the encrypted payload bundle from the runtime submit callback
- runtime paths that only expose `eventId` are unsupported
- `eventId` remains part of the Trulioo device event model for polling and diagnostics after seed submission succeeds

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

## Public API Surface

Main entry points:

- `Trulioo.initialize(...)`
- `Trulioo.collectDeviceIntelligence(...)`
- `Trulioo.getDeviceInformation(...)`
- `Trulioo.verifyData(...)`
- `Trulioo.listEidProviders(...)`
- `Trulioo.prepareEid(...)`
- `Trulioo.verifyEid(...)`
- `Trulioo.sessionClient(...)`

Important types:

- `Trulioo.InitializationOptions`
- `Trulioo.InitializationResult`
- `DeviceIntelligencePollingOptions`
- `DeviceSubjectReference`
- `DeviceSubjectOtherField`
- `DeviceSeedResponse`
- `DeviceEventResponse`
- `DebugTraceEntry`
- `TruliooSessionClient`

## Initialization

iOS initialization is callback-based over async work:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    options: Trulioo.InitializationOptions(
        allowLocalDevelopment: false,
        sdkVersion: "1.0.0"
    ),
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

1. resolves the backend host from shortcode
2. performs challenge and authorization
3. fetches session configuration
4. returns the initialization result
5. remembers device-intelligence configuration when enabled

Initialization does not mean the device-intelligence flow has already run.

## Initialization Options

`Trulioo.InitializationOptions` supports:

- `allowLocalDevelopment`
- `deviceIntelligencePolling`
- `enableNativeDeviceDebugLog`
- `sdkVersion`

Use cases:

- `allowLocalDevelopment`
  Enable only for local or emulator shortcode testing.
- `enableNativeDeviceDebugLog`
  Use only for intentional diagnostic sessions. Leave off in normal production integrations.
- `sdkVersion`
  Set this to your integration version so operational logs and support cases are easier to map.

`collectDeviceIntelligence(...)` and `getDeviceInformation(...)` also accept `userId`.

Use `userId` only when your downstream device-intelligence runtime expects a runtime-specific user identifier. It is not a Trulioo transaction ID replacement.

### Important Rules

- collection happens after initialization
- the public contract does not accept runtime credential overrides
- `reference` is subject-only
- the SDK generates device basic information internally
- a failed reference call is debug-only and non-blocking
- a runtime submit that does not return the encrypted payload bundle fails before Trulioo seed submission

## Debug Blocking Collection

Use blocking collection only when debug or diagnostics need the resolved device event and normalized seed:

```swift
let result = try await Trulioo.collectDeviceIntelligence(
    initialization: initialized,
    polling: DeviceIntelligencePollingOptions(),
    reference: DeviceSubjectReference(
        firstName: "Jane",
        lastName: "Doe"
    )
)
```

## Convenience Device Callback

If debug tooling only needs the normalized device result:

```swift
Trulioo.getDeviceInformation(
    initialization: initialized,
    onComplete: { device in
        // device is DeviceSeedResponse?
    },
    onError: { error in
        // Collection failed
    }
)
```

## Features

Beta - changes are possible.

### Device Intelligence

Use Device Intelligence when your iOS flow needs device-risk telemetry from the current app session.

The normal iOS sequence is:

1. initialize once
2. call `collectDeviceIntelligence(...)` when the host needs an explicit device result
3. optionally use `getDeviceInformation(...)` when the host only needs the normalized device seed through callbacks
4. inspect accepted or failed results

Explicit collection example:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    options: Trulioo.InitializationOptions(
        allowLocalDevelopment: false,
        sdkVersion: "1.0.0"
    ),
    onComplete: { initialized in
        Task {
            let result = try await Trulioo.collectDeviceIntelligence(
                initialization: initialized,
                polling: DeviceIntelligencePollingOptions(),
                reference: DeviceSubjectReference(
                    firstName: "Jane",
                    lastName: "Doe",
                    dateOfBirth: "1990-01-01"
                )
            )

            print("device event", result.deviceEvent)
            print("device seed", result.deviceSeed)
        }
    },
    onError: { error in
        print(error)
    }
)
```

Debug example:

```swift
let debugResult = try await Trulioo.collectDeviceIntelligence(
    initialization: initialized,
    polling: DeviceIntelligencePollingOptions(),
    reference: DeviceSubjectReference(
        firstName: "Jane",
        lastName: "Doe"
    )
)

print(debugResult.deviceEvent)
print(debugResult.deviceSeed)
```

Important behavior:

- `collectDeviceIntelligence(...)` is the documented explicit collection path
- `getDeviceInformation(...)` is useful when the host only needs the normalized device seed through callbacks
- `reference` is caller-owned subject data only
- device basic information is generated by the SDK
- the SDK requires the supported encrypted payload bundle path before it seeds the Trulioo device event
- initialization and device collection remain separate so the app can decide when to send

## Advanced Authorized Session Contract

iOS also exposes a post-bootstrap authorized session client.

Use this when your integration needs approved Trulioo routes after initialization, such as:

- typed authorized JSON requests
- typed authorized binary uploads

Create the session client from a successful initialization result:

```swift
let sessionClient = try Trulioo.sessionClient(
    initialization: initialized,
    allowedAuthorizedPaths: [
        "/vendor/device/session"
    ]
)
```

The zero-argument overload only enables the base SDK's default device-owned post-bootstrap routes. Feature SDKs that own additional approved routes must register them explicitly through `allowedAuthorizedPaths`.

Available operations:

- `authorizedPost(path:body:)`
- `authorizedGet(path:)`
- `authorizedPostWithoutResponse(path:body:)`
- `authorizedPostWithoutBody(path:)`
- `authorizedGetWithoutResponse(path:)`
- `authorizedUpload(path:body:contentType:headers:timeoutMilliseconds:)`

Example typed authorized POST:

```swift
struct StatusRequest: Encodable {
    let transactionId: String
}

struct StatusResponse: Decodable {
    let status: String
}

let status: StatusResponse = try await sessionClient.authorizedPost(
    path: "/vendor/device/session",
    body: StatusRequest(transactionId: "txn-123")
)
```

Rules:

- initialize first and reuse the returned session result
- the default helper only includes the base SDK's built-in device route allowlist
- register any extra approved routes explicitly through `allowedAuthorizedPaths`
- use approved relative paths only
- treat this as an advanced contract, not the default device-information integration path

## Polling

Default polling:

- `maxAttempts = 32`
- `intervalMilliseconds = 1250`

### KYC Data Verification

Use `Trulioo.verifyData(...)` when your iOS flow already has subject data and needs a terminal KYC verification result from the same initialized session.

The normal iOS sequence is:

1. initialize once
2. collect subject data in your app
3. call `Trulioo.verifyData(...)`
4. inspect the terminal result

Example:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    options: Trulioo.InitializationOptions(),
    onComplete: { _ in
        Task {
            Trulioo.dataStateHandler = { state in
                print("dataState", state)
            }

            let result = try await Trulioo.verifyData(
                config: DataVerificationConfig(
                    personInfo: PersonInfo(
                        firstName: "Jane",
                        lastName: "Doe",
                        dateOfBirth: "1990-01-01"
                    ),
                    location: Location(
                        buildingNumber: "123",
                        streetName: "Example",
                        streetType: "Ave",
                        city: "Exampleville",
                        stateProvinceCode: "BC",
                        postalCode: "V0V0V0"
                    ),
                    communication: Communication(
                        emailAddress: "jane.doe@example.com",
                        mobileNumber: "+12025550123"
                    ),
                    countryCode: "CA"
                )
            )

            if result.outcome == .accept && result.recordMatch {
                print("data verified", result.transactionId)
            } else {
                print("data review path", result)
            }
        }
    },
    onError: { error in
        print(error)
    }
)
```

Important behavior:

- `verifyData(...)` reuses the internally stored initialized session
- the SDK submits PII but does not return PII in `DataVerificationResult`
- `Trulioo.dataState` exposes the current module state
- `Trulioo.dataStateHandler` lets the host app observe state transitions
- `Trulioo.resetData()` cancels or clears the current data flow when you need to restart it

### eID Verification

Use the eID entrypoints when your iOS flow needs an interactive provider-backed identity verification from the same initialized session.

Optional iOS-only setup:

- `Trulioo.listEidProviders(...)` can be used to inspect licensed providers for a country before launch

The normal iOS sequence is:

1. initialize once
2. optionally list providers for a country
3. call `Trulioo.prepareEid(...)` when the eID screen appears
4. call `Trulioo.verifyEid(...)` when the customer continues
5. inspect the terminal result or call `Trulioo.resetEid()` before retrying

Example:

```swift
Trulioo.initialize(
    shortcode: shortcode,
    options: Trulioo.InitializationOptions(),
    onComplete: { _ in
        Task {
            let providers = try await Trulioo.listEidProviders(countryCode: "SE")
            print("providers", providers.map(\.name))

            try await Trulioo.prepareEid(
                config: EidVerificationConfig(
                    countryCode: "SE",
                    callbackScheme: "com.example.app"
                )
            )

            let result = try await Trulioo.verifyEid(
                config: EidVerificationConfig(
                    countryCode: "SE",
                    callbackScheme: "com.example.app"
                )
            )

            if result.outcome == .success && result.match {
                print("eid verified", result.transactionId)
            } else {
                print("eid not verified", result)
            }
        }
    },
    onError: { error in
        print(error)
    }
)
```

Important behavior:

- `listEidProviders(...)` is optional and helps you inspect licensed providers for a country before launch
- `prepareEid(...)` is the right place to pre-warm the eID screen
- `verifyEid(...)` launches the interactive provider flow and waits for terminal status
- for customer-app SDK integrations, set a unique `callbackScheme`
- `callbackHost` is optional and should only be overridden when your environment requires a non-default callback host
- `Trulioo.eidState` exposes the current eID state
- `Trulioo.resetEid()` clears interrupted eID state before a restart
- `intervalMilliseconds = 1250`

Example override:

```swift
let polling = DeviceIntelligencePollingOptions(
    maxAttempts: 10,
    intervalMilliseconds: 1000
)
```

## Subject Reference Data

The public iOS reference type accepts subject data only:

```swift
let reference = DeviceSubjectReference(
    firstName: "Jane",
    lastName: "Doe",
    dateOfBirth: "1990-01-01",
    phoneNumber: "+15551234567",
    other: [
        DeviceSubjectOtherField(customKey: "middleName", value: "Ann")
    ]
)
```

Do not construct or pass basic-information payloads from the app. The SDK owns those fields.

## Results

`Trulioo.InitializationResult` contains:

- `baseURL`
- `accessToken`
- `configuration`
- `deviceEvent`
- `deviceSeed`
- `debugTrace`

Use those fields like this:

- `configuration`
  Confirms what the backend enabled for the session.
- `deviceEvent`
  Source of truth for terminal status and failure reason.
- `deviceSeed`
  Normalized device result for product logic and UI.
- `debugTrace`
  Diagnostic timeline.

## Platform Background

Current iOS runtime metadata is derived from:

- `UIDevice`
- `Locale`
- `Bundle`

The authorization runtime metadata currently resolves:

- platform: `apple`
- manufacturer: `Apple`
- software: iOS version or OS string

This is SDK-owned behavior. App consumers should not need to duplicate it.

## Error Handling

Initialization errors are delivered through the `onError` callback.

Send errors:

- return `SendDeviceInformationResult.failed`
- include a stable failure code, failed stage, message, identifiers when known, and `debugTrace`

Device collection throws on failure. When troubleshooting, inspect:

- the thrown error
- `deviceEvent?.failureReason`
- `debugTrace`

Reference submission failures are captured in `debugTrace` and do not become direct user-facing collection errors by default.

## Environment And Shortcode Rules

Environment resolution is shortcode-driven.

| Shortcode Pattern | Environment |
| --- | --- |
| default | production |
| `.dv` suffix | development |
| `.pr` suffix | preview |
| `.local` suffix or `local` | local |
| `.emulator` suffix or `emulator` | emulator |
| `local@host:port` | local override |
| `emulator@host:port` | emulator override |

Supported region prefixes:

- `us`
- `eu`
- `ap` / `apac`
- `ca`

Local and emulator shortcodes are blocked unless `allowLocalDevelopment` is explicitly enabled.

## Common Mistakes

- assuming initialization also performs collection
- trying to pass runtime credential data from app code
- coupling app-owned form data with SDK-owned basic-information fields
- treating reference failure as a full collection failure
- enabling native debug logging in normal production builds without need

## Troubleshooting

If device intelligence does not run:

1. Confirm initialization succeeded.
2. Confirm `configuration.deviceConfiguration?.intelligenceEnabled == true`.
3. Confirm the backend returned a device credential.
4. Confirm send was explicitly invoked, or confirm the debug wait path was intentionally chosen.
5. Inspect `debugTrace`.

If the terminal event failed:

1. inspect `deviceEvent?.failureReason`
2. inspect processor details when present
3. compare the terminal event with the `device_reference_submit` trace so reference failure is not mistaken for full collection failure

## Diagnostic Capture Checklist

When capturing an iOS integration issue, record:

1. the shortcode used and whether it targeted production, development, preview, local, or emulator
2. the app version, iOS version, and device model
3. whether `allowLocalDevelopment` or `enableNativeDeviceDebugLog` was enabled
4. the terminal `deviceEvent.status`, `failureReason`, and relevant processor details
5. the `transactionId`, `eventId`, and the relevant `debugTrace` entries
6. whether subject reference data was provided and whether `device_reference_submit` appeared
7. whether a runtime-specific `userId` was supplied to send or debug collection

## Guiding Principles

Use these principles to keep an iOS integration simple and predictable:

1. initialize first
2. send second
3. subject data is caller-owned
4. device basic information is SDK-owned
5. the device event is the authoritative outcome
