import Foundation

class TimeFlowViewModel: ObservableObject {
    @Published var timeUIState = TimeUIState(leftHours: 0, rightHours: 0, leftMinutes: 0, rightMinutes: 0, date: "04.29.2024")
    
    @objc func updateTime() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        timeUIState = TimeUIState(
            leftHours: hour / 10,
            rightHours: hour % 10,
            leftMinutes: minute / 10,
            rightMinutes: minute % 10,
            date: dateString
        )
    }
    
    private var timer: Timer?
    
    func autoUpdateTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    deinit {
        timer?.invalidate()
    }
}
