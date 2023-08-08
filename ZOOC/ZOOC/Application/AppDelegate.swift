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
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("👼🏻 \(#function)")
        print(Config.baseURL)
        #if DEBUG
        print("디버그야!!!")
        #else
        print("디버그 아니야!!!")
        #endif
        setUserNotification(application)
        setKaKaoSDK()
        setFirebaseMessaging()
        setSentry()
        
        
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("👼🏻 \(#function)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("👼🏻 \(#function)")
        print("Unable to register for remote notifications: \(error.localizedDescription)")
     }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("👼🏻 \(#function)")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("👼🏻 \(#function)")
    }

}

//MARK: - Custom Setting

extension AppDelegate {
    
    private func setUserNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
    }
    
    
    private func setKaKaoSDK() {
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    }
    
    private func setFirebaseMessaging() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    private func setSentry() {
        SentrySDK.start { options in
            options.dsn = Config.sentryDSN
            options.debug = false
        }
    }
    
    
}

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.list, .banner, .sound])
   }
}


//MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📍 Firebase registration token: \(fcmToken ?? "nil"))")

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
              } else if let token = token {
                  UserDefaultsManager.fcmToken = token
                 print("FCM registration token: \(token)")
              }
        }
    }
}





    
