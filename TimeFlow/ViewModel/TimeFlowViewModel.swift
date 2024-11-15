import Foundation
import Combine
import SwiftUI

class TimeFlowViewModel: ObservableObject {
    private var isFirstUpdate: Bool = true
    
    @Published var timeUIState = TimeUIState(
        leftHours: 0,
        rightHours: 0,
        leftMinutes: 0,
        rightMinutes: 0,
        date: "04.29.2024",
        amOrPm: true,
        timeFormat: true
    )
    
    @Published var isPortrait: Bool = (UIScreen.main.bounds.height > UIScreen.main.bounds.width)
    
    private func updateTime() {
        DispatchQueue.global(qos: .background).async {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy"
            let dateString = dateFormatter.string(from: date)
            let calendar = Calendar.current
            
            let hourOfDay = calendar.component(.hour, from: date)
            
            let hour = if (UserDefaults.standard.bool(forKey: "timeFormat")) {
                hourOfDay
            } else {
                switch(hourOfDay) {
                    case 12: 12
                    default: hourOfDay % 12
                }
            }
            
            let minute = calendar.component(.minute, from: date)
            
            let second = calendar.component(.second, from: date)
            if (self.isFirstUpdate || second == 0) {
                DispatchQueue.main.async {
                    self.timeUIState = TimeUIState(
                        leftHours: hour / 10,
                        rightHours: hour % 10,
                        leftMinutes: minute / 10,
                        rightMinutes: minute % 10,
                        date: dateString,
                        amOrPm: hourOfDay < 12,
                        timeFormat: UserDefaults.standard.bool(forKey: "timeFormat")
                    )
                    self.isFirstUpdate = false
                }
            }
        }
    }
    
    func updateTimeFormat() {
        let currentTimeFormat = UserDefaults.standard.bool(forKey: "timeFormat")
        UserDefaults.standard.setValue(!currentTimeFormat, forKey: "timeFormat")
        self.updateTime()
    }
    
    var timer: DispatchSourceTimer?
    func startTimer() {
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler {
            self.updateTime()
        }
        timer?.resume()
    }
    
    func stopTimer() {
        self.timer?.cancel()
        timer = nil
    }
}
