import SwiftUI

enum ViewName {
    
    case projectList
    case contentsList
    case pdfViewer
    
    func viewForName() -> some View {
        
        switch self {
            
        case .projectList: return AnyView(ProjectsListView())
        case .contentsList: return AnyView(ContentsListView())
        case .pdfViewer: return AnyView(PDFViewerView())
        }
    }
}

