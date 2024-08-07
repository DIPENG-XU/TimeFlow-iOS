import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = TimeFlowViewModel()
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    var body: some View {
        Group {
            VStack(alignment: .center, content: {
                if (viewModel.isPortrait) {
                    VStack(alignment: .center, spacing: nil, content: {
                        getContent(
                            left: viewModel.timeUIState.leftHours,
                            right: viewModel.timeUIState.rightHours, 
                            isHourCard: true,
                            amOrPm: viewModel.timeUIState.amOrPm,
                            timeFormat: viewModel.timeUIState.timeFormat
                        ).onTapGesture {
                            viewModel.updateTimeFormat()
                        }
                        getContent(
                            left: viewModel.timeUIState.leftMinutes,
                            right: viewModel.timeUIState.rightMinutes,
                            isHourCard: false,
                            amOrPm: viewModel.timeUIState.amOrPm,
                            timeFormat: viewModel.timeUIState.timeFormat
                        )
                    }).background(Color.black)
                } else {
                    HStack(alignment: .center, spacing: nil, content: {
                        getContent(
                            left: viewModel.timeUIState.leftHours,
                            right: viewModel.timeUIState.rightHours,
                            isHourCard: true,
                            amOrPm: viewModel.timeUIState.amOrPm,
                            timeFormat: viewModel.timeUIState.timeFormat
                        ).onTapGesture {
                            viewModel.updateTimeFormat()
                        }
                        getContent(
                            left: viewModel.timeUIState.leftMinutes,
                            right: viewModel.timeUIState.rightMinutes,
                            isHourCard: false,
                            amOrPm: viewModel.timeUIState.amOrPm,
                            timeFormat: viewModel.timeUIState.timeFormat
                        )
                    }).background(Color.black)
                }
            })
        }.onReceive(orientationPublisher) { _ in
            switch (UIDevice.current.orientation) {
                case .portrait, .portraitUpsideDown:
                    viewModel.isPortrait = true
                case .landscapeLeft, .landscapeRight:
                    viewModel.isPortrait = false
                default: 
                    break
            }
        }.onAppear() {
            viewModel.startTimer()
        }.onDisappear() {
            viewModel.stopTimer()
        }
        .background(.black)
    }
    
    let timeCardWidth = 160.0
    let timeCardHeight = 400.0
    
    private func getContent(left: Int, right: Int, isHourCard: Bool = false, amOrPm: Bool = false, timeFormat: Bool = true) -> some View {
        return GeometryReader { geometryProxy in
            VStack(alignment: .trailing, content: {
                HStack(alignment: .center) {
                    Image("ic_number\(left)_ios")
                        .resizable()
                        .scaledToFit()
                        .frame(width: timeCardWidth, height: timeCardHeight)
                    
                    Image("ic_number\(right)_ios")
                        .resizable()
                        .scaledToFit()
                        .frame(width: timeCardWidth, height: timeCardHeight)
                    
                }.frame(width: timeCardWidth * 2, height: timeCardHeight)
                
                Spacer()
                    .frame(height: 16)
                
                ZStack(alignment: .trailing, content: {
                    Text(amOrPm ? "AM" : "PM")
                        .opacity((isHourCard && !timeFormat) ? 1.0 : 0.0)
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
