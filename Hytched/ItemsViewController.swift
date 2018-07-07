//
//  ItemsViewController.swift
//  Hytched
//
//  Created by Admin on 26/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit
import CloudSight
import CoreLocation
import MBProgressHUD
import Alamofire
import SwiftyJSON
import SCLAlertView

class ItemsViewController: UIViewController ,CloudSightQueryDelegate {
    
    public var searchImg = UIImage()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var findBtn: UIButton!
    
    var itemArray = [Product]()
    var query : CloudSightQuery? = nil
    var APIKEY = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Init CloudSight
        CloudSightConnection.sharedInstance().consumerKey = ""
        CloudSightConnection.sharedInstance().consumerSecret = ""
        // Test Purpose
        //        CloudSightConnection.sharedInstance().consumerKey = "micgxNLMmChbXHLl0CLULA"
        //        CloudSightConnection.sharedInstance().consumerSecret = "O6swU0FK8ZkdiQcLhqDEPA"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init UI
    func initUI() {
        imageView.image = searchImg
        findBtn.layer.cornerRadius = CGFloat(cornerRadiusValue)
    }

    // MARK: - Button Actions
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onFind(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.searchWithImage(image: self.imageView.image!)
    }
    
    //MARK: - CloudSight Image Search
    func searchWithImage(image: UIImage) {
        let deviceIdentifier = UIDevice.current.identifierForVendor!.uuidString
        let location = myLocation
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        self.query = CloudSightQuery(image: imageData!, atLocation: CGPoint.zero, withDelegate: self, atPlacemark: location, withDeviceId: deviceIdentifier)
        self.query?.start()
    }
    
    //MARK: - CloudSightQuery Delegate
    func cloudSightQueryDidFinishUploading(_ query: CloudSightQuery!) {
        print("didfinishuploading")
    }
    
    func cloudSightQueryDidUpdateTag(_ query: CloudSightQuery!) {
        print("didupdatetag")
    }
    
    func cloudSightQueryDidFail(_ query: CloudSightQuery!, withError error: Error!) {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(error)
    }
    
    func cloudSightQueryDidFinishIdentifying(_ query: CloudSightQuery!) {
        if query.skipReason == nil {
            print(query.title)
            self.callWalmartAPI(withStr: query.title)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
            print(query.skipReason)
        }
    }
    
    // MARK: - Call Walmart API
    func callWalmartAPI(withStr:String) {
        let urlstr = "http://api.walmartlabs.com/v1/search?"
        let parameters : Parameters = ["apiKey" : APIKEY, "query" : withStr]
        
        DispatchQueue.main.async() {
            Alamofire.request(URL(string: urlstr)!, method: .get, parameters: parameters).responseJSON { (responseData) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                if((responseData.result.value) != nil) {
                    var swiftyJsonVar = JSON(responseData.result.value!)
//                    print(swiftyJsonVar)
                    if swiftyJsonVar["items"].count == 0 {
                        //Alert
                        SCLAlertView().showNotice("Result", subTitle: "There are no any matched items.")
                    } else {
                        for i in 0..<swiftyJsonVar["items"].count {
                            
                            var short_des = ""
                            if swiftyJsonVar["items"][i]["shortDescription"] != JSON.null {
                                short_des = swiftyJsonVar["items"][i]["shortDescription"].stringValue
                            }
                            
                            var thumbnail_urlstr = ""
                            if swiftyJsonVar["items"][i]["thumbnailImage"] != JSON.null {
                                thumbnail_urlstr = swiftyJsonVar["items"][i]["thumbnailImage"].stringValue
                            }
                            
                            var name = ""
                            if swiftyJsonVar["items"][i]["name"] != JSON.null {
                                name = swiftyJsonVar["items"][i]["name"].stringValue
                            }
                            
                            var rating = Float()
                            rating = 0.0
                            if swiftyJsonVar["items"][i]["customerRating"] != JSON.null {
                                rating = swiftyJsonVar["items"][i]["customerRating"].floatValue
                            }
                            
                            var price = Float()
                            price = 0.0
                            if swiftyJsonVar["items"][i]["salePrice"] != JSON.null {
                                price = swiftyJsonVar["items"][i]["salePrice"].floatValue
                            }
                            
                            var reviewnum = Int()
                            reviewnum = 0
                            if swiftyJsonVar["items"][i]["numReviews"] != JSON.null {
                                reviewnum = swiftyJsonVar["items"][i]["numReviews"].intValue
                            }
                            
                            var productURL = ""
                            if swiftyJsonVar["items"][i]["productUrl"] != JSON.null {
                                productURL = swiftyJsonVar["items"][i]["productUrl"].stringValue
                            }
                            
                            let product_item = Product.init(thumbnailImageUrl: thumbnail_urlstr, shortDescription: short_des, name: name, customerRating: rating, numReviews: reviewnum, price: price, productUrl: productURL)
                            self.itemArray.append(product_item)
                        }
                        // Go To Result View Controller
                        self.performSegue(withIdentifier: "goResultSegue", sender: nil)
                    }
                }else {
                    SCLAlertView().showNotice("Result", subTitle: "There are no any matched items.")
                }
            }
        }
    }

    
    // MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goResultSegue" {
            let vc = segue.destination as! ResultViewController
            vc.productArray = self.itemArray
        }
    }
}
