import Foundation
import Combine
import SwiftUI

class TimeFlowViewModel: ObservableObject {
    @Published var timeUIState = TimeUIState(leftHours: 0, rightHours: 0, leftMinutes: 0, rightMinutes: 0, date: "04.29.2024")
    @State var isPortrait: Bool = (UIScreen.main.bounds.height > UIScreen.main.bounds.width)
    
    private func updateTime() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let dateString = dateFormatter.string(from: date)
        let calendar = Calendar.current
        
        let hourOfDay = calendar.component(.hour, from: date)
        let hour = switch(hourOfDay) {
            case 12: 12
            default: hourOfDay % 12
        }
        let minute = calendar.component(.minute, from: date)
        
        timeUIState = TimeUIState(
            leftHours: hour / 10,
            rightHours: hour % 10,
            leftMinutes: minute / 10,
            rightMinutes: minute % 10,
            date: dateString
        )
    }
    
    init() {
        self.updateTime()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let calendar = Calendar.current
            let second = calendar.component(.second, from: Date())
            if (second == 0) {
                self.updateTime()
            }
        }
    }
}
