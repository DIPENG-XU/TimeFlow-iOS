import Foundation

struct TimeUIState {
    var leftHours: Int
    var rightHours: Int
    var leftMinutes: Int
    var rightMinutes: Int
    var amOrPm: Bool        // true = AM, false = PM
    var timeFormat: Bool    // true = 24h, false = 12h
}
