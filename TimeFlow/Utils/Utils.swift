import Foundation
import UIKit

let isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)

let timeFont: Double = isPad ? 288.0 : 144.0

let dateFont: Double = 32.0

let amOrOmFont: Double = isPad ? 48.0: 24.0
