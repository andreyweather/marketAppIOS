//
//  EnkodPushLibrary.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 21.12.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging

private var session = ""
private var token = ""
private var account = ""

private var token_pref: String { return "TOKEN" }
private var session_pref: String { return "SESSION_ID" }
private var account_pref: String {return "ACCOUNT"}
private var email_pref: String { return "EMAIL" }
private var phone_pref: String { return "PHONE" }
private var init_pref: String { return "INIT" }

private var libraryInit: Bool = false


class AppDelegate: NSObject, UIApplicationDelegate {
    

    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
 
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )

            application.registerForRemoteNotifications()
            
        }

        return true
        
    }
    
    
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
            Messaging.messaging().apnsToken = deviceToken
        
        print(" to register: \(deviceToken)")
        
        
    }
    
 
    func application(_ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: \(error)")
        
       }
    }


extension AppDelegate: MessagingDelegate {
    
   
  func messaging( _ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    
    {
        
        print ("this token in library \(fcmToken ?? "null")")
    
        Messaging.messaging().token { token, err in
            
            if let token = token {
                
                var token_pref: String { return "TOKEN" }
                
                UserDefaults.standard.set(token, forKey: token_pref)
                
            
            }
        }
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate{
    

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      

    completionHandler([.alert, .sound])
      
  }
    
    
 
    
 
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      let userInfo = response.notification.request.content.userInfo
      
      print (userInfo)
      
      var url = "nill"
      var intent = "nill"
      
      let intent_0 = (userInfo[AnyHashable("intent_0")] as? String)
      let intent_1 = (userInfo[AnyHashable("intent_1")] as? String)
      let intent_2 = (userInfo[AnyHashable("intent_2")] as? String)
      let intent_3 = (userInfo[AnyHashable("intent_3")] as? String)
    
      let url_0 = (userInfo[AnyHashable("url_1")] as? String)
      let url_1 = (userInfo[AnyHashable("url_1")] as? String)
      let url_2 = (userInfo[AnyHashable("url_2")] as? String)
      let url_3 = (userInfo[AnyHashable("url_3")] as? String)
      
      
      func intentAction (Identifier: String) {
          
          if Identifier == "com.apple.UNNotificationDefaultActionIdentifier" {
               
              var dataForPushClick = [String: Any]()
              
              dataForPushClick = [
                
                "personId": userInfo[AnyHashable("personId")] ?? "0",
                "messageId": userInfo[AnyHashable("messageId")] ?? "0",
                "intent": intent_0 ?? "",
                "url": url_0 ?? ""
                
              ]
              
              clickPush_N(pd: dataForPushClick)
                                
              switch intent_0 {
                  
              case "0":
                  
                  print("deep link")
                  
              case "1":
                
                  do {
                      if let url = URL(string: url_0 ?? ""), UIApplication.shared.canOpenURL(url) {
                          
                          UIApplication.shared.open(url)
                      }
                  }
                  
              default:
                  print("openApp")
     
              }
          }
          
          if Identifier == "button1" {
              
              var dataForPushClick = [String: Any]()
              
              dataForPushClick = [
                
                "personId": userInfo[AnyHashable("personId")] ?? "0",
                "messageId": userInfo[AnyHashable("messageId")] ?? "0",
                "intent": intent_1 ?? "",
                "url": url_1 ?? ""
                
              ]
              
              clickPush_N(pd: dataForPushClick)
           
              switch intent_1 {
                  
              case "0":
                  print("deep link")
                  
              case "1":
                  do {
                      if let url = URL(string: url_1 ?? ""), UIApplication.shared.canOpenURL(url) {
                          
                          UIApplication.shared.open(url)
                      }
                  }
              default:
                  print("openApp")
                  
              }
          }
          if Identifier == "button2" {
              
              var dataForPushClick = [String: Any]()
              
              dataForPushClick = [
                
                "personId": userInfo[AnyHashable("personId")] ?? "0",
                "messageId": userInfo[AnyHashable("messageId")] ?? "0",
                "intent": intent_2 ?? "",
                "url": url_2 ?? ""
                
              ]
              
              clickPush_N(pd: dataForPushClick)
           
              switch intent_2 {
              case "0":
                  print("deep link")
              case "1":
                  do {
                      if let url = URL(string: url_2 ?? ""), UIApplication.shared.canOpenURL(url) {
                          
                          UIApplication.shared.open(url)
                      }
                  }
              default:
                  print("openApp")
                  
              }
          }
          
          if Identifier == "button3" {
              
              var dataForPushClick = [String: Any]()
              
              dataForPushClick = [
                
                "personId": userInfo[AnyHashable("personId")] ?? "0",
                "messageId": userInfo[AnyHashable("messageId")] ?? "0",
                "intent": intent_3 ?? "",
                "url": url_3 ?? ""
                
              ]
              
              clickPush_N(pd: dataForPushClick)
           
              switch intent_3 {
                  
              case "0":
                  print("deep link")
              case "1":
                  do {
                      if let url = URL(string: url_3 ?? ""), UIApplication.shared.canOpenURL(url) {
                          
                          UIApplication.shared.open(url)
                      }
                  }
              default:
                  print("openApp")
                  
              }
          }
      }
      
      


      intentAction (Identifier: response.actionIdentifier)
      
      
    completionHandler()
      
      
  }
    
}
  



func logOut () {
    
    UserDefaults.standard.removeObject(forKey: session_pref)
    UserDefaults.standard.removeObject(forKey: token_pref)
    UserDefaults.standard.removeObject(forKey: email_pref)
    UserDefaults.standard.removeObject(forKey: phone_pref)
 
    Messaging.messaging().deleteToken { err in
            if let err = err {
                print("Error")
                print(err)
                
            }else{
                print ("Token delete")
            }
        }
}

func getUrl (selectUser: Int, selectUrl: String) -> String {
    
    var url = ""
    
    let devUrl: [String: String] = ["createSession":"https://dev.ext.enkod.ru/sessions",
                                    "startSession":"https://dev.ext.enkod.ru/sessions/start",
                                    "subscribePush":"https://dev.ext.enkod.ru/mobile/subscribe",
                                    "unsubscribePush":"https://dev.ext.enkod.ru/mobile/unsubscribe",
                                    "clickPush":"https://dev.ext.enkod.ru/mobile/click/",
                                    "refreshToken":"https://dev.ext.enkod.ru/mobile/token",
                                    
                                    "cart":"https://dev.ext.enkod.ru/product/cart",
                                    "favourite":"https://dev.ext.enkod.ru/product/favourite",
                                    "pageOpen":"https://dev.ext.enkod.ru/page/open",
                                    "productOpen":"https://dev.ext.enkod.ru/product/open",
                                    "productBuy":"https://dev.ext.enkod.ru/product/order",
                                    "subscribe":"https://dev.ext.enkod.ru/subscribe",
                                    "addExtraFields":"https://dev.ext.enkod.ru/addExtraFields",
                                    "getPerson":"https://dev.ext.enkod.ru/getCartAndFavourite",
                                    "updateBySession":"https://dev.ext.enkod.ru/updateBySession"]
    
    
    let prodUrl: [String: String] =  ["createSession":"https://ext.enkod.ru/sessions",
                                      "startSession":"https://ext.enkod.ru/sessions/start",
                                      "subscribePush":"https://ext.enkod.ru/mobile/subscribe",
                                      "unsubscribePush":"https://ext.enkod.ru/mobile/unsubscribe",
                                      "clichPush":"https://ext.enkod.ru/mobile/click/",
                                      "refreshToken":"https://ext.enkod.ru/mobile/token",
                                      
                                      "cart":"https://ext.enkod.ru/product/cart",
                                      "favourite":"https://ext.enkod.ru/product/favourite",
                                      "pageOpen":"https://ext.enkod.ru/page/open",
                                      "productOpen":"https://ext.enkod.ru/product/open",
                                      "productBuy":"https://ext.enkod.ru/product/order",
                                      "subscribe":"https://ext.enkod.ru/subscribe",
                                      "addExtraFields":"https://ext.enkod.ru/addExtraFields",
                                      "getPerson":"https://ext.enkod.ru/getCartAndFavourite",
                                      "updateBySession":"https://ext.enkod.ru/updateBySession"]
    
    
    if selectUser == 1 {
        url = devUrl [selectUrl] ?? ""
    }
    
    
    
    if selectUser == 2 {
        url =  prodUrl [selectUrl] ?? ""
    }
    
    return url
    
}


public struct Product_N {
    public var id: String
    public var count: Int?
    public var categoryId: String?
    public var fields: [String:Any]?
}


public struct Order_N {
    
    public var orderId: String?
    public var productId: String?
    public var sum: Double? //сумма всей покупки
    public var price: Double?
    public var fields: [String:Any]?
   
}


func enkodConnect (_account: String?) {
    
    if (_account != nil) {
        
        account = _account ?? "nil"
        
        print (account)
    }
    

    
     var getToken: String? { return UserDefaults.standard.object(forKey: token_pref) as? String }
     var getSessionID: String? { return UserDefaults.standard.object(forKey: session_pref) as? String }
     var getAccount: String? {return UserDefaults.standard.object(forKey: account_pref) as? String }
    

    if getSessionID == nil {
        
        var token_observer = true
        
        while (token_observer) {
            
            if (getToken != nil) {
                
                createSession_N(account: account, token: getToken ?? "")
                
                token_observer = false
            }
            
        }
        
    } else {
   
        var token_observer = true
        
        while (token_observer) {
            
            if (getToken != nil) {
                
                startSession_N(account: getAccount!, sessionID: getSessionID!, token: getToken!)
                
                token_observer = false
            }
            
        }

    }
    
}


public func createSession_N (account: String, token: String) {
    
    let urlFromMap = getUrl(selectUser:1, selectUrl:"createSession")
    
    //print(urlFromMap)
    guard let url = URL(string: urlFromMap) else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
    urlRequest.httpMethod = "POST"
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let sessionID = json["session_id"] as? String {

            session = sessionID
            
            UserDefaults.standard.set(account, forKey: account_pref)
            UserDefaults.standard.set(sessionID, forKey: session_pref)
            
            DispatchQueue.main.async {
                
            refreshToken (account: account, sessionID: sessionID, token: token)
                
            }
            
        } else if error != nil {
            
            DispatchQueue.main.async {
               
            }
        }
    }.resume()
}

func refreshToken(account: String, sessionID: String, token: String) {
    
    
   let urlFromMap = getUrl(selectUser:1, selectUrl:"refreshToken")
    
   guard let url = URL(string: urlFromMap) else { return }
   var urlRequest = URLRequest(url: url)
   urlRequest.httpMethod = "PUT"
   urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
   urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

   let json: [String: Any] = ["sessionId": sessionID, "token": token]
   let jsonData = try? JSONSerialization.data(withJSONObject: json)
   urlRequest.httpBody = jsonData
    
         
    
   URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
       
       if data != nil {

           startSession_N(account: account, sessionID: sessionID, token: token)
           
       } else if error != nil {
          
       }
   }.resume()
}

func startSession_N (account: String, sessionID: String, token: String) {
    
    print (account)
    print (sessionID)
    print (token)

    
    let urlFromMap = getUrl(selectUser:1, selectUrl:"startSession")
    
    guard let url = URL(string: urlFromMap) else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
    urlRequest.addValue(sessionID, forHTTPHeaderField: "X-Session-Id")
    urlRequest.httpMethod = "POST"
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        
        if data != nil {
              
        
                session = sessionID
            
                subscribePush_N (account: account, sessionID: sessionID, token: token)

        
        } else if error != nil {
            
            DispatchQueue.main.async {
                
            }
        }
    }.resume()
}



public func subscribePush_N(account: String, sessionID: String, token: String) {
    
    print (token)
    print("in subscribePush ")
    print("\(account), \(token), \(sessionID)")
    
    let urlFromMap = getUrl(selectUser:1, selectUrl:"subscribePush")
    
    guard let url = URL(string: urlFromMap) else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
    urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
    urlRequest.addValue(sessionID, forHTTPHeaderField: "X-Session-Id")
    
    let json: [String: Any] = ["sessionId": sessionID, "token": token, "os": "ios"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    urlRequest.httpBody = jsonData
    
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if data != nil {
            
            libraryInit = true
               
            DispatchQueue.main.async {
          
            libraryInit = true
                
            }
            
        } else if error != nil {
            
            DispatchQueue.main.async {
                
            }
        }
        
    }.resume()
}


 func subscribeNew_N(subscriberInfo: [String:Any]) throws {
    
     
    guard JSONSerialization.isValidJSONObject(subscriberInfo) else {
        throw  TrackerErr.invalidJson
    }
    guard let json = try? JSONSerialization.data(withJSONObject: subscriberInfo, options: []) else { throw TrackerErr.invalidJson }
     
     
     
    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"subscribe"), json, account: account, session: session) else { return }
     
     var observer = true
     
     while (observer) {
         
         if (libraryInit == true) {
            
             observer = false
             
             URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
                 if data != nil {
                     
                     print("new_contact_add_to_servise")
                     
                     do {
                         
                     }
                     
                     DispatchQueue.main.async {
                         
                         
                     }
                     
                 } else if error != nil {
                     DispatchQueue.main.async {
                         
                     }
                 }
             }.resume()
             
        }
    }
}
 

public func prepareRequest(_ method: String, _ url: String, _ body: Data?, account: String, session: String) -> URLRequest?{
    
    let account = account
    let session = session
    let url = URL(string: url)
    var urlRequest = URLRequest(url:url!)
    urlRequest.httpMethod = method
    urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
    urlRequest.addValue(session, forHTTPHeaderField: "X-Session-Id")
    urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
    urlRequest.httpBody = body
    return urlRequest
    
}



func TrackingMapBilder(_ product: Product_N) -> [String:Any] {
    var productMap = [String:Any]()
    
    productMap["productId"] = product.id
    productMap["count"] = product.count
    

    if product.categoryId != "" {
        productMap["categoryId"] = product.categoryId
    }

    if product.fields != nil {
        
        
        for (key, _) in product.fields! {
            
            productMap[key] = product.fields?[key]
            
        }
    }
    print (productMap)

    return productMap
}




func AddToFavourite(product: Product_N) throws {
    
    
    var map = TrackingMapBilder(product)
    
    map ["action"] = "productLike"
    
    let lastUpdate = Int(Date().timeIntervalSince1970)
    
    let wishlist: [String:Any] = ["products":map["productId"] ?? "", "lastUpdate": lastUpdate]

    let history: [[String:Any]] = [map]
    
    let json: [String : Any] = ["wishlist": wishlist, "history": history]
    

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    
   // print(requestBody)

    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"favourite"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            
            print ("like")
            DispatchQueue.main.async {
               
                print ("like")
            }
        } else if error != nil {
            DispatchQueue.main.async {
           
            }
        }
    }.resume()
}


func RemoveFromFavourite (product: Product_N) throws {
    
    
    var map = TrackingMapBilder(product)
    
    map ["action"] = "productDislike"
    
    let lastUpdate = Int(Date().timeIntervalSince1970)
    
    let wishlist: [String:Any] = ["products":map["productId"] ?? "", "lastUpdate": lastUpdate]

    let history: [[String:Any]] = [map]
    
    let json: [String : Any] = ["wishlist": wishlist, "history": history]
    

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    
   // print(requestBody)

    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"favourite"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            
            print ("like")
            DispatchQueue.main.async {
               
                print ("like")
            }
        } else if error != nil {
            DispatchQueue.main.async {
           
            }
        }
    }.resume()
}

func AddToCart (product: Product_N) throws {
    
    
    var map = TrackingMapBilder(product)
    
    map ["action"] = "productAdd"
    
    let lastUpdate = Int(Date().timeIntervalSince1970)
    
    let cart: [String:Any] = ["lastUpdate": lastUpdate, "products": [["productId": map["productId"]]]]

    let history: [[String:Any]] = [map]
    
    let json: [String : Any] = ["cart": cart, "history": history]
    

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    
   // print(requestBody)

    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"cart"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            
            print ("like")
            DispatchQueue.main.async {
               
                print ("like")
            }
        } else if error != nil {
            DispatchQueue.main.async {
           
            }
        }
    }.resume()
}

func RemoveFromCart (product: Product_N) throws {
    
    
    var map = TrackingMapBilder(product)
    
    map ["action"] = "productRemove"
    
    let lastUpdate = Int(Date().timeIntervalSince1970)
    
    let cart: [String:Any] = ["lastUpdate": lastUpdate, "products": [["productId": map["productId"]]]]

    let history: [[String:Any]] = [map]
    
    let json: [String : Any] = ["cart": cart, "history": history]
    

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    
   // print(requestBody)

    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"cart"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            
            print ("like")
            DispatchQueue.main.async {
               
                print ("like")
            }
        } else if error != nil {
            DispatchQueue.main.async {
           
            }
        }
    }.resume()
}


func ProductOpen (product: Product_N) throws {
    
    
    var map = TrackingMapBilder(product)
    
    map ["action"] = "productOpen"
      
    let lastUpdate = Int(Date().timeIntervalSince1970)
    
    let product = ["id": map["productId"] ?? "", "lastUpdate": lastUpdate]
    let params: [String:Any] = map
    
    let json: [String : Any] = ["product": product, "params": params]
    

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    
   // print(requestBody)

    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"productOpen"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            
            print ("like")
            DispatchQueue.main.async {
               
                print ("like")
            }
        } else if error != nil {
            DispatchQueue.main.async {
           
            }
        }
    }.resume()
}


func buyMapBilder(_ order: Order_N) -> [String:Any] {
    
    var orderMap = [String:Any]()
    
    orderMap["orderId"] = order.orderId
    orderMap["productId"] = order.productId
    orderMap["sum"] = order.sum
    orderMap["price"] = order.price
    

    if order.fields != nil {
        
        
        for (key, _) in order.fields! {
            
            orderMap[key] = order.fields?[key]
            
        }
    }
    print (orderMap)

    return orderMap
}



func productBuy_N(order: Order_N) throws {
    
    var order = order

    if order.orderId == "" || order.orderId == nil { order.orderId = UUID().uuidString.lowercased() }
    
    var orderInfo = [String:Any]()

    var orderFields = [String:Any]()
    if order.fields != nil {
        for (k, v) in order.fields! {
            orderFields[k] = v
        }
    }
    if order.sum != nil { orderFields["sum"] = String(format: "%.2f", order.sum!) }
    if order.price != nil { orderFields["price"] = String(format: "%.2f", order.price!) }

    orderInfo["items"] = buyMapBilder(order)
    if !orderFields.isEmpty {
        orderInfo["order"] = orderFields
    }

    let json = ["orderId": order.orderId as Any,
                "orderInfo": orderInfo] as [String : Any]

    guard JSONSerialization.isValidJSONObject(json) else {
        throw TrackerErr.invalidJson
    }
    let requestBody = try JSONSerialization.data(withJSONObject: json)
    guard let urlRequest = prepareRequest("POST", getUrl(selectUser:1, selectUrl:"productBuy"), requestBody, account: account, session: session) else { return }

    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if data != nil {
            DispatchQueue.main.async {
            
            }
        } else if error != nil {
            DispatchQueue.main.async {
             
            }
        }
    }.resume()
}



public func clickPush_N (pd: [String:Any]){
    let urlFromMap = getUrl(selectUser:1, selectUrl:"clickPush")
    guard let url = URL(string: urlFromMap) else { return }
    let account = account
    let session = session
    
    print(account)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
    
    urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
    urlRequest.httpMethod = "POST"
    
    let data = pd //as! PushData
    
    var json: [String: Any] = ["sessionId": session, "personId": Int(data["personId"] as! String) ?? 0, "messageId": Int(data["messageId"] as! String) ?? -1, "intent": Int(data["intent"] as! String) ?? 2, "url": data["url"]as! String]
    //if let urlString = data["url"] { json["url"] = urlString }
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    urlRequest.httpBody = jsonData
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if data != nil {
            
            print(json)
            
        } else if let error = error {
            
        }
    }.resume()
}


enum TrackerErr : Error{
    case emptyProductId
    case notExistedProductId
    case emptyCart
    case emptyFavourite
    case emptyEmail
    case emptyEmailAndPhone
    case invalidJson
    case badRequest
    case emptyProducts
    case alreadyLoggedIn
    case emptySession
}
