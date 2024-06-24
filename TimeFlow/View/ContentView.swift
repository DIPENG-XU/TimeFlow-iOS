import SwiftUI
import SwiftData

struct ContentView<Content: View>: View {
    
    @ObservedObject var viewModel = TimeFlowViewModel()
    
    @State private var isPortrait:Bool = (UIScreen.main.bounds.height > UIScreen.main.bounds.width)
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    let content: (String, String, String, String) -> Content
    
    init(@ViewBuilder content: @escaping (String, String, String, String) -> Content) {
        self.content = content
        viewModel.updateTime()
        viewModel.autoUpdateTime()
    }
    
    var body: some View {
        Group {
            VStack(alignment: .center, content: {
                if (self.isPortrait) {
                    VStack(alignment: .center, spacing: nil, content: {
                        getTheContent()
                    }).background(Color.black)
                } else {
                    HStack(alignment: .center, spacing: nil, content: {
                        getTheContent()
                    }).background(Color.black)
                }
            })
        }.onReceive(orientationPublisher) { _ in
            switch (UIDevice.current.orientation) {
            case .portrait:
                self.isPortrait = true
            case .landscapeLeft, .landscapeRight:
                self.isPortrait = false
            default:
                break
            }
        }.background(.black)
    }
    
    private func getTheContent() -> Content {
        return self.content(
            String(viewModel.timeUIState.leftHours),
            String(viewModel.timeUIState.rightHours),
            String(viewModel.timeUIState.leftMinutes),
            String(viewModel.timeUIState.rightMinutes)
        )
    }
}
