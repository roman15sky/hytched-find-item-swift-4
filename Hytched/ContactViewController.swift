//
//  ContactViewController.swift
//  Hytched
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Messages
import SCLAlertView

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var emailTF: UITextField!
    @IBOutlet var msgTV: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.adjustUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Adjust UI
    func adjustUI() {
        emailTF.layer.borderWidth = 1.0
        emailTF.layer.cornerRadius = CGFloat(cornerRadiusValue)
        msgTV.layer.borderWidth = 1.0
        msgTV.layer.cornerRadius = CGFloat(cornerRadiusValue)
    }
    
    // MARK: - Button Actions
    @IBAction func onViewTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onSend(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["hello@hytched.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody(msgTV.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        SCLAlertView().showError("Could Not Send Email", subTitle: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    

}
