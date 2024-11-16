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
            Group {
                if (viewModel.isPortrait) {
                    VStack(alignment: .trailing, content: {
                        getCardHStack(timeUIState: timeUIState, isHourCard: isHourCard)
                        
                        ZStack(alignment: .trailing, content: {
                            Text(timeUIState.amOrPm ? "AM" : "PM")
                                .opacity((isHourCard && !timeUIState.timeFormat) ? 1.0 : 0.0)
                                .font(.custom("Poppins-Bold", size: amOrOmFont))
                                .foregroundColor(.white)
                        })
                    })
                } else {
                    HStack(alignment: .center, spacing: 0, content: {
                        getCardHStack(timeUIState: timeUIState, isHourCard: isHourCard)
                        
                        ZStack(alignment: .bottomTrailing, content: {
                            Text(timeUIState.amOrPm ? "AM" : "PM")
                                .opacity((isHourCard && !timeUIState.timeFormat) ? 1.0 : 0.0)
                                .font(.custom("Poppins-Bold", size: amOrOmFont))
                                .foregroundColor(.white)
                        })
                        .padding(.trailing, 20)
                        .frame(height: 200, alignment: Alignment.bottomTrailing)
                    })
                }
            }
            .padding()
            .background(Color.clear)
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
    }
    
    private func getCardHStack(timeUIState: TimeUIState, isHourCard: Bool) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Image("ic_number\(isHourCard ? timeUIState.leftHours : timeUIState.leftMinutes)_ios")
                .resizable()
                .scaledToFit()
                .frame(width: timeCardWidth, height: timeCardHeight)
            
            Image("ic_number\(isHourCard ? timeUIState.rightHours : timeUIState.rightMinutes)_ios")
                .resizable()
                .scaledToFit()
                .frame(width: timeCardWidth, height: timeCardHeight)
        }
    }
}
