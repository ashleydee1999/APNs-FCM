//
//  AppDelegate.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/15.
//

import Foundation
import SwiftUI
import Firebase
import UserNotifications
import BackgroundTasks
import CoreData


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          Messaging.messaging().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("OPEN", comment: "open"), options: UNNotificationActionOptions.foreground)
        let deafultCategory = UNNotificationCategory(identifier: "myNotificationCategory", actions: [openAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories(Set([deafultCategory]))
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        switch application.applicationState {
        case .active:
            print("active")
        case .background:
            print("background")
        case .inactive:
            break
        @unknown default:
            break
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().apnsToken = deviceToken;
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
     print("APNS FCM Registration failed!")
    }
    
}

extension AppDelegate: MessagingDelegate{
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
        print("deviceToken: ", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
  
}

extension AppDelegate: UNUserNotificationCenterDelegate{

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    NotificationCenter.default.post(name: Notification.Name.didReceiveNotification, object: nil)
    let userInfo = notification.request.content.userInfo
    print("will Present")
    print(userInfo)
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    completionHandler([[.alert, .sound]])
  }

}


