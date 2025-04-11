//
//  ProjectListView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/01.
//

import SwiftUI

struct ProjectsListView: View {
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var customAlertHandler: CustomAlertHandler
    @EnvironmentObject var alertSharedData: AlertSharedData

    var body: some View {
        
        NavigationStack(path: $sharedData.path) {
            
            ZStack {
                ScrollView {
                    ForEach(Array(realmService.projects.enumerated()), id: \.element.id) { index, project in
                        Button {
                            realmService.selectedProjectIndex = index
                            sharedData.path.append(.contentsList)
                        } label: {
                            projectButtonLabel(project: project)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }
                    
                    Color.clear
                        .frame(width: 100, height: 80)
                }
                .padding(.top, 40)
                
                VStack {
                    
                    Spacer()
                    HStack {
                        Spacer()
                        TLButton(systemName: "plus.circle.fill",
                                 label: "新規プロジェクトを作成",
                                 color: .green) {
                            customAlertHandler.controllCustomAlert(
                                alertTitle: "新規プロジェクトを作成",
                                label: "プロジェクト名を入力",
                                action: createNewProject)
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(.clear)
                }
                
                if realmService.projects.isEmpty {
                    VStack {
                        Text("プロジェクトがありません")
                        Text("新規作成してください")
                    }
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                }
            }
            .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3))
            .ignoresSafeArea(.keyboard)
            .navigationDestination(for: ViewName.self) { viewName in
                viewName.viewForName()
            }
        }
    }
    
    @ViewBuilder
    private func projectButtonLabel(project: Project) -> some View {
        
        VStack(alignment: .leading) {
            
            Text(project.title)
                .fontWeight(.bold)
                .padding(.bottom, 4)

            Text("作成日 \(project.createdDate.formattedString())")
            Text("最終更新日 \(project.lastUsedDate.formattedString())")
            Text("要素数 \(project.contents.count)")
            
            HStack {
                TLButton(systemName: "pencil.line",
                         label: "プロジェクト名を変更",
                         color: .blue,
                         size: 14) {
                    customAlertHandler.controllCustomAlert(
                        alertTitle: "プロジェクト名を変更",
                        label: "プロジェクト名を入力",
                        action: {
                            project.updateSelf(realm: realmService.realm,
                                               title: customAlertHandler.userInput)
                        })
                }
                         .padding(.trailing, 40)
                
                Spacer()
                
                DeleteButton {
                    alertSharedData.showSelectiveAlert(
                        title: "プロジェクトを削除",
                        message: "この操作は取り消せません",
                        closeAction: {},
                        rightButtonLabel: "削除",
                        rightButtonType: AlertSharedData.RightButtonType.destructive,
                        rightButtonAction: {
                            project.deleteSelf(realm: realmService.realm)
                        })
                }
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(.white)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func createNewProject() {
        let newProject = Project(id: UUID().uuidString,
                                 title: customAlertHandler.userInput,
                                 createdDate: Date(),
                                 lastUsedDate: Date(),
                                 coverPage: nil,
                                 contents: [])
        realmService.addNewRealmProject(add: newProject.convertToRealm())
    }
}
