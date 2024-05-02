import SwiftUI
import SwiftData

@main
struct TimeFlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView { leftHours, rightHours, leftMinutes, rightMinutes in
                GeometryReader { geometryReaders in
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(String(leftHours))
                            .font(.system(size: timeFont))
                            .foregroundColor(.white)
                        Text(String(rightHours))
                            .font(.system(size: timeFont))
                            .foregroundColor(.white)
                    }).frame(width: geometryReaders.size.width, height: geometryReaders.size.height)
                }
                
                GeometryReader { geometryReaders in
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(String(leftMinutes))
                            .font(.system(size: timeFont))
                            .foregroundColor(.white)
                        Text(String(rightMinutes))
                            .font(.system(size: timeFont))
                            .foregroundColor(.white)
                    }).frame(width: geometryReaders.size.width, height: geometryReaders.size.height)
                }
            }
        }
    }
}
