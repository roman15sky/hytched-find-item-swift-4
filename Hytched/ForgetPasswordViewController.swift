//
//  ForgetPasswordViewController.swift
//  Hytched
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView
import MBProgressHUD

class ForgetPasswordViewController: UIViewController {

    @IBOutlet var emailView: UIView!
    @IBOutlet var emailIconView: UIView!
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.adjustUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Custom
    func adjustUI() {
        emailView.layer.borderWidth = 1.0
        emailView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        emailIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        resetBtn.layer.cornerRadius = CGFloat(cornerRadiusValue)
    }
    
    // MARK: - Button Actions
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onReset(_ sender: Any) {
        if isConfirmed() {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
                hub.hide(animated: true)
                if error == nil {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("OK") {
                        self.emailTF.text = ""
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertView.showSuccess("Success", subTitle: "A link to reset your password has been sent to your email address.")
                } else {
                    SCLAlertView().showError("Error", subTitle: "There is no account associated with this email address. Please try a different email address, or create a new account.")
                    self.emailTF.text = ""
                }
            }
        }
    }
    
    // MARK: - ConfirmData
    func isConfirmed() -> Bool {
        //fill out data
        if emailTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input your Email Address.")
            return false
        }
        //else
        return true
    }
}
