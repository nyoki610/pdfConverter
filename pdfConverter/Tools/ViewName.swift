import SwiftUI

enum ViewName {
    
    case projectList
    case contentsList
    
    func viewForName() -> some View {
        
        switch self {
            
        case .projectList: return AnyView(ProjectsListView())
        case .contentsList: return AnyView(ContentsListView())
        }
    }
}

