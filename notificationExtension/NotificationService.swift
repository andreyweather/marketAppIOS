//
//  NotificationService.swift
//  notificationExtension
//
//  Created by andrey.pogodin on 04.12.2023.
//

import UserNotifications
import UIKit

final class NotificationService: UNNotificationServiceExtension {
    
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        print (request.content.userInfo)
        
        let aps = request.content.userInfo[AnyHashable("aps")] as? [String:Any]
        let button = aps?["buttons"] as? [String:Any]
     
        
        let text_1 = (request.content.userInfo[AnyHashable("text_1")] as? String)
        let text_2 = (request.content.userInfo[AnyHashable("text_2")] as? String)
        let text_3 = (request.content.userInfo[AnyHashable("text_3")] as? String)
        
        var actions = [UNNotificationAction(identifier: "",  title: "", options: [])]
        
        if text_1 != nil && text_1 != ""  {
            actions.removeAll()
            actions.append(UNNotificationAction(identifier: "button1",  title: text_1 ?? "", options: []))
            
        }else {actions.removeAll()}
        
        if text_2 != nil && text_2 != ""   {
            actions.append(UNNotificationAction(identifier: "button2",  title: text_2 ?? "", options: []))
        }
        
        if text_3 != nil && text_3 != ""    {
            actions.append(UNNotificationAction(identifier: "button3",  title: text_3 ?? "", options: []))
        }

        
        let simpleCategory = UNNotificationCategory(identifier: "category-simple", actions: actions, intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([simpleCategory])
        

        print("push in metod")
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        defer {
            contentHandler(bestAttemptContent ?? request.content)
            print("push in metod")
        }

        bestAttemptContent?.categoryIdentifier = "category-simple"
        
        guard let attachment = request.attachment else { return }

        bestAttemptContent?.attachments = [attachment]
        

    }
    
    override func serviceExtensionTimeWillExpire() {
        print("push in metod")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        
            
        }
    }
}


extension UNNotificationRequest {

    var attachment: UNNotificationAttachment? {
        
        
        let image = content.userInfo[AnyHashable("image")] as? String
        

        print(content.userInfo)
    
        
        guard let attachmentURL = image, let imageData = try? Data(contentsOf: URL(string: attachmentURL)!)
              
        else {
            print ("null")
            return nil
        }
        
        return try? UNNotificationAttachment(data: imageData, options: nil)
    
    }
}



extension UNNotificationAttachment {

    convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
        print(data)
        print ("Attachment")
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)

        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        let imageFileIdentifier = UUID().uuidString + ".jpg"
        let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
        
    }
}




