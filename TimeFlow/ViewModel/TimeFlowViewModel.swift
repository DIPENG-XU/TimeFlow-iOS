import Foundation

class TimeFlowViewModel: ObservableObject {
    @Published var timeUIState = TimeUIState(leftHours: 0, rightHours: 0, leftMinutes: 0, rightMinutes: 0, date: "04.29.2024")
    
    @objc func updateTime() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm MM.dd.yyyy"
        
        let dateString = dateFormatter.string(from: currentDate)
        let leftHours = dateString[dateString.index(dateString.startIndex, offsetBy: 0)]
        let rightHours = dateString[dateString.index(dateString.startIndex, offsetBy: 1)]
        let leftMinutes = dateString[dateString.index(dateString.startIndex, offsetBy: 2)]
        let rightMinutes = dateString[dateString.index(dateString.startIndex, offsetBy: 3)]
        
        let date = dateString.substring(from: dateString.index(dateString.startIndex, offsetBy: 5))
        
        timeUIState = TimeUIState(
            leftHours: Int(String(leftHours))!,
            rightHours: Int(String(rightHours))!,
            leftMinutes: Int(String(leftMinutes))!,
            rightMinutes: Int(String(rightMinutes))!,
            date: String(date)
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
