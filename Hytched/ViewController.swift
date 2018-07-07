//
//  ViewController.swift
//  Hytched
//
//  Created by Admin on 22/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView
import MBProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit

let cornerRadiusValue = 5.0

class ViewController: UIViewController {
    
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailIconView: UIView!
    @IBOutlet var emailTF: UITextField!
    
    
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordIconView: UIView!
    @IBOutlet var passwordTF: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    @IBOutlet var fbloginBtn: UIButton!
    @IBOutlet var fbBtnView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        self.adjustUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Custom
    func adjustUI() {
        emailView.layer.borderWidth = 1.0
        emailView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        passwordView.layer.borderWidth = 1.0
        passwordView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        emailIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        passwordIconView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        loginBtn.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        fbBtnView.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        let fpBtnTitle = "Forgot Password?"
        let fpBtnAttributedString = NSMutableAttributedString(string: fpBtnTitle)
        fpBtnAttributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: fpBtnTitle.count))
        forgotPasswordBtn.setAttributedTitle(fpBtnAttributedString, for: .normal)
        
        let registerBtnTitle = "Create new account"
        let registerBtnAttributedString = NSMutableAttributedString(string: registerBtnTitle)
        registerBtnAttributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: registerBtnTitle.count))
        registerBtn.setAttributedTitle(registerBtnAttributedString, for: .normal)
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func loginFacebookAction(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        let hub = MBProgressHUD.showAdded(to: view, animated: true)
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                hub.hide(animated: true)
                if (error == nil){
                    //everything works print the user data
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    let shub = MBProgressHUD.showAdded(to: self.view, animated: true)
                    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        shub.hide(animated: true)
                        if let error = error {
                            print(error)
                            // ...
                            return
                        }
                        // User is signed in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                        let navigationController = UINavigationController(rootViewController: vc)
                        navigationController.modalTransitionStyle = .flipHorizontal
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        if isConfirmed() {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
                hub.hide(animated: true)
                if error == nil {
                    print("You have successfully Logged In")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalTransitionStyle = .flipHorizontal
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                    self.emailTF.text = ""
                    self.passwordTF.text = ""
                }
            }
        }
    }
    
    @IBAction func onForgotPW(_ sender: Any) {
        self.performSegue(withIdentifier: "goForgotPWSegue", sender: nil)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "goSignUpSegue", sender: nil)
    }
    
    @IBAction func onViewTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: - ConfirmData
    func isConfirmed() -> Bool {
        //fill out data
        if emailTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input your Email Address.")
            return false
        } else if passwordTF.text == "" {
            SCLAlertView().showError("Error", subTitle: "Please input Password.")
            return false
        }
        //else
        return true
    }
    
}

