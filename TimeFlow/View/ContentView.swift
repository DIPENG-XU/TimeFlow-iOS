import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = TimeFlowViewModel()
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        Group {
            VStack(alignment: .center, content: {
                if (viewModel.isPortrait) {
                    VStack(alignment: .center, spacing: nil, content: {
                        getContent(
                            timeUIState: viewModel.timeUIState,
                            isHourCard: true
                        ).onTapGesture {
                            viewModel.updateTimeFormat()
                        }
                        getContent(
                            timeUIState: viewModel.timeUIState,
                            isHourCard: false
                        )
                    }).background(Color.black)
                } else {
                    HStack(alignment: .center, spacing: nil, content: {
                        getContent(
                            timeUIState: viewModel.timeUIState,
                            isHourCard: true
                        ).onTapGesture {
                            viewModel.updateTimeFormat()
                        }
                        getContent(
                            timeUIState: viewModel.timeUIState,
                            isHourCard: false
                        )
                    }).background(Color.black)
                }
            })
        }.onChange(of: scenePhase, perform: { newPhase in
            if newPhase == .active {
                viewModel.startTimer()
            } else if newPhase == .background {
                viewModel.stopTimer()
            }
        })
        .onReceive(orientationPublisher) { _ in
            switch (UIDevice.current.orientation) {
                case .portrait, .portraitUpsideDown:
                    viewModel.isPortrait = true
                case .landscapeLeft, .landscapeRight:
                    viewModel.isPortrait = false
                default: 
                    break
            }
        }
        .background(.black)
    }
    
    let timeCardWidth = 120.0
    let timeCardHeight = 300.0
    
    private func getContent(timeUIState: TimeUIState, isHourCard: Bool = true) -> some View {
        return GeometryReader { geometryProxy in
            VStack(alignment: .trailing, content: {
                HStack(alignment: .center) {
                    Image("ic_number\(isHourCard ? timeUIState.leftHours : timeUIState.leftMinutes)_ios")
                        .resizable()
                        .scaledToFit()
                        .frame(width: timeCardWidth, height: timeCardHeight)
                    
                    Image("ic_number\(isHourCard ? timeUIState.rightHours : timeUIState.rightMinutes)_ios")
                        .resizable()
                        .scaledToFit()
                        .frame(width: timeCardWidth, height: timeCardHeight)
                    
                }.frame(width: timeCardWidth * 2, height: timeCardHeight)
                
                Spacer()
                    .frame(height: 16)
                
                ZStack(alignment: .trailing, content: {
                    Text(timeUIState.amOrPm ? "AM" : "PM")
                        .opacity((isHourCard && !timeUIState.timeFormat) ? 1.0 : 0.0)
                        .font(.custom("poppins_bold.ttf", size: amOrOmFont))
                        .foregroundColor(.white)
                })
            })
            .padding()
            .background(Color.clear)
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
    }
}
