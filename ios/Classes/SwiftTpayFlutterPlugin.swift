import Flutter
import UIKit
import TpaySDK

public class SwiftTpayFlutterPlugin: NSObject, FlutterPlugin, TpayPaymentDelegate {
    
    var tpayResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tpay_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftTpayFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "requestPayment" {
            
            tpayResult = result
            
            let payment = TpayPayment()
            payment.mId = "1010"
            payment.mAmount = "123.20"
            payment.mDescription = "Zakupy iOS"
            payment.mClientEmail = "email@kleint.pl"
            payment.mClientName = "Marcel"
            payment.mCrc = "CRC"
            payment.mSecurityCode = "demo"
            
            let paymentController = UIStoryboard(name: "PaymentStoryboard", bundle: Bundle(identifier: "org.cocoapods.tpay-flutter")).instantiateViewController(withIdentifier: "paymentVC") as! PaymentViewController
            
            paymentController.payment = payment
            paymentController.delegate = self
            
            let rootViewController: UIViewController! = UIApplication.shared.keyWindow?.rootViewController
            if (rootViewController is UINavigationController) {
                (rootViewController as! UINavigationController).pushViewController(paymentController, animated: true)
            } else {
                let holderVC = UINavigationController(rootViewController: paymentController)
                holderVC.navigationItem.hidesBackButton = true
                UIApplication.topViewController()?.present(holderVC, animated: true, completion: {
                    paymentController.performPayment()
                })
            }
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func tpayDidSucceed(with payment: TpayPayment!) {
        print("Succeed")
        
        if (UIApplication.topViewController() is TpayViewController) {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                if UIApplication.topViewController() is PaymentViewController {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        guard let result = tpayResult else { return }
        result(1)
    }
    
    public func tpayDidFailed(with payment: TpayPayment!) {
        print("Failed")
        guard let result = tpayResult else { return }
        result(0)
    }
}

extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
}
