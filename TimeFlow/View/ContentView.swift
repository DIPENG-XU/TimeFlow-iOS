import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = TimeFlowViewModel()
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    var body: some View {
        Group {
            VStack(alignment: .center, content: {
                if (viewModel.isPortrait) {
                    VStack(alignment: .center, spacing: nil, content: {
                        getContent(left: viewModel.timeUIState.leftHours, right: viewModel.timeUIState.rightHours)
                        getContent(left: viewModel.timeUIState.leftMinutes, right: viewModel.timeUIState.rightMinutes)
                    }).background(Color.black)
                } else {
                    HStack(alignment: .center, spacing: nil, content: {
                        getContent(left: viewModel.timeUIState.leftHours, right: viewModel.timeUIState.rightHours)
                        getContent(left: viewModel.timeUIState.leftMinutes, right: viewModel.timeUIState.rightMinutes)
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
        }
        .background(.black)
    }
    
    private func getContent(left: Int, right: Int) -> some View {
        return
            GeometryReader { geometryProxy in
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
                .padding()
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            }
    }
}
