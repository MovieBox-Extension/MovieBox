//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import SwiftUI
import UIKit
import RealmSwift
import Kingfisher

@main
struct MovieBoxApp: App {

    init() {
        let tabAp = UITabBarAppearance()

        tabAp.backgroundColor = .clear
        UITabBar.appearance().standardAppearance = tabAp
        UITabBar.appearance().scrollEdgeAppearance = tabAp
        UITabBar.appearance().unselectedItemTintColor = .lightGray

        let navAp1 = UINavigationBarAppearance()
        let navAp2 = UINavigationBarAppearance()

        navAp1.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navAp1
        navAp2.configureWithOpaqueBackground()
        navAp2.backgroundColor = .background
        UINavigationBar.appearance().standardAppearance = navAp2

        // Configure Kingfisher cache
        let cache = ImageCache.default
        // Memory cache: 100 MB (holds ~50-100 images for better performance)
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        // Memory cache expiration: 10 minutes
        cache.memoryStorage.config.expiration = .seconds(600)
        // Disk cache: 500 MB (increased for better offline experience)
        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
        // Disk cache expiration: 7 days
        cache.diskStorage.config.expiration = .days(7)

        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
        }
    }
}

