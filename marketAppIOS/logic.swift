////import UIKit

import Foundation
import UserNotifications
import UIKit

public protocol PushNotificationServiceDelegate: AnyObject {
    func getPushData(_ pushData: PushData)
}

extension PushNotificationServiceDelegate {
    func getDeeplink(_ deeplink: String) { }
}

public enum PushNotificationService {
    private static var account: String {return "ACCOUNT"}
    private static var token: String { return "TOKEN" }
    fileprivate static var sessionID: String { return "SESSION_ID" }
    static var getToken: String? { return UserDefaults.standard.object(forKey: PushNotificationService.token) as? String }
    static var getSessionID: String? { return UserDefaults.standard.object(forKey: PushNotificationService.sessionID) as? String }
    static var getAccount: String? {return UserDefaults.standard.object(forKey: PushNotificationService.account) as? String }

    static func dropSession() { UserDefaults.standard.removeObject(forKey: sessionID) }

    public static weak var delegate: PushNotificationServiceDelegate?

    public static func setAccount(_ ac: String){
        UserDefaults.standard.set(ac, forKey: PushNotificationService.account)
        SessionService.setUrls()
        SessionService.getUrls()
    }

    @discardableResult
    public static func notificationData(_ data: [String: AnyObject]) -> AnyObject? {
        if let aps = data["aps"] as? [String: AnyObject] {
            guard let account = getAccount else {return nil}
            let pushData = getData(aps: aps, account: account)
            return pushData as AnyObject
        }
        return nil
    }

    @discardableResult
    public static func notificationData(_ data: [AnyHashable: Any]) -> AnyObject? {
        if let aps = data["aps"] as? [String: AnyObject] {
            guard let ac = getAccount else{return nil}
            let pushData = getData(aps: aps, account: ac)
            return pushData as AnyObject
        }
        return nil
    }

    @discardableResult
    public static func setDeviceToken(_ deviceToken: Data) -> String {
        guard let ac = PushNotificationService.getAccount else {return "account is empty"}

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()

        print(token)

        if let oldToken = PushNotificationService.getToken,
           oldToken != token,
           let sessionID = PushNotificationService.getSessionID {
            UserDefaults.standard.set(token, forKey: PushNotificationService.token)
            SessionService.refreshToken(token, sessionID: sessionID, account: ac)

        } else if PushNotificationService.getToken == nil {
            UserDefaults.standard.set(token, forKey: PushNotificationService.token)
        }

        if let sessionID = PushNotificationService.getSessionID {
            SessionService.startSession(account: ac, sessionID: sessionID)
        } else {
            SessionService.createSession(account: ac)
        }

        return token
    }

    @discardableResult
    public static func setDeviceToken(_ token: String) -> String {
        guard let ac = PushNotificationService.getAccount else {return "account is empty"}

        print(token)

        if let oldToken = PushNotificationService.getToken,
           oldToken != token,
           let sessionID = PushNotificationService.getSessionID {
            UserDefaults.standard.set(token, forKey: PushNotificationService.token)
            SessionService.refreshToken(token, sessionID: sessionID, account: ac)

        } else if PushNotificationService.getToken == nil {
            UserDefaults.standard.set(token, forKey: PushNotificationService.token)
        }

        if let sessionID = PushNotificationService.getSessionID {
            SessionService.startSession(account: ac, sessionID: sessionID)
        } else {
            SessionService.createSession(account: ac)
        }
        return token
    }

    public static func registerForPushNotifications() {
        if #available(iOS 8.0, *) {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
                    guard granted else { return }
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        guard settings.authorizationStatus == .authorized else { return }
                        DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
                    }
                }
            } else {
                let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
                DispatchQueue.main.async { UIApplication.shared.registerUserNotificationSettings(settings) }
            }

        } else {
            DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .alert, .sound]) }
        }
    }

    public static func unsubscribePush() {
        guard let ac = self.getAccount else{
            return
        }
        guard let sessionID = self.getSessionID else { return }
        SessionService.unsubscribePush(account: ac, sessionID: sessionID)
    }

    public static func subscribePush() {
        guard let ac = self.getAccount else{
            return
        }

        guard let sessionID = self.getSessionID, let token = self.getToken else { return }
        SessionService.subscribePush(account: ac, token: token, sessionID: sessionID)
    }

    public static func subscribeDeeplink(_ delegate: AnyObject) {
        self.delegate = delegate as? PushNotificationServiceDelegate
    }

    public static func unsubscribeDeeplink() {
       // self.delegate = nil
    }

    private static func getData(aps: [String: AnyObject], account: String) -> PushData {
        let alert = aps["alert"] as? [String: AnyObject]
        let intent = aps["intent"] as? String
        let url = aps["url"] as? String
        let personID = aps["person_id"] as? Int
        let messageID = aps["messageId"] as? String
        let apsButtons = aps["buttons"] as? [AnyObject] //надо делать проверку

        var buttons = [String:Button]()
        if let apsButtons = apsButtons{
            for b in apsButtons{
                let but = b as! [String:String]
                let id = but["id"]
                let button = Button(id: id ?? "0", label: but["label"] ?? "", action: but["action"] ?? "", link: but["link"] ?? "")
                buttons[id!] = button
            }
        }

        let pushData = PushData(pushID: aps["id"] as? String,
                                title: alert?["title"] as? String,
                                subtitle: alert?["subtitle"] as? String,
                                body: alert?["body"] as? String,
                                badge: aps["badge"] as? Int,
                                intent: intent,
                                url: url,
                                category: aps["category"] as? String,
                                personID: personID,
                                messageID: messageID,
                                buttons: buttons)

        self.delegate?.getPushData(pushData)

        return pushData
    }
}

public struct PushData : Encodable {
    public var pushID: String?
    public var title: String?
    public var subtitle: String?
    public var body: String?
    public var badge: Int?
    public var intent: String?
    public var url: String?
    public var category: String?
    public var personID: Int?
    public var messageID: String?
    public var buttons: [String:Button]?
}

public struct Button : Encodable{
    public var id: String?
    public var label: String?
    public var action: String?
    public var link: String?
}

public protocol SessionServiceDelegate: AnyObject {
    func sessionCreated()
    func sessionStarted()
    func pushSubscribed()
    func pushUnsubscribed()
    func pushClicked()
    func tokenRefreshed()
    func failure(error: Error)
}

extension SessionServiceDelegate {
    func sessionCreated() { }
    func sessionStarted() { }
    func pushSubscribed() { }
    func pushUnsubscribed() { }
    func pushClicked() { }
    func tokenRefreshed() { }
    func failure(error: Error) { }
}

public struct Urls {
    fileprivate var local: [String:String]
    fileprivate var dev: [String:String]
    fileprivate var prod: [String:String]
}

public enum SessionService {
    public static weak var delegate: SessionServiceDelegate?
    private static var outerUrls: Urls?
    fileprivate static var u: [String:String]?
    public static func setUrls(){
        let urls = Urls.init(local: ["" : ""], dev: ["createSession":"https://dev.ext.enkod.ru/sessions",
                                                 "startSession":"https://dev.ext.enkod.ru/sessions/start",
                                                 "subscribePush":"https://dev.ext.enkod.ru/mobile/subscribe",
                                                 "unsubscribePush":"https://dev.ext.enkod.ru/mobile/unsubscribe",
                                                 "clichPush":"https://dev.ext.enkod.ru/mobile/click/",
                                                 "refreshToken":"https://dev.ext.enkod.ru/mobile/token",

                                                 "cart":"https://dev.ext.enkod.ru/product/cart",
                                                 "favourite":"https://dev.ext.enkod.ru/product/favourite",
                                                 "pageOpen":"https://dev.ext.enkod.ru/page/open",
                                                 "productOpen":"https://dev.ext.enkod.ru/product/open",
                                                 "productBuy":"https://dev.ext.enkod.ru/product/order",
                                                 "subscribe":"https://dev.ext.enkod.ru/subscribe",
                                                 "addExtraFields":"https://dev.ext.enkod.ru/addExtraFields",
                                                 "getPerson":"https://dev.ext.enkod.ru/getCartAndFavourite",
                                                 "updateBySession":"https://dev.ext.enkod.ru/updateBySession"],

                                            prod: ["createSession":"https://ext.enkod.ru/sessions",
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
                                                "updateBySession":"https://ext.enkod.ru/updateBySession"])
        outerUrls = urls
    }

    public static func getUrls(){
        let devClients: [String] = ["ilya_client", "maxim_t_client", "margarita_client", "zhan"]
        guard let account = PushNotificationService.getAccount else {return}
        for a in devClients{
            if account == a{
                u = outerUrls?.dev
                return
            }
        }
        u = outerUrls?.prod
    }

    static func createSession(account: String) {
        guard let urlFromMap = u!["createSession"] else{ return }
        guard let url = URL(string: urlFromMap) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
        urlRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let sessionID = json["session_id"] as? String {
                UserDefaults.standard.set(sessionID, forKey: PushNotificationService.sessionID)
                self.startSession(account: account, sessionID: sessionID)
                DispatchQueue.main.async {
                    self.delegate?.sessionCreated()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error: error)
                }
            }
        }.resume()
    }

    static func startSession(account: String, sessionID: String) {
        guard let urlFromMap = u!["startSession"] else{ return }
        guard let url = URL(string: urlFromMap) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
        urlRequest.addValue(sessionID, forHTTPHeaderField: "X-Session-Id")
        urlRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.sessionStarted()
                }
                if let token = PushNotificationService.getToken {
                    print(token)
                    self.subscribePush(account: account, token: token, sessionID: sessionID)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error: error)
                }
            }
        }.resume()
    }

    public static func subscribePush(account: String, token: String, sessionID: String) {
        guard let urlFromMap = u!["subscribePush"] else{ return }
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
                DispatchQueue.main.async {
                    self.delegate?.pushSubscribed()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error: error)
                }
            }
        }.resume()
    }

    public static func unsubscribePush(account: String, sessionID: String) {
        guard let urlFromMap = u!["unsubscribePush"] else{ return }
        guard let url = URL(string: urlFromMap) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(account, forHTTPHeaderField: "X-Account")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue(sessionID, forHTTPHeaderField: "X-Session-Id")

        let json: [String: Any] = ["sessionId": sessionID]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json, #function)
            }
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.pushUnsubscribed()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error: error)
                }
            }
        }.resume()
    }

    public static func clickPush(pd: PushData){
         guard let urlFromMap = u!["clichPush"] else{ return }
         guard let url = URL(string: urlFromMap) else { return }
         guard let account = PushNotificationService.getAccount else{return}
         guard let session = PushNotificationService.getSessionID else {return}//UserDefaults.standard.object(forKey: PushNotificationService.sessionID) else {return}

         var urlRequest = URLRequest(url: url)
         urlRequest.addValue(account, forHTTPHeaderField: "X-Account")

         urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
         urlRequest.httpMethod = "POST"

        let data = pd //as! PushData

        var json: [String: Any] = ["sessionId": session, "personId": data.personID, "messageId": Int(data.messageID ?? "0") ?? data.messageID, "intent": Int(data.intent ?? "0") ?? data.messageID]
        if let urlString = data.url { json["url"] = urlString }

         let jsonData = try? JSONSerialization.data(withJSONObject: json)
         urlRequest.httpBody = jsonData
         URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
             if data != nil {
                 self.delegate?.pushClicked()
             } else if let error = error {
                 self.delegate?.failure(error: error)
             }
         }.resume()
    }

    static func refreshToken(_ token: String, sessionID: String, account: String) {
        guard let urlFromMap = u!["refreshToken"] else{ return }
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
                self.delegate?.tokenRefreshed()
            } else if let error = error {
                self.delegate?.failure(error: error)
            }
        }.resume()
    }
}

extension Tracker {
    public struct Cart{
        public var Cart: [String:Any] = ["products":"", "lastUpdate":""]
        public var History: [[String:Any]] = [["productId":"", "action":""]]
    }

    public struct Favourite {
        public var Favourite: [String:Any] = ["products":"", "lastUpdate":""]
        public var History: [[String:Any]] = [["productId":"", "action":""]]
    }
}

public protocol TrackerServiceDelegate : AnyObject {
    func failure(_ error : Error)
    func productAdded(_ pId: String)
    func productRemoved()
    func productLiked()
    func productDisliked()
    func subscribed()
    func productOpened()
    func productBuyed()
    func pageOpened()
    func extrafieldsAdded()
    func contactsUpdated()
}

public struct Subscriber {
    public var email: String?
    public var phone: String?
    public var firstName: String?
    public var lastName: String?
    public var groups: [Any]?
    public var mainChannel: String?
    public var integrations: [Int64]?
    public var extrafields: [String:Any]?
    public init() {}
}


private struct PersonData {
    public var cart: [String: Any]
    public var favourite: [String: Any]
    public var session: String
}

public struct Product {
    public var id: String
    public var count: Int64?
    public var groupId: String?
    public var fields: [String:Any]?
}

public extension Product{
    init(id: String){
        self.id = id
    }
}

public struct Order {
    public var orderId: String?
    public var sum: Float64? //сумма всей покупки
    public var price: Float64?
    public var fields: [String:Any]?
    public init() {}
}

fileprivate class Tracker {
    private var cart: Cart = Cart()
    private var favourite: Favourite = Favourite()

    fileprivate var emailKey: String { return "EMAIL" }
    fileprivate var phoneKey: String { return "PHONE" }
    fileprivate var getEmail: String? { return UserDefaults.standard.object(forKey: emailKey) as? String }
    fileprivate func setEmail(email: String){ UserDefaults.standard.set(email, forKey: emailKey) }
    fileprivate func dropEmail(){ UserDefaults.standard.removeObject(forKey: emailKey) }

    fileprivate var getPhone: String? { return UserDefaults.standard.object(forKey: phoneKey) as? String }
    fileprivate func setPhone(phone: String){ UserDefaults.standard.set(phone, forKey: phoneKey) }
    fileprivate func dropPhone(){ UserDefaults.standard.removeObject(forKey: phoneKey) }

    fileprivate var loggedKey: String { return "LOGGED"}
    fileprivate var getLogged: Bool { return UserDefaults.standard.object(forKey: loggedKey) as? Bool ?? false}
    fileprivate func setLogged(isLogged: Bool) { UserDefaults.standard.set(isLogged, forKey: loggedKey)}

    private func updateCart(cart: [String:Any]){
        self.cart = Cart(Cart: cart)
    }
    private func updateFavourite(favourite: [String:Any]){
        self.favourite = Favourite(Favourite: favourite)
    }

    private var urls: [String:String]

    public weak var delegate: TrackerServiceDelegate?

    init(d: TrackerServiceDelegate?){
        urls = SessionService.u!
        delegate = d
    }

    private func checkProduct(_ product: Product) throws -> Product{
        var product = product

        guard product.id != "" else { throw TrackerErr.emptyProductId }
        if product.count == 0 || product.count == nil { product.count = 1 }

        return product
    }

    private func buildCommon(_ product: Product) -> [String:Any] {
        var productMap = [String:Any]()
        productMap["productId"] = product.id
        productMap["count"] = product.count

        if product.groupId != "" {
            productMap["groupId"] = product.groupId
        }

        if product.fields != nil {
            for (key, var val) in product.fields! {
                switch key {
                case "price", "sum":
                    val = val as Any
                default: break }
                productMap[key] = val
            }
        }

        self.cart.Cart["lastUpdate"] = Int(Date().timeIntervalSince1970)
        self.favourite.Favourite["lastUpdate"] = Int(Date().timeIntervalSince1970)

        return productMap
    }

    public func prepareRequest(_ method: String, _ url: String, _ body: Data?) -> URLRequest?{
        let account = PushNotificationService.getAccount
        let session = PushNotificationService.getSessionID
        let url = URL(string: url)
        var urlRequest = URLRequest(url:url!)
        urlRequest.httpMethod = method
        urlRequest.addValue(account!, forHTTPHeaderField: "X-Account")
        urlRequest.addValue(session!, forHTTPHeaderField: "X-Session-Id")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = body
        return urlRequest
    }

    fileprivate func productAdd(product: Product) throws {
        var product = product
        do {
            product = try checkProduct(product)
        }catch is TrackerErr {
            throw TrackerErr.emptyProductId
        }

        var productMap = buildCommon(product)

        if var products = self.cart.Cart["products"] as? [[String:Any]]{
            for(i, currentProduct) in products.enumerated(){
                if currentProduct["productId"] as? String != product.id {continue}
                let count = currentProduct["count"] as! Int64 + product.count!
                productMap["count"] = count

                for(k, v) in productMap{
                    if currentProduct[k] == nil {
                        productMap[k] = v
                    }
                }
                products.remove(at: i)
            }
            products.append(productMap)
            self.cart.Cart["products"] = products
        } else {
            self.cart.Cart["products"] = [productMap]
        }

        productMap["action"] = "productAdd"
        self.cart.History[0] = productMap

        let json: [String : Any] = ["history": self.cart.History, "cart": self.cart.Cart]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }
        let requestBody = try JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["cart"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productAdded(product.id)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func productRemove(_ product: Product) throws {
        var product = product
        do{
            product = try checkProduct(product)
        }catch TrackerErr.emptyProductId {
            throw TrackerErr.emptyProductId
        }
        var productMap = buildCommon(product)

        if var products = self.cart.Cart["products"] as? [[String:Any]]{
            for (i, var currentProduct) in products.enumerated(){
                if currentProduct["productId"] as? String == product.id{
                    let currentCount = currentProduct["count"] as? Int64
                    if currentCount! <= product.count! {
                        products.remove(at: i)
                    }else{
                        products.remove(at: i)
                        currentProduct["count"] = currentCount! - product.count!
                        products.append(currentProduct)
                    }
                    self.cart.Cart["products"] = products
                    break
                }
            }
        } else {
            throw TrackerErr.emptyCart
        }

        productMap["action"] = "productRemove"
        self.cart.History[0] = productMap

        let json: [String : Any] = ["cart":self.cart.Cart, "history": self.cart.History]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }

        let requestBody = try? JSONSerialization.data(withJSONObject: json)

        guard let urlRequest = prepareRequest("POST", urls["cart"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productRemoved()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func productLike(_ product: Product) throws {
        var product = product

        do {
            product = try checkProduct(product)
        }catch is TrackerErr {
            throw TrackerErr.emptyProductId
        }

        var productMap = buildCommon(product)

        if var products = self.favourite.Favourite["products"] as? [[String:Any]]{
            for(i, currentProduct) in products.enumerated(){
                if currentProduct["productId"] as? String != product.id {continue}
                let count = currentProduct["count"] as! Int64 + product.count!
                productMap["count"] = count

                for(k, v) in productMap{
                    if currentProduct[k] == nil {
                        productMap[k] = v
                    }
                }
                products.remove(at: i)
            }
            products.append(productMap)
            self.favourite.Favourite["products"] = products
        } else {
            self.favourite.Favourite["products"] = [productMap]
        }

        productMap["action"] = "productLike"
        self.favourite.History[0] = productMap

        let json: [String : Any] = ["history": self.favourite.History, "wishlist": self.favourite.Favourite]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }
        let requestBody = try JSONSerialization.data(withJSONObject: json)

        guard let urlRequest = prepareRequest("POST", urls["favourite"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productLiked()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func productDislike(_ product: Product) throws {
        var product = product
        do{
            product = try checkProduct(product)
        }catch TrackerErr.emptyProductId {
            throw TrackerErr.emptyProductId
        }
        var productMap = buildCommon(product)

        if var products = self.favourite.Favourite["products"] as? [[String:Any]]{
            for (i, var currentProduct) in products.enumerated(){
                if currentProduct["productId"] as? String == product.id{
                    let currentCount = currentProduct["count"] as? Int64
                    if currentCount! <= product.count! {
                        products.remove(at: i)
                    }else{
                        products.remove(at: i)
                        currentProduct["count"] = currentCount! - product.count!
                        products.append(currentProduct)
                    }
                    self.favourite.Favourite["products"] = products
                    break
                }
            }
        } else {
            throw TrackerErr.emptyFavourite
        }

        productMap["action"] = "productDislike"
        self.favourite.History[0] = productMap

        let json: [String : Any] = ["wishlist":self.favourite.Favourite, "history": self.favourite.History]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }

        let requestBody = try? JSONSerialization.data(withJSONObject: json)

        guard let urlRequest = prepareRequest("POST", urls["favourite"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productDisliked()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    private func subscribeNew(subscriberInfo: [String:Any]) throws {
        guard JSONSerialization.isValidJSONObject(subscriberInfo) else {
            throw TrackerErr.invalidJson
        }
        guard let json = try? JSONSerialization.data(withJSONObject: subscriberInfo, options: []) else { throw TrackerErr.invalidJson }
        guard let urlRequest = prepareRequest("POST", urls["subscribe"]!, json) else { return }
        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.subscribed()
                }
                self.setLogged(isLogged: true)
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    private func updateCurrent(person: PersonData, email: String, phone: String){
        updateCart(cart: person.cart)
        updateFavourite(favourite: person.favourite)
        UserDefaults.standard.set(person.session, forKey: PushNotificationService.sessionID)
        SessionService.startSession(account: PushNotificationService.getAccount!, sessionID: person.session)
        setEmail(email: email)
        setPhone(phone: phone)
        setLogged(isLogged: true)
    }

    fileprivate func updateContacts(_ email: String, _ phone: String){
        var url = URLComponents(string: urls["updateBySession"]!)
        var params: [URLQueryItem] = []
        if email != "" { params.append(URLQueryItem(name: "email", value: email)) }
        if phone != "" { params.append(URLQueryItem(name: "phone", value: phone)) }

        guard !params.isEmpty && getLogged && (email != getEmail || phone != getPhone) else { return }

        url?.queryItems = params
        var urlRequest = URLRequest(url:(url?.url)!)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue(PushNotificationService.getAccount!, forHTTPHeaderField: "X-Account")
        urlRequest.addValue(PushNotificationService.getSessionID!, forHTTPHeaderField: "X-Session-Id")

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            let response = response as? HTTPURLResponse
            if response!.statusCode > 200{
                let jsn = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
                let err = NSError(domain: "", code: response!.statusCode, userInfo: jsn)
                DispatchQueue.main.async {
                    self.delegate?.failure(err as Error)
                }
            } else if !data.isEmpty {
                self.setEmail(email: email)
                self.setPhone(phone: phone)
                DispatchQueue.main.async {
                    self.delegate?.contactsUpdated()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func subscribe(_ sub: Subscriber) throws {
        //guard sub.email != "" || sub.phone != "" else { throw TrackerErr.emptyEmailAndPhone }
        guard PushNotificationService.getSessionID != "" else { throw TrackerErr.emptySession }

        guard !getLogged else { throw TrackerErr.alreadyLoggedIn }

        var toSubscribe = [String:Any]()
        toSubscribe["source"] = "mobile"

        var fields = [String:Any]()
        if sub.email != "" { fields["email"] = sub.email }
        if sub.phone != "" { fields["phone"] = sub.phone }
        if sub.firstName != "" { fields["firstName"] = sub.firstName}
        if sub.lastName != "" { fields["lastName"] = sub.lastName }
        toSubscribe["fields"] = fields

        if sub.integrations != nil {
            toSubscribe["integraions"] = sub.integrations
        }
        if sub.groups?.count != 0 {
            toSubscribe["groups"] = sub.groups
        }
        if sub.extrafields != nil{
            toSubscribe["extraFields"] = sub.extrafields
        }

        if sub.email != "" && sub.phone != "" && (sub.mainChannel == "" || sub.mainChannel == nil) {
            toSubscribe["mainChannel"] = "email"
        }
        if sub.email == "" && sub.phone == "" && (sub.mainChannel == "" || sub.mainChannel == nil){
            toSubscribe["mainChannel"] = "session"
        }

        var url = URLComponents(string: urls["getPerson"]!)
        var params: [URLQueryItem] = []
        if sub.email != "" { params.append(URLQueryItem(name: "email", value: sub.email)) }
        if sub.phone != "" { params.append(URLQueryItem(name:"phone", value: sub.phone)) }
        url?.queryItems = params
        var urlRequest = URLRequest(url:(url?.url)!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(PushNotificationService.getAccount!, forHTTPHeaderField: "X-Account")
        urlRequest.addValue(PushNotificationService.getSessionID!, forHTTPHeaderField: "X-Session-Id")
        URLSession.shared.dataTask(with: urlRequest) { [self](data, response, error) in
            guard let data = data else { return }
            let response = response as? HTTPURLResponse
            if response?.statusCode == 404{
                try? self.subscribeNew(subscriberInfo: toSubscribe)
                self.setEmail(email: sub.email!)
                self.setPhone(phone: sub.phone!)
            } else if response!.statusCode < 400 {
                try? self.subscribeNew(subscriberInfo: toSubscribe)
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return }
                self.updateCurrent(person: PersonData(
                    cart:       mergeCarts(new: json["cart"] as! [String : Any]),
                    favourite:  mergeFavourites(new: json["favourite"] as! [String : Any]),
                    session:    PushNotificationService.getSessionID ?? ""),
                    email:      sub.email!,
                    phone:      sub.phone!)
            }
        }.resume()
    }

    private func mergeCarts(new:[String:Any]) -> [String:Any] {
        var items = self.cart.Cart["products"] as? [[String:Any]] ?? [[String:Any]]()
        let newItems = new["products"] as? [[String:Any]] ?? [[String:Any]]()
            for (_, v) in newItems.enumerated(){
                let item = ["productId":v["productId"], "count":v["count"]]
                items.append(item)
        }
        var lastUpdate: Int
        if new["lastUpdate"] as? Int ?? 0 >= self.cart.Cart["lastUpdate"] as? Int ?? 0 {
            lastUpdate = new["lastUpdate"] as? Int ?? 0
        }else{
            lastUpdate = self.cart.Cart["lastUpdate"] as? Int ?? 0
        }
        self.cart.Cart["products"] = items
        self.cart.Cart["lastUpdate"] = lastUpdate
        
        let json: [String : Any] = ["cart": self.cart.Cart]

        guard JSONSerialization.isValidJSONObject(json) else {
            return [String:Any]()
        }
        let requestBody = try! JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["cart"]!, requestBody) else { return [String:Any]() }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
        
        return ["products": items, "lastUpdate": lastUpdate]
    }

    private func mergeFavourites(new:[String:Any]) -> [String:Any]{
        var items = self.favourite.Favourite["products"] as? [[String:Any]] ?? [[String:Any]]()
        let newItems = new["products"] as? [[String:Any]] ?? [[String:Any]]()
            for (_, v) in newItems.enumerated(){
                let item = ["productId":v["productId"], "count":v["count"]]
                items.append(item)
        }
        var lastUpdate: Int
        if new["lastUpdate"] as? Int ?? 0 >= self.favourite.Favourite["lastUpdate"] as? Int ?? 0 {
            lastUpdate = new["lastUpdate"] as? Int ?? 0
        }else{
            lastUpdate = self.favourite.Favourite["lastUpdate"] as? Int ?? 0
        }
        self.favourite.Favourite["products"] = items
        self.favourite.Favourite["lastUpdate"] = lastUpdate

        let json: [String : Any] = ["wishlist": self.favourite.Favourite]
        
        guard JSONSerialization.isValidJSONObject(json) else {
            return [String:Any]()
        }
        let requestBody = try! JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["favourite"]!, requestBody) else { return [String:Any]() }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
        
        return ["products": items, "lastUpdate": lastUpdate]
    }

    fileprivate func logOut(){
        dropEmail()
        dropPhone()
        setLogged(isLogged: false)
        PushNotificationService.unsubscribePush()
        PushNotificationService.dropSession()
        SessionService.createSession(account: PushNotificationService.getAccount!)
        cart = Cart()
        favourite = Favourite()
    }

    fileprivate func productBuy(order: Order) throws {
        var order = order

        if order.orderId == "" || order.orderId == nil { order.orderId = UUID().uuidString.lowercased() }

        guard let items = self.cart.Cart["products"] as? [[String:Any]] else {
            throw TrackerErr.emptyCart
        }

        var orderInfo = [String:Any]()

        var orderFields = [String:Any]()
        if order.fields != nil {
            for (k, v) in order.fields! {
                orderFields[k] = v
            }
        }
        if order.sum != nil { orderFields["sum"] = String(format: "%.2f", order.sum!) }
        if order.price != nil { orderFields["price"] = String(format: "%.2f", order.price!) }

        orderInfo["items"] = items
        if !orderFields.isEmpty {
            orderInfo["order"] = orderFields
        }

        let json = ["orderId": order.orderId as Any,
                    "orderInfo": orderInfo] as [String : Any]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }
        let requestBody = try JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["productBuy"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productBuyed()
                    //при успешной покупке корзина чистится
                    try? self.clearCart()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func productOpen(product: Product) throws{
        var product = product
        do {
            product = try checkProduct(product)
        }catch is TrackerErr {
            throw TrackerErr.emptyProductId
        }

        var productToSend = [String:Any]()
        productToSend["action"] = "productOpen"

        var params = [String:Any]()
        if product.fields?.count != 0 && product.fields != nil {
            for (key, value) in product.fields! {
                params[key] = value
            }
        }
        productToSend["product"] = ["id": product.id, "params": params]

        guard JSONSerialization.isValidJSONObject(productToSend) else {
            throw TrackerErr.invalidJson
        }

        let requestBody = try? JSONSerialization.data(withJSONObject: productToSend)

        guard let urlRequest = prepareRequest("POST", urls["productOpen"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.productOpened()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func addExtraFields(fields: [String:Any]) throws{
        guard JSONSerialization.isValidJSONObject(fields) else {
            throw TrackerErr.invalidJson
        }
        let requestBody = try? JSONSerialization.data(withJSONObject: ["extraFields":fields])
        guard let urlRequest = prepareRequest("POST", urls["addExtraFields"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.extrafieldsAdded()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func pageOpen(url: String) throws {
        let json = ["url":url]

        let requestBody = try JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["pageOpen"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.delegate?.pageOpened()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }

    fileprivate func clearCart() throws {
        self.cart = Cart()
        self.cart.Cart["products"] = [String:Any]()
        self.cart.Cart["lastUpdate"] = Int(Date().timeIntervalSince1970)
        
        let json: [String : Any] = ["cart": self.cart.Cart]

        guard JSONSerialization.isValidJSONObject(json) else {
            throw TrackerErr.invalidJson
        }
        let requestBody = try! JSONSerialization.data(withJSONObject: json)
        guard let urlRequest = prepareRequest("POST", urls["cart"]!, requestBody) else { return }

        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if data != nil {
            } else if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.failure(error)
                }
            }
        }.resume()
    }
}

public enum TrackerService {
    public static weak var delegate: TrackerServiceDelegate?
    private static var t: Tracker = Tracker(d: delegate)

    public static func parseProduct(_ data: String) -> Product?{
        var productMap = parseMap(text: data)

        guard let id = productMap?["productId"] as? String else { return nil }
        productMap?.removeValue(forKey: "productId")

        var product = Product(id: id)

        product.count = productMap?["count"] as? Int64
        productMap?.removeValue(forKey: "count")

        var fields = [String:Any]()

        guard productMap?.count != 0 else { return product }

        for (key, value) in productMap! {
            fields[key] = value
        }

        product.fields = fields

        return product
    }

    public static func productAdd(_ product: Product) {
        do{
            try t.productAdd(product: product)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func productRemove(_ product: Product){
        do{
            try t.productRemove(product)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func productLike(_ product:Product){
        do{
            try t.productLike(product)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func productDislike(_ product: Product){
        do{
            try t.productDislike(product)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func parseMap(text: String) -> [String:Any]?{
        if let data = text.data(using: .utf8){
            do{
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }

    public static func parseSubscriber(text: String) -> Subscriber?{
        var sub = [String:Any]?(["":""])
        if let data = text.data(using: .utf8){
            do{
                sub = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            }catch{
                print(error.localizedDescription)
            }
        }

        var subscriber = Subscriber()
        let fields = sub?["fields"] as? [String:Any]
        subscriber.email = fields?["email"] as? String ?? ""
        subscriber.phone = fields?["phone"] as? String ?? ""
        subscriber.firstName = fields?["firstName"]as? String ?? ""
        subscriber.lastName = fields?["lastName"]as? String ?? ""
        subscriber.groups = sub?["groups"] as? [Any] ?? []
        subscriber.integrations = sub?["integrations"] as? [Int64] ?? []
        subscriber.mainChannel = sub?["mainChannel"] as? String ?? ""
        subscriber.extrafields = sub?["extraFields"] as? [String:Any]

        return subscriber
    }

    public static func subscribe(s: Subscriber){
        do{
            try t.subscribe(s)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func clearCart(){
        try? t.clearCart()
    }


    public static func productBuy(order: Order){
        do{
            try t.productBuy(order: order)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func productOpen(product: Product){
        do{
            try t.productOpen(product: product)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func addExtrafields(fields: [String:Any]){
        do{
            try t.addExtraFields(fields: fields)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func pageOpen(url: String) {
        do{
            try t.pageOpen(url: url)
        }catch let TrackerErr{
            print(TrackerErr)
        }
    }

    public static func logOut(){
        t.logOut()
    }

    public static func updateContacts(email: String, phone: String){
        t.updateContacts(email, phone)
    }
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

