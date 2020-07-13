//
//  InAppPurchaseViewController.swift
//  ColorMask
//
//  Created by chris on 2018/2/26.
//  Copyright © 2018年 SoloGame. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SwiftyJSON

enum IAPHandlerAlertType{
    case disabled
    case restored  //恢复购买成功
    case purchased //购买成功
    case failed
    case paymentCancelled
    case continueFailed
    case noPurchaseRestore
    case verifyed
    case verifyFailed //验证失败
    case expired //过期
    case restoreFailed //恢复购买失败
    case notPurchased //没有购买过
    
    func message() -> String{
        switch self {
        case .failed:
            return "Your purchase is failed! Please try later."
        case .disabled, .verifyFailed, .expired, .notPurchased:
            return "Purchases are disabled in your device!"
        case .restored, .purchased:
            return "You've successfully restored your purchase!"
        case .restoreFailed:
            return "Please check your account subscription information and try again."
        case .continueFailed,.verifyed, .paymentCancelled:
            return ""
        case .noPurchaseRestore:
            return "Please check your account subscription information and try again."
        }
    }
}

extension Bool{
    func intergerValue() -> Int{
        if self == true{
            return 1
        }
        return 0
    }
}

enum RegisteredPurchase: String {
    
    case virtual8 = "cei.virtualClass.8"
    case virtual12 = "cei.virtualClass.12"
    case virtual18 = "cei.virtualClass.18"
    case virtual25 = "cei.virtualClass.25"
    case virtual28 = "cei.virtualClass.28"
    case virtual30 = "cei.virtualClass.30"
    case virtual40 = "cei.virtualClass.40"
    case virtual45 = "cei.virtualClass.45"
    case virtual50 = "cei.virtualClass.50"
    case virtual60 = "cei.virtualClass.60"
    case virtual68 = "cei.virtualClass.68"
    case virtual73 = "cei.virtualClass.73"
    case virtual78 = "cei.virtualClass.78"
    case virtual88 = "cei.virtualClass.88"
    case virtual93 = "cei.virtualClass.93"
    case virtual98 = "cei.virtualClass.98"
    case virtual108 = "cei.virtualClass.108"
    case virtual113 = "cei.virtualClass.113"
    case virtual118 = "cei.virtualClass.118"
    case virtual123 = "cei.virtualClass.123"
    case virtual128 = "cei.virtualClass.128"
    case virtual138 = "cei.virtualClass.138"
    case virtual148 = "cei.virtualClass.148"
    case virtual153 = "cei.virtualClass.153"
    case virtual158 = "cei.virtualClass.158"
    case virtual163 = "cei.virtualClass.163"
    case virtual168 = "cei.virtualClass.168"
    case virtual178 = "cei.virtualClass.178"
    case virtual188 = "cei.virtualClass.188"
    case virtual193 = "cei.virtualClass.193"
    case virtual198 = "cei.virtualClass.198"
    case virtual208 = "cei.virtualClass.208"
    case virtual218 = "cei.virtualClass.218"
    case virtual223 = "cei.virtualClass.223"
    case virtual228 = "cei.virtualClass.228"
    case virtual233 = "cei.virtualClass.233"
    case virtual238 = "cei.virtualClass.238"
    case virtual243 = "cei.virtualClass.243"
    case virtual248 = "cei.virtualClass.248"
    case virtual253 = "cei.virtualClass.253"
    case virtual258 = "cei.virtualClass.258"
    case virtual263 = "cei.virtualClass.263"
    case virtual268 = "cei.virtualClass.268"
    case virtual273 = "cei.virtualClass.273"
    case virtual278 = "cei.virtualClass.278"
    case virtual283 = "cei.virtualClass.283"
    case virtual288 = "cei.virtualClass.288"
    case virtual298 = "cei.virtualClass.298"
    case virtual308 = "cei.virtualClass.308"
    case virtual318 = "cei.virtualClass.318"
    case virtual328 = "cei.virtualClass.328"
    case virtual348 = "cei.virtualClass.348"
    case virtual388 = "cei.virtualClass.388"
    
    
    case virtual418 = "cei.virtualClass.418"
    case virtual448 = "cei.virtualClass.448"
    case virtual488 = "cei.virtualClass.488"
    case virtual518 = "cei.virtualClass.518"
    case virtual548 = "cei.virtualClass.548"
    case virtual588 = "cei.virtualClass.588"
    case virtual618 = "cei.virtualClass.618"
    case virtual648 = "cei.virtualClass.648"
    case virtual698 = "cei.virtualClass.698"
    case virtual798 = "cei.virtualClass.798"
    case virtual818 = "cei.virtualClass.818"
    case virtual848 = "cei.virtualClass.848"
    case virtual898 = "cei.virtualClass.898"
    case virtual998 = "cei.virtualClass.998"
    case virtual1048 = "cei.virtualClass.1048"
    case virtual1098 = "cei.virtualClass.1098"
    case virtual1148 = "cei.virtualClass.1148"
    case virtual1198 = "cei.virtualClass.1198"
    case virtual1248 = "cei.virtualClass.1248"
    case virtual1298 = "cei.virtualClass.1298"
    case virtual1398 = "cei.virtualClass.1398"
    case virtual1448 = "cei.virtualClass.1448"
    case virtual1498 = "cei.virtualClass.1498"
    case virtual1598 = "cei.virtualClass.1598"
    case virtual1648 = "cei.virtualClass.1648"
    case virtual1998 = "cei.virtualClass.1998"
    case virtual2298 = "cei.virtualClass.2298"
    case virtual2598 = "cei.virtualClass.2598"
    case virtual2998 = "cei.virtualClass.2998"
    case virtual3298 = "cei.virtualClass.3298"
    case virtual3998 = "cei.virtualClass.3998"
    case virtual4498 = "cei.virtualClass.4498"
    case virtual4998 = "cei.virtualClass.4998"
    case virtual5898 = "cei.virtualClass.5898"
    case virtual6498 = "cei.virtualClass.6498"
    
    case studyCardValue88 = "cei.studyCardValue.88"
    case studyCardValue148 = "cei.studyCardValue.148"
    
    case virtualTest = "cei.virtualClass.test"
    case none = "cei.0000.test"
    
    var price: String {
        var price = ""
        switch self {
        case .virtual8:
            price = "8"
        case .virtual12:
            price = "12"
        case .virtual18:
            price = "18"
        case .virtual25:
            price = "25"
        case .virtual28:
            price = "28"
        case .virtual30:
            price = "30"
        case .virtual40:
            price = "40"
        case .virtual45:
            price = "45"
        case .virtual50:
            price = "50"
        case .virtual60:
            price = "60"
        case .virtual68:
            price = "68"
        case .virtual73:
            price = "73"
        case .virtual78:
            price = "78"
        case .virtual88:
            price = "88"
        case .virtual93:
            price = "93"
        case .virtual98:
            price = "98"
        case .virtual108:
            price = "108"
        case .virtual113:
            price = "113"
        case .virtual118:
            price = "118"
        case .virtual123:
            price = "123"
        case .virtual128:
            price = "128"
        case .virtual138:
            price = "138"
        case .virtual148:
            price = "145"
        case .virtual153:
            price = "153"
        case .virtual158:
            price = "158"
        case .virtual163:
            price = "163"
        case .virtual168:
            price = "168"
        case .virtual178:
            price = "178"
        case .virtual188:
            price = "188"
        case .virtual193:
            price = "193"
        case .virtual198:
            price = "198"
        case .virtual208:
            price = "208"
        case .virtual218:
            price = "218"
        case .virtual223:
            price = "223"
        case .virtual228:
            price = "228"
        case .virtual233:
            price = "233"
        case .virtual238:
            price = "238"
        case .virtual243:
            price = "243"
        case .virtual248:
            price = "248"
        case .virtual253:
            price = "253"
        case .virtual258:
            price = "258"
        case .virtual263:
            price = "263"
        case .virtual268:
            price = "268"
        case .virtual273:
            price = "273"
        case .virtual278:
            price = "278"
        case .virtual283:
            price = "283"
        case .virtual288:
            price = "288"
        case .virtual298:
            price = "298"
        case .virtual308:
            price = "308"
        case .virtual318:
            price = "318"
        case .virtual328:
            price = "328"
        case .virtual348:
            price = "348"
        case .none:
            price = "1"
        case .virtual388:
            price = "388"
        case .virtualTest:
            price = "6"
        case .virtual418:
            price = "418"
        case .virtual448:
            price = "448"
        case .virtual488:
            price = "488"
        case .virtual518:
            price = "518"
        case .virtual548:
            price = "548"
        case .virtual588:
            price = "588"
        case .virtual618:
            price = "618"
        case .virtual648:
            price = "648"
        case .virtual698:
            price = "698"
        case .virtual798:
            price = "798"
        case .virtual818:
            price = "818"
        case .virtual848:
            price = "848"
        case .virtual898:
            price = "898"
        case .virtual998:
            price = "998"
        case .virtual1048:
            price = "1048"
        case .virtual1098:
            price = "1098"
        case .virtual1148:
            price = "1148"
        case .virtual1198:
            price = "1198"
        case .virtual1248:
            price = "1248"
        case .virtual1298:
            price = "1298"
        case .virtual1398:
            price = "1398"
        case .virtual1448:
            price = "1448"
        case .virtual1498:
            price = "1498"
        case .virtual1598:
            price = "1598"
        case .virtual1648:
            price = "1648"
        case .virtual1998:
            price = "1998"
        case .virtual2298:
            price = "2298"
        case .virtual2598:
            price = "2598"
        case .virtual2998:
            price = "2998"
        case .virtual3298:
            price = "3298"
        case .virtual3998:
            price = "3998"
        case .virtual4498:
            price = "4498"
        case .virtual4998:
            price = "4998"
        case .virtual5898:
            price = "5898"
        case .virtual6498:
            price = "6498"
        case .studyCardValue88:
            price = "88"
        case .studyCardValue148:
            price = "148"
        }
        return price
    }
}


class IAPHandler: NSObject {
    public var showFailedMessage:((String)->())?
    static let shared = IAPHandler()
    fileprivate var productID = ""
    fileprivate var iapProducts = [SKProduct]()
//    fileprivate var purchaseSource: AppsFlyerHelper.PurchaseSourceValue = .none
//    fileprivate var subscriptionModel: RealSubscriptionModel?
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    private override init() {
        super.init()
        setupIAP()
    }
    
    fileprivate(set) var purchase: RegisteredPurchase = {
        var myPurchase = RegisteredPurchase.none
        if let key = UserDefaults.Pay.string(forKey: .purchaseID), let id = RegisteredPurchase(rawValue: key){
            myPurchase = id
        }
        return myPurchase
        }(){
        didSet{
            UserDefaults.Pay.set(purchase.rawValue, forKey: .purchaseID)
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func setupIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.flatMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    //0: month, 1: year, 2: week
    func purchaseMyProduct(_ id: RegisteredPurchase){
//        HttpTool.shared.sendLog(logTitle: LogTitle.PurchaseClick, log: id.price)
        if iapProducts.count == 0 {
//            if DownloadManager.instance.networkIsAvailable == false {
//                HUDP.alertNetworkError()
//            }else{
//                HUDP.alert("Please try again later")
//            }
            fetchAvailableProducts()
            return
        }
//        subscriptionModel = model
//        purchaseSource = purchaseSoc
        
//        AppsFlyerHelper.track(event: .purchaseClick, withValues: [.price: id.price, .purchaseSource: purchaseSource.content(model: model)])
        
        if self.canMakePurchases() {
            purchase(id, atomically: true)
        }else{
            HUDP.hide()
            purchaseStatusBlock?(.disabled)
        }
    }
    
    func purchase(_ purchase: RegisteredPurchase, atomically: Bool) {
        
        HUDP.flashProgress()
        SwiftyStoreKit.purchaseProduct(purchase.rawValue , atomically: atomically) {[weak self] result in
            HUDP.hide()
            
            switch result{
            case .success(let purchaseDetails):
                let downloads = purchaseDetails.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchaseDetails.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseDetails.transaction)
                }
                //购买成功，存储
                if let transPurchase =  RegisteredPurchase(rawValue: purchaseDetails.productId){
                    self?.purchase = transPurchase
                }
                
                if (purchaseDetails.originalTransaction != nil) {
                    nslog("自动续期成功")
                    self?.appflyerTrackPaymentPurchased(purchase: purchase, isRenew: true)
                } else {
                    nslog("首次购买成功")
                    self?.appflyerTrackPaymentPurchased(purchase: purchase, isRenew: false)
                    let range = purchase.rawValue.range(of: ".", options: .backwards, range: nil, locale:nil)
                    let string = purchase.rawValue.substring(from: (range?.upperBound)!)
                }
                self?.receiptValidation()
                
            case .error(let error):
                nslog(error.localizedDescription)
                self?.purchase = .none
                switch error.code {
                case .unknown:
                    //更改订阅类型也会来这里
                    HUDP.alert("Unknown error. Please contact support")
                    break
                case .clientInvalid:
                    HUDP.alert("Not allowed to make the payment")
                    break
                case .paymentCancelled:
                    //已经订阅的也会走到这里
                    self?.purchaseStatusBlock?(.paymentCancelled)
                    return
                case .paymentInvalid:
                    HUDP.alert("The purchase identifier was invalid")
                    break
                case .paymentNotAllowed:
                    HUDP.alert("The device is not allowed to make the payment")
                    break
                case .storeProductNotAvailable:
                    HUDP.alert("The product is not available in the current storefront")
                    break
                case .cloudServicePermissionDenied:
                    HUDP.alert("Access to cloud service information is not allowed")
                    break
                case .cloudServiceNetworkConnectionFailed:
                    HUDP.alert("Could not connect to the network")
                    break
                case .cloudServiceRevoked:
                    HUDP.alert("Have revoked permission to use this cloud service")
                    break
                case .privacyAcknowledgementRequired:
                    HUDP.alert("Need to acknowledge Apple's privacy policy")
                    break
                case .unauthorizedRequestData:
                    HUDP.alert("Does not have the appropriate entitlement")
                    break
                case .invalidOfferIdentifier:
                    HUDP.alert("The specified subscription offer identifier is not valid")
                    break
                case .invalidSignature:
                    HUDP.alert("The cryptographic signature provided is not valid")
                    break
                case .missingOfferParams:
                    HUDP.alert("One or more parameters from SKPaymentDiscount is missing")
                    break
                case .invalidOfferPrice:
                    HUDP.alert("he price of the selected offer is not valid")
                    break
                default:
                    if error.errorCode == -1005 {
                        HUDP.alert("无法连接到 iTunes Store")
                    }else{
                        HUDP.alert("unknown")
                    }
                    break                    
                }
                self?.purchaseStatusBlock?(.failed)
            }
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(backgroud: Bool){
//        if DownloadManager.instance.networkIsAvailable == false {
//            //HUDP.alertNetworkError()
//            return
//        }
        if backgroud == false {
            HUDP.flashProgress()
        }
        
        SwiftyStoreKit.restorePurchases {[weak self] (results) in
            nslog("恢复购买")
            nslog(results)
            HUDP.hide()
            if results.restoredPurchases.count > 0, let purchases = results.restoredPurchases.last, let registeredPurchase = RegisteredPurchase.init(rawValue: purchases.productId) {
                self?.purchase = registeredPurchase
                DispatchQueue.main.async {
                    self?.verifyPurchase(isForce: true)
                }
            }else{
                self?.purchaseStatusBlock?(.restoreFailed)
                HUDP.hide()
            }
        }
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    /// 获取商品列表
    func fetchAvailableProducts(){
        fetchAvailableProducts(finished: nil)
    }
    
    fileprivate func fetchAvailableProducts(finished: (() -> ())?){
        let productIdentifiers = Set(arrayLiteral:
            RegisteredPurchase.virtual8.rawValue,
            RegisteredPurchase.virtual12.rawValue,
            RegisteredPurchase.virtual18.rawValue,
            RegisteredPurchase.virtual25.rawValue,
            RegisteredPurchase.virtual28.rawValue,
            RegisteredPurchase.virtual30.rawValue,
            RegisteredPurchase.virtual40.rawValue,
            RegisteredPurchase.virtual45.rawValue,
            RegisteredPurchase.virtual50.rawValue,
            RegisteredPurchase.virtual60.rawValue,
            RegisteredPurchase.virtual68.rawValue,
            RegisteredPurchase.virtual73.rawValue,
            RegisteredPurchase.virtual78.rawValue,
            RegisteredPurchase.virtual88.rawValue,
            RegisteredPurchase.virtual93.rawValue,
            RegisteredPurchase.virtual108.rawValue,
            RegisteredPurchase.virtual113.rawValue,
            RegisteredPurchase.virtual118.rawValue,
            RegisteredPurchase.virtual123.rawValue,
            RegisteredPurchase.virtual128.rawValue,
            RegisteredPurchase.virtual138.rawValue,
            RegisteredPurchase.virtual148.rawValue,
            RegisteredPurchase.virtual153.rawValue,
            RegisteredPurchase.virtual158.rawValue,
            RegisteredPurchase.virtual163.rawValue,
            RegisteredPurchase.virtual168.rawValue,
            RegisteredPurchase.virtual178.rawValue,
            RegisteredPurchase.virtual188.rawValue,
            RegisteredPurchase.virtual193.rawValue,
            RegisteredPurchase.virtual198.rawValue,
            RegisteredPurchase.virtual208.rawValue,
            RegisteredPurchase.virtual218.rawValue,
            RegisteredPurchase.virtual223.rawValue,
            RegisteredPurchase.virtual228.rawValue,
            RegisteredPurchase.virtual233.rawValue,
            RegisteredPurchase.virtual238.rawValue,
            RegisteredPurchase.virtual243.rawValue,
            RegisteredPurchase.virtual248.rawValue,
            RegisteredPurchase.virtual253.rawValue,
            RegisteredPurchase.virtual258.rawValue,
            RegisteredPurchase.virtual263.rawValue,
            RegisteredPurchase.virtual268.rawValue,
            RegisteredPurchase.virtual273.rawValue,
            RegisteredPurchase.virtual278.rawValue,
            RegisteredPurchase.virtual283.rawValue,
            RegisteredPurchase.virtual288.rawValue,
            RegisteredPurchase.virtual298.rawValue,
            RegisteredPurchase.virtual308.rawValue,
            RegisteredPurchase.virtual318.rawValue,
            RegisteredPurchase.virtual328.rawValue,
            RegisteredPurchase.virtual348.rawValue,
            RegisteredPurchase.none.rawValue)
        
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers) {[weak self] (results) in
            results.retrievedProducts.forEach({ (product) in
                self?.iapProducts.append(product)
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                nslog(product.localizedDescription + "\nfor just \(price1Str!)")
            })
            finished?()
        }
    }
}

extension IAPHandler{
    func appflyerTrackPaymentPurchased(purchase: RegisteredPurchase, isRenew: Bool){
//        var event = AppsFlyerHelper.Event.purchase
//        if isRenew {
//            event = AppsFlyerHelper.Event.renewSubscription //续订
//        }
//
//        AppsFlyerHelper.track(event: event, withValues: [
//            .revenue: "\(purchase.price)",
//            .currency : "USD",
//            .purchaseSource : self.purchaseSource.content(model: self.subscriptionModel)
//            ])
    }
}

// MARK: - Verify
extension IAPHandler{
    func verifyPurchase(isForce: Bool) {
        
        let subscriptionValid = UserDefaults.User.bool(forKey: .subscriptionValid)

        if subscriptionValid == false , isForce == false{
            return
        }

        if purchase == .none {
            purchaseStatusBlock?(.expired)
            return
        }
        
        var appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "dcfd3d9f60c04ccfa91b776c9cb311a9")
        #if DEBUG
            appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "dcfd3d9f60c04ccfa91b776c9cb311a9")
        #endif
        SwiftyStoreKit.verifyReceipt(using: appleValidator) {[weak self] (result) in
            switch result {
            case .success(let receipt):
                self?.verifySubscription(self?.purchase, receipt: receipt)
            case .error(let error):
                nslog(error)
                switch error {
                case .noReceiptData:
                    HUDP.debugAlert("Receipt verification:" + "No receipt data. Try again.")
                case .networkError(let error):
                    HUDP.debugAlert("Receipt verification:" + "Network error while verifying receipt: \(error)")
                default:
                    HUDP.debugAlert("Receipt verification:" + "Receipt verification failed: \(error)")
                }
            }
        }
    }
    
    private func verifySubscription(_ purchase: RegisteredPurchase?, receipt: ReceiptInfo){
        //HUDP.hide()
        guard let productId =  purchase?.rawValue else {
            assertionFailure("big bug")
            return
        }
        nslog(receipt)
        let recJson = JSON.init(receipt).dictionaryValue
        
        nslog("recJson:latest_receipt_info\(String(describing: recJson["latest_receipt_info"]))")
        let purchaseResult = SwiftyStoreKit.verifySubscription(
            ofType: .autoRenewable,
            productId: productId,
            inReceipt: receipt)
        
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
            HUDP.debugAlert("\(productId) is valid until \(expiryDate.formatterString)\n\(String(describing: items.first))\n")
            self.purchase = purchase!//缓存订阅ID，用于下次启动游戏验证
            purchaseStatusBlock?(.verifyed)
        case .expired(let expiryDate, let items):
           
            UserDefaults.Appalication.set(expiryDate.timeIntervalSince1970, forKey: UserDefaults.Appalication.DoubleDefaultKey.nextVerifySubscriptionDate)
            HUDP.debugAlert("\(productId) is expired since \(expiryDate.formatterString)\n\(String(describing: items.first))\n")
            purchaseStatusBlock?(.expired)
        case .notPurchased:
            //HUDP.debugAlert("This product has never been purchased")
            purchaseStatusBlock?(.notPurchased)
            
        }
    }
}

extension IAPHandler {
    func receiptValidation() {
        let SUBSCRIPTION_SECRET = "yourpasswordift"
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
                print("ERROR:" + error.localizedDescription)
            }
            //let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            print(base64encodedReceipt!)
            let requestDictionary = ["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
            guard JSONSerialization.isValidJSONObject(requestDictionary) else {
                self.purchaseStatusBlock?(.failed)
                print("requestDictionary is not valid JSON"); return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"//this works but as noted above it's best to use your own trusted server
                guard let validationURL = URL(string: validationURLString) else {
                    print("the validation url could not be created, unlikely error")
                    self.purchaseStatusBlock?(.failed)
                    return
                }
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                    print("这里慢？？？")
                    if let data = data, error == nil {
                        do {
                            let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                            nslog("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                            let jsonData = self.dicValueString(appReceiptJSON as! [String : Any])
                            let defaultStand = UserDefaults.standard
                            let defaultKey = "receipt"
                            defaultStand.set(base64encodedReceipt, forKey: defaultKey)
                            self.purchaseStatusBlock?(.purchased)
                            //if you are using your server this will be a json representation of whatever your server provided
                        } catch let error as NSError {
                            nslog("json serialization failed with error: \(error)")
                            self.purchaseStatusBlock?(.failed)
                        }
                    } else {
                        nslog("the upload task returned an error: \(String(describing: error))")
                        self.purchaseStatusBlock?(.failed)
                    }
                }
                task.resume()
            } catch let error as NSError {
                nslog("json serialization failed with error: \(error)")
                self.purchaseStatusBlock?(.failed)
            }
        }
    }
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
}


