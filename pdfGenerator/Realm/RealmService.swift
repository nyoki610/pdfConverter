//
//  RealmService.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/01.
//

import Foundation
import RealmSwift


class RealmService: ObservableObject {
    
    private var notificationToken: NotificationToken?
    var realm: Realm?
    
    @Published var projects: [Project] = []
    var titleOptions: [Option] = []
    var detailOptions: [Option] = []
    
    var selectedProjectIndex: Int = 0
    var selectedProject: Project { projects[selectedProjectIndex] }
    
    init() {
        setupRealm()
        fetchProjects()
        setupOptions()
        observeRealmChanges()
    }
    
    func setupRealm() {
        
        guard let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("projects.realm") else {
            
            print("Error: Failed to find user's Realm file directory.")
            return
        }
        
        do {
            let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
            realm = try Realm(configuration: config)
            
            print("Log: Realm file successfully accessed at \(realmURL.path)")
            return
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
    
    func fetchProjects() {
        guard let realm = realm else { return }
        let results = realm.objects(RealmProject.self)
        self.projects = results.compactMap { $0.convertToNonRealm() }
        print("Log: Realm objects were successfully fetched.")
    }
        
    private func observeRealmChanges() {
        guard let realm = realm else { return }

        notificationToken = realm.observe { [weak self] notification, realm in
            guard let self = self else { return }

            switch notification {
            case .didChange:
                print("Log: Realm database was modified.")
                self.fetchProjects()
                self.setupOptions()
            case .refreshRequired:
                print("Log: Realm requires a refresh.")
            }
        }
    }
    
    
    func addNewRealmProject(add realmProject: RealmProject) {
        
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(realmProject)
            }
        } catch {}
    }
    
    func setupOptions() {
        titleOptions = []
        detailOptions = []

        // オプションを追加する共通処理
        func addOption(to options: inout [Option], label: String) {
            guard !label.isEmpty else { return }
            
            if let index = options.firstIndex(where: { $0.label == label }) {
                options[index].count += 1
            } else {
                options.append(Option(label: label))
            }
        }

        // プロジェクトの内容に基づいてオプションを追加
        for project in projects {
            for content in project.contents {
                addOption(to: &titleOptions, label: content.title)
                addOption(to: &detailOptions, label: content.detail)
            }
        }
        
        // count プロパティで降順にソート
        titleOptions.sort { $0.count > $1.count }
        detailOptions.sort { $0.count > $1.count }
    }
}
