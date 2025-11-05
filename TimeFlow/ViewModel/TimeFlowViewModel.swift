import Foundation
import Combine
import SwiftUI

final class TimeFlowViewModel: ObservableObject {
    @Published var timeUIState: TimeUIState
    @Published var isPortrait: Bool = true

    private var timer: AnyCancellable?

    init() {
        // 初始化时间
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        timeUIState = TimeFlowViewModel.makeTimeUIState(hour: hour, minute: minute, format24h: false)
        startTimer()
    }

    // MARK: - 定时器管理
    func startTimer() {
        stopTimer() // 避免重复启动
        
        let now = Date()
        let calendar = Calendar.current
        let nextMinute = calendar.nextDate(after: now, matching: DateComponents(second: 0), matchingPolicy: .nextTime)!
        let interval = nextMinute.timeIntervalSince(now) // 距离下一分钟的秒数

        // 延迟触发一次 Timer，到达整分钟
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.updateTime()
            // 每分钟触发一次
            self?.timer = Timer.publish(every: 60, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self?.updateTime()
                }
        }
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    // MARK: - 更新时间
    private func updateTime() {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        timeUIState = TimeFlowViewModel.makeTimeUIState(
            hour: hour,
            minute: minute,
            format24h: timeUIState.timeFormat
        )
    }

    // MARK: - 切换 12/24 小时制
    func updateTimeFormat() {
        timeUIState.timeFormat.toggle()
        updateTime()
    }

    // MARK: - 工具方法
    static func makeTimeUIState(hour: Int, minute: Int, format24h: Bool) -> TimeUIState {
        var displayHour = hour
        var am = true

        if !format24h {
            if hour >= 12 {
                am = false
                displayHour = hour > 12 ? hour - 12 : 12
            } else if hour == 0 {
                displayHour = 12
            }
        }

        let leftHours = displayHour / 10
        let rightHours = displayHour % 10
        let leftMinutes = minute / 10
        let rightMinutes = minute % 10

        return TimeUIState(
            leftHours: leftHours,
            rightHours: rightHours,
            leftMinutes: leftMinutes,
            rightMinutes: rightMinutes,
            amOrPm: am,
            timeFormat: format24h
        )
    }
}
