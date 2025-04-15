import SwiftUI


protocol ResponsiveView: View {
    var deviceType: DeviceType { get }
}

extension ResponsiveView {
    func responsiveSize(_ iPhoneFloat: CGFloat, _ iPadFloat: CGFloat) -> CGFloat {
        (deviceType == .iPhone) ? iPhoneFloat : iPadFloat
    }
    
    func responsiveScaled(_ iPhoneFloat: CGFloat, _ scale: CGFloat) -> CGFloat {
        (deviceType == .iPhone) ? iPhoneFloat : iPhoneFloat * scale
    }
}
