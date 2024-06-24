import SwiftUI
import SwiftData

@main
struct TimeFlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView { leftHours, rightHours, leftMinutes, rightMinutes in
                GeometryReader { geometryReaders in
                    HStack(alignment: .center, spacing: -10.0, content: {
                        Text(String(leftHours))
                            .font(.custom("poppins_bold.ttf", size: timeFont))
                            .foregroundColor(.white)
                        Text(String(rightHours))
                            .font(.custom("poppins_bold.ttf", size: timeFont))
                            .foregroundColor(.white)
                    }).frame(width: geometryReaders.size.width, height: geometryReaders.size.height)
                }
                
                GeometryReader { geometryReaders in
                    HStack(alignment: .center, spacing: -10.0, content: {
                        Text(String(leftMinutes))
                            .font(.custom("poppins_bold.ttf", size: timeFont))
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
