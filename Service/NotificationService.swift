//
//  NotificationService.swift
//  Service
//
//  Created by Debashish Das on 29/09/20.
//  Copyright © 2020 Debashish Das. All rights reserved.
//

import UserNotifications
import CoreData

@available(iOSApplicationExtension 13.0, *)
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    let coreDataManager = CoreDataManager(modelName: "ContactsCD")
//    let coreDataManager = CoreDataStack(moduleName: "ContactsCD")
    let fcm = FCMNotificationsHandler.shared
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        //---------------------------------------
        //MARK: Save to CoreData
        
        ///Here, I am saving notificaiton to coredata. # Message # is the subclass of NSManagedObject.
        ///If you don't need this, comment out this section !
        ///
        
        if let bestAttemptContent = bestAttemptContent {
            
//            fcm.receivedNotification(withUserInfo: bestAttemptContent.userInfo)
            
            let msg = ContactsCD(context: self.coreDataManager.mainManagedObjectContext)
            msg.id = 999
            msg.firstName = "Forground!"
            msg.lastName = "Test"
            self.coreDataManager.saveChanges()
            
        }
    }
    
    
    //MARK: - Parse Notification JSON
    
    private func getNotification(userInfo: [String: Any]) -> (String, String)? {
        guard let notification = userInfo["alert"] as? [String: Any] else { return nil }
        if let title = notification["title"] as? String, let body = notification["body"] as? String {
            return (title, body)
        }
        return nil
    }
    
    //MARK: - Image Downloader
    
    private func downloadImageFrom(url: String, handler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: URL(string: url)!) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else { handler(nil) ; return }
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                handler(attachment)
            } catch {
                print("attachment error")
                handler(nil)
            }
        }
        task.resume()
    }
    
    //MARK: -
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
