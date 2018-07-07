//
//  HomeViewController.swift
//  Hytched
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SCLAlertView
import YBPopupMenu
import FBSDKCoreKit
import FBSDKLoginKit


class HomeViewController: UIViewController ,YBPopupMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var menuBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func onMenu(_ sender: UIButton) {
        YBPopupMenu.show(at: CGPoint(x: menuBtn.frame.origin.x + menuBtn.frame.size.width/2, y: menuBtn.frame.origin.y + menuBtn.frame.size.height), titles: ["Logout", "Disclaimer", "Privacy Policy", "Terms & Conditions", "Contact"], icons: [], menuWidth: 200, otherSettings: { popupMenu in
            popupMenu?.dismissOnSelected = true
            popupMenu?.isShadowShowing = true
            popupMenu?.delegate = self
            popupMenu?.offset = 10
            popupMenu?.type = .dark
            popupMenu?.rectCorner = .topRight
        })
    }
    
    
    @IBAction func onTakePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            SCLAlertView().showError("Warning", subTitle: "You don't have camera")
        }
    }
    
    @IBAction func onSavedPhotos(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - YBPopUpMenu Delegate
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        print(index)
        if index == 0 {
            //Logout
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                fbLoginManager.logOut()
                //Go to View Controller
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
                let nav = UINavigationController(rootViewController: loginVC)
                UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    appdelegate.window!.rootViewController = nav
                }, completion: { completed in
                    // maybe do something here
                })
            } catch let signOutError as NSError {
                SCLAlertView().showError("Error", subTitle: signOutError.description)
            }
        } else if index == 1 {
            self.performSegue(withIdentifier: "goDisclaimerSegue", sender: nil)
            //Disclaimer
        } else if index == 2 {
            //Privacy Policy
            self.performSegue(withIdentifier: "goPrivacySegue", sender: nil)
        } else if index == 3 {
            //Terms & Conditions
            self.performSegue(withIdentifier: "goTermsSegue", sender: nil)
        } else if index == 4 {
            //Contact
            self.performSegue(withIdentifier: "goContactSegue", sender: nil)
        }
    }
    
    // MARK: - Image PickerView Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        if imagePicker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        self.performSegue(withIdentifier: "goItemSegue", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print(error?.localizedDescription)
    }
    
    //MARK: - Perform Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goItemSegue" {
            let vc = segue.destination as! ItemsViewController
            vc.searchImg = self.image
        }
    }
}

