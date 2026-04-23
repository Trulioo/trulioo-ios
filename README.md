# Trulioo Device iOS Guide

Welcome to the iOS integration guide for Trulioo Device.

This guide is designed so a junior iOS developer can integrate the SDK without reverse-engineering the source, and a junior QA engineer can validate the flow and capture useful diagnostics.

Read this guide together with:

- [Trulioo Device Shared Integration Contract](./trulioo-shared-contract.md)
- [Trulioo SDK Documentation Standard](./trulioo-documentation-standard.md) if you are reviewing or publishing SDK docs

## Quick Summary

A standard iOS integration looks like this:

1. add the `Trulioo` Swift package for Trulioo Device
2. initialize with a shortcode
3. call `sendDeviceInformation(...)`
4. optionally provide subject reference data
5. branch on accepted or failed and log the returned identifiers and `debugTrace`

## Package And Compatibility

- public-facing product name: `Trulioo Device`
- Swift package product: `Trulioo`
- package name: `Trulioo`
- minimum iOS version: `15.0`

The package includes the runtime components required by the public Trulioo Device API.

Supported iOS integrations must use the Trulioo-supported runtime contract for the current package version.

- the Trulioo iOS SDK requires the encrypted payload bundle from the runtime submit callback
- runtime paths that only expose `eventId` are unsupported
- `eventId` remains part of the Trulioo device event model for polling and diagnostics after seed submission succeeds

## Installation

Add the package:

```swift
dependencies: [
    .package(url: "<your Trulioo package URL>", from: "<version>")
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
- `Trulioo.sendDeviceInformation(...)`
- `Trulioo.collectDeviceIntelligence(...)`
- `Trulioo.getDeviceInformation(...)`
- `Trulioo.pollMetadataStatus(...)`

Important types:

- `Trulioo.InitializationOptions`
- `Trulioo.InitializationResult`
- `Trulioo.DeviceInformationSendOptions`
- `SendDeviceInformationResult`
- `DeviceIntelligencePollingOptions`
- `DeviceSubjectReference`
- `DeviceSubjectOtherField`
- `DeviceSeedResponse`
- `DeviceEventResponse`
- `DebugTraceEntry`

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

## Recommended Send Pattern

Use fire-and-forget send as the default production integration:

```swift
let result = await Trulioo.sendDeviceInformation(
    initialization: initialized,
    options: Trulioo.DeviceInformationSendOptions(
        reference: DeviceSubjectReference(
            firstName: "Jane",
            lastName: "Doe",
            dateOfBirth: "1990-01-01",
            phoneNumber: "+15551234567"
        )
    )
)
```

`sendDeviceInformation(...)`, `collectDeviceIntelligence(...)`, and `getDeviceInformation(...)` also accept `userId`.

Use `userId` only when your downstream device-intelligence runtime expects a runtime-specific user identifier. It is not a Trulioo transaction ID replacement.

### Important Rules

- send happens after initialization
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

## Metadata Polling

The iOS SDK also exposes metadata polling for desktop-to-mobile handoff cases:

```swift
let status = try await Trulioo.pollMetadataStatus(
    shortcode: shortcode,
    transactionId: transactionId,
    accessToken: accessToken
)
```

Use this only when your flow needs to follow the desktop-to-mobile metadata status lifecycle.

## Polling

Default polling:

- `maxAttempts = 32`
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
  Support and troubleshooting timeline.

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

## QA Validation Checklist

A junior QA engineer can validate an iOS integration with this checklist:

1. Initialize with a valid shortcode.
2. Confirm initialization succeeds.
3. Confirm device intelligence is enabled in session configuration when expected.
4. Trigger send.
5. Confirm the SDK returns accepted or failed.
6. If using the debug wait path, confirm `deviceEvent.status` reaches a terminal state and `deviceSeed` appears when expected.
7. Confirm `debugTrace` contains:
   - `challenge`
   - `authorize`
   - `session_configuration`
   - `device_bridge_initialize`
   - `device_bridge_submit`
   - `device_event_seed`
   - `device_event_poll`
   - `device_event_terminal`
8. If subject data was passed, confirm `device_reference_submit` exists.

## Common Mistakes

- assuming initialization also performs collection
- trying to pass runtime credential data from app code
- coupling app-owned form data with SDK-owned basic-information fields
- treating reference failure as a full collection failure
- enabling native debug logging in normal production builds without need

## Troubleshooting

If device intelligence does not run:

1. Confirm initialization succeeded.
2. Confirm `configuration.deviceIntelligence?.enabled == true`.
3. Confirm the backend returned a device credential.
4. Confirm send was explicitly invoked, or confirm the debug wait path was intentionally chosen.
5. Inspect `debugTrace`.

If the terminal event failed:

1. inspect `deviceEvent?.failureReason`
2. inspect processor details when present
3. compare the terminal event with the `device_reference_submit` trace so reference failure is not mistaken for full collection failure

## Support Handoff Checklist

When handing an iOS issue to support or engineering, capture:

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
