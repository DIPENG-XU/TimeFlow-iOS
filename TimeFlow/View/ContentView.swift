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
                        )
                        getContent(left: viewModel.timeUIState.leftMinutes, right: viewModel.timeUIState.rightMinutes)
                    }).background(Color.black)
                        .onTapGesture {
                            viewModel.updateTimeFormat()
                        }
                        
                } else {
                    HStack(alignment: .center, spacing: nil, content: {
                        getContent(
                            left: viewModel.timeUIState.leftHours,
                            right: viewModel.timeUIState.rightHours,
                            isHourCard: true,
                            amOrPm: viewModel.timeUIState.amOrPm,
                            timeFormat: viewModel.timeUIState.timeFormat
                        )
                        getContent(left: viewModel.timeUIState.leftMinutes, right: viewModel.timeUIState.rightMinutes)
                    }).background(Color.black)
                        .onTapGesture {
                            viewModel.updateTimeFormat()
                        }
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
        }
        .background(.black)
    }
    
    private func getContent(left: Int, right: Int, isHourCard: Bool = false, amOrPm: Bool = false, timeFormat: Bool = true) -> some View {
        return
            GeometryReader { geometryProxy in
                VStack(alignment: .trailing, content: {
                    HStack(alignment: .center, spacing: 4.0) {
                        Text(String(left))
                            .font(.custom("poppins_bold.ttf", size: timeFont))
                            .foregroundColor(.white)
                            .frame(alignment: .leadingLastTextBaseline)
                        
                        Text(String(right))
                            .font(.custom("poppins_bold.ttf", size: timeFont))
                            .foregroundColor(.white)
                            .frame(alignment: .leadingFirstTextBaseline)
                    }
                    
                    if (isHourCard && !timeFormat) {
                        Spacer()
                            .frame(height: 16)
                        
                        ZStack(alignment: .trailing, content: {
                            Text(amOrPm ? "AM": "PM")
                                .font(.custom("poppins_bold.ttf", size: amOrOmFont))
                                .foregroundColor(.white)
                        })
                    }
                })
                .padding()
                .background(Color.clear)
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            }
    }
}
