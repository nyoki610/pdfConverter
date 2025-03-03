//
//  RealmService.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/01.
//

import Foundation
import RealmSwift


class RealmService: ObservableObject {
    
    private var notificationToken: NotificationToken?
    var realm: Realm?
    
    @Published var projects: [Project] = []
    var selectedProjectId: String = ""
    var selectedProject: Project {
        projects.first { $0.id == selectedProjectId } ?? EmptyModel.project
    }
    
    init() {
        setupRealm()
        fetchProjects()
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
            case .refreshRequired:
                print("Log: Realm requires a refresh.")
            }
        }
    }
    
    func createNewRealmProject() {
        guard let realm = realm else { return }
        
        let newProject = Project(id: UUID().uuidString, title: "", createdDate: Date(), lastUsedDate: Date(), contents: [])

        do {
            try realm.write {
                realm.add(newProject.convertToRealm())
                print("Log: New project added successfully.")
            }
        } catch {
            print("Error: Failed to add new project - \(error.localizedDescription)")
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
}
