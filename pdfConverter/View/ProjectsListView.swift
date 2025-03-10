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
                        Button {
                            customAlertHandler.controllCustomAlert(
                                alertTitle: "新規プロジェクトを作成",
                                label: "プロジェクト名を入力",
                                action: createNewProject)
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                Text("新規プロジェクトを作成")
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(.clear)
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
            HStack {
                Text("要素数 \(project.contents.count)")
                Spacer()
                
                Button {
                    alertSharedData.showSelectiveAlert(
                        title: "プロジェクトを削除",
                        message: "この操作は取り消せません",
                        closeAction: {},
                        rightButtonLabel: "削除",
                        rightButtonType: AlertSharedData.RightButtonType.destructive,
                        rightButtonAction: {
                            project.deleteSelf(realm: realmService.realm)
                        })
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("削除")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                }
                .buttonStyle(.automatic)
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
                                 contents: [])
        realmService.addNewRealmProject(add: newProject.convertToRealm())
    }
}
