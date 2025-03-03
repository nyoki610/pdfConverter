import SwiftUI

class ScreenSizeManager: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0

    init() {
        updateScreenSize()
    }

    func updateScreenSize() {
        let screenBounds = UIScreen.main.bounds
        self.width = screenBounds.width
        self.height = screenBounds.height
    }
}
