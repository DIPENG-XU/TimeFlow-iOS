import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = TimeFlowViewModel()
    @Environment(\.scenePhase) var scenePhase
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)

    private let timeCardWidth: CGFloat = 120
    private let timeCardHeight: CGFloat = 300
    private let amPmFontSize: CGFloat = 24

    var body: some View {
        Group {
            mainContent
                .background(Color.black)
        }
        .onChange(of: scenePhase, perform: handleScenePhaseChange)
        .onReceive(orientationPublisher, perform: handleOrientationChange)
        .background(.black)
    }

    // MARK: - 主内容布局
    private var mainContent: some View {
        Group {
            if viewModel.isPortrait {
                VStack(spacing: 0) {
                    timeCard(isHourCard: true)
                    timeCard(isHourCard: false)
                }
            } else {
                HStack(spacing: 0) {
                    timeCard(isHourCard: true)
                    timeCard(isHourCard: false)
                }
            }
        }
    }

    // MARK: - 时间卡片
    private func timeCard(isHourCard: Bool) -> some View {
        let state = viewModel.timeUIState
        let amOrPmText = (!isHourCard || state.timeFormat) ? "  " : state.amOrPm ? "AM" : "PM";
        return Group {
            if viewModel.isPortrait {
                VStack(alignment: .trailing, spacing: 8) {
                    cardPair(timeUIState: state, isHourCard: isHourCard)
                        .onTapGesture { if isHourCard { viewModel.updateTimeFormat() } }

                    Text(amOrPmText)
                        .font(.custom("Poppins-Bold", size: amPmFontSize))
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                        .transition(.opacity)
                }
            } else {
                HStack(alignment: .bottom, spacing: 12) {
                    cardPair(timeUIState: state, isHourCard: isHourCard)
                        .onTapGesture { if isHourCard { viewModel.updateTimeFormat() } }

                    
                    Text(amOrPmText)
                        .font(.custom("Poppins-Bold", size: amPmFontSize))
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                        .transition(.opacity)
                }
            }
        }
        .padding()
        .background(Color.clear)
    }

    // MARK: - 数字卡片组合
    private func cardPair(timeUIState: TimeUIState, isHourCard: Bool) -> some View {
        HStack(spacing: 0) {
            timeImage(index: isHourCard ? timeUIState.leftHours : timeUIState.leftMinutes)
            timeImage(index: isHourCard ? timeUIState.rightHours : timeUIState.rightMinutes)
        }
    }

    // MARK: - 单个数字图片
    private func timeImage(index: Int) -> some View {
        Image("ic_number\(index)_ios")
            .resizable()
            .scaledToFit()
            .frame(width: timeCardWidth, height: timeCardHeight)
    }

    // MARK: - ScenePhase & Orientation
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active: viewModel.startTimer()
        case .background: viewModel.stopTimer()
        default: break
        }
    }

    private func handleOrientationChange(_ _: Notification) {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            viewModel.isPortrait = true
        case .landscapeLeft, .landscapeRight:
            viewModel.isPortrait = false
        default:
            break
        }
    }
}
