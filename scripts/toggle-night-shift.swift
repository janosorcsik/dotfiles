#!/usr/bin/env swift

// @raycast.schemaVersion 1
// @raycast.title Toggle Night Shift
// @raycast.mode silent
// @raycast.icon 🌙

import Foundation

struct Time {
    var hour: Int32 = 0
    var minute: Int32 = 0
}

struct Schedule {
    var from = Time()
    var to = Time()
}

struct BlueLightStatus {
    var active: Bool = false
    var enabled: Bool = false
    var sunSchedulePermitted: Bool = false
    var mode: Int32 = 0
    var schedule = Schedule()
    var disableFlags: UInt64 = 0
    var available: Bool = false
}

guard dlopen("/System/Library/PrivateFrameworks/CoreBrightness.framework/CoreBrightness", RTLD_LAZY) != nil,
      let cls = NSClassFromString("CBBlueLightClient") as? NSObject.Type
else {
    print("CoreBrightness unavailable")
    exit(1)
}

let client = cls.init()
let getStatusSel = NSSelectorFromString("getBlueLightStatus:")
let setEnabledSel = NSSelectorFromString("setEnabled:")

let getStatus = unsafeBitCast(
    client.method(for: getStatusSel),
    to: (@convention(c) (AnyObject, Selector, UnsafeMutableRawPointer) -> Bool).self
)
let setEnabled = unsafeBitCast(
    client.method(for: setEnabledSel),
    to: (@convention(c) (AnyObject, Selector, Bool) -> Bool).self
)

var status = BlueLightStatus()
guard withUnsafeMutablePointer(to: &status, { getStatus(client, getStatusSel, $0) }) else {
    print("Failed to get Night Shift status")
    exit(1)
}
guard setEnabled(client, setEnabledSel, !status.enabled) else {
    print("Failed to toggle Night Shift")
    exit(1)
}
