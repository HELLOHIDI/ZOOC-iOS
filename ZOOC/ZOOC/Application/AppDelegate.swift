//
//  AppDelegate.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth

import FirebaseMessaging
import FirebaseCore

import Sentry


@main
class AppDelegate: UIResponder,
                    UIApplicationDelegate,
                    UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(#function)
        User.shared.fcmToken = "hellohidiFCM"
        
        
        KakaoSDK.initSDK(appKey: "d594d72f1d6a6935702b35865faf122f")
        FirebaseApp.configure()
        
        SentrySDK.start { options in
                options.dsn = "https://d231bfb30d614722b80fa6f2fe5c43f5@o4505115856666624.ingest.sentry.io/4505115938127872"
                options.debug = false // Enabled debug when first installing is always helpful
            }
        
       
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()        
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔫🔫🔫🔫🔫🔫🔫🔫🔫")
        print(#function)
        print("Firebase registration token: \(String(describing: fcmToken))")

          let dataDict: [String: String] = ["token": fcmToken ?? ""]
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
        
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
              } else if let token = token {
                  User.shared.fcmToken = token
                 print("FCM registration token: \(token)")
              }
        }
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("🔫🔫🔫🔫🔫🔫🔫🔫🔫")
        print(#function)
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🔫🔫🔫🔫🔫🔫🔫🔫🔫")
        print(#function)
       print("Unable to register for remote notifications: \(error.localizedDescription)")
     }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔫🔫🔫🔫🔫🔫🔫🔫🔫")
        print(#function)
        completionHandler([UNNotificationPresentationOptions.alert,
                          UNNotificationPresentationOptions.badge,
                          UNNotificationPresentationOptions.sound])
    }
    
}
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }




    
