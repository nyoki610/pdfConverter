import SwiftUI


enum DeviceType {
    case iPhone, iPad, unknown

    static var model: DeviceType {
        let model = UIDevice.current.model
        if model.contains("iPad") {
            return .iPad
        } else if model.contains("iPhone") {
            return .iPhone
        } else {
            return .unknown
        }
    }
    
    var description: String {
        switch self {
        case .iPhone: return "iPhone"
        case .iPad: return "iPad"
        default: return "unknown"
        }
    }
}

extension EnvironmentValues {
    @Entry var deviceType: DeviceType = DeviceType.model
}

