//
//  ItemDetailViewController.swift
//  Hytched
//
//  Created by Admin on 28/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import WebKit

class ItemDetailViewController: UIViewController {

    public var productUrlStr = String()
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadWebSite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load Detail Site
    func loadWebSite() {
        let url = URL(string: productUrlStr)
        let req = URLRequest.init(url: url!)
        self.webView.load(req)
    }

    // MARK: - Button Action
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
