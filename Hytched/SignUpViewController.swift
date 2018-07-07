//
//  SignUpViewController.swift
//  Hytched
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseAuth
import Firebase
import MBProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet var fullnameView: UIView!
    @IBOutlet var fullnameIconView: UIView!
    @IBOutlet var fullnameTF: UITextField!
    
    
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailIconView: UIView!
    @IBOutlet var emailTF: UITextField!
    
    
    @IBOutlet var phoneView: UIView!
    @IBOutlet var phoneIconView: UIView!
    @IBOutlet var phoneTF: UITextField!
    
    
    @IBOutlet var pwView: UIView!
    @IBOutlet var pwIconView: UIView!
    @IBOutlet var pwTF: UITextField!
    
    @IBOutlet var repwView: UIView!
    @IBOutlet var repwIconView: UIView!
    @IBOutlet var repwTF: UITextField!
    
    
    @IBOutlet var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.adjustUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fullnameTF.text = ""
        self.emailTF.text = ""
        self.phoneTF.text = ""
        self.pwTF.text = ""
        self.repwTF.text = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Custom
    func adjustUI() {
        fullnameView.layer.borderWidth = 1.0
        fullnameView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        emailView.layer.borderWidth = 1.0
        emailView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        phoneView.layer.borderWidth = 1.0
        phoneView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        pwView.layer.borderWidth = 1.0
        pwView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        repwView.layer.borderWidth = 1.0
        repwView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        fullnameIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        emailIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        phoneIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        pwIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        repwIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        signupBtn.layer.cornerRadius = CGFloat(cornerRadiusValue)
    }

    // MARK: - Button Actions
    @IBAction func onViewTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if isConfirmed() {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            Auth.auth().createUser(withEmail: emailTF.text!, password: pwTF.text!) { (user, error) in
                hub.hide(animated: true)
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalTransitionStyle = .flipHorizontal
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                }
            }
        }
    }
    
    // MARK: - ConfirmData
    func isConfirmed() -> Bool {
        //fill out data
        if fullnameTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input your full name.")
            return false
        } else if emailTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input your email address.")
            return false
        } else if phoneTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input your phone number.")
            return false
        } else if pwTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input password.")
            return false
        } else if repwTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input retpe-password.")
            return false
        }
        //confirm pw
        if pwTF.text != repwTF.text {
            SCLAlertView().showError("Error", subTitle: "Your password is not matched.")
            pwTF.text = ""
            repwTF.text = ""
            return false
        }
        //else
        return true
    }
    
}
