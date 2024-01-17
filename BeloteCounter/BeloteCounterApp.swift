//
//  BeloteCounterApp.swift
//  BeloteCounter
//
//  Created by Peter Szots on 07/07/2022.
//

import SwiftUI

@main
struct BeloteCounterApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
