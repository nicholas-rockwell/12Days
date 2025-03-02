//
//  _2DaysApp.swift
//  12Days
//
//  Created by Nicholas Rockwell on 2/26/25.
//

import Amplify
import Authenticator
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import SwiftUI
import SwiftData

@main
struct _2DaysApp: App {
    
    // Configure Amplify
    init() {
        configureAmplify()
    }
    
    // Swift Data Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // View
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    // Amplify Configuration
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure(with: .amplifyOutputs)
            print("Amplify configured successfully")
        } catch {
            print("Failed to configure Amplify: \(error)")
        }
    }
}
