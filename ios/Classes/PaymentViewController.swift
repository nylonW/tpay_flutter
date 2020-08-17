//
//  PaymentViewController.swift
//  tpay_flutter
//
//  Created by Marcin Slusarek on 17/08/2020.
//

import UIKit
import TpaySDK

class PaymentViewController: UIViewController {
    
    var delegate: TpayPaymentDelegate?
    var payment: TpayPayment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func performPayment() {
        performSegue(withIdentifier: "TpayPaymentInnerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TpayPaymentInnerSegue") {
            let childViewController = segue.destination as! TpayViewController
            childViewController.payment = payment
            childViewController.delegate = delegate
            childViewController.navigationItem.hidesBackButton = true
        }
    }
}
