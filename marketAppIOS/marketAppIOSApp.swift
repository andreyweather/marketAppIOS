import SwiftUI
import Firebase
import FirebaseCore
import enkodpushlibrary
import FirebaseMessaging
import UserNotifications
    

@main

struct marketAppIOSApp: App {
    
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
           autorizationView()
        }
    }
}


 
