//
//  ResultViewController.swift
//  Hytched
//
//  Created by Admin on 27/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    public var productArray = [Product]()
    
    @IBOutlet var tableView: UITableView!
    
    var producturl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Download Image
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func setThumbnail(imgV : UIImageView, urlStr : String) {
        getDataFromUrl(url: URL(string: urlStr)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imgV.image = UIImage(data: data)!
            }
        }
    }
    
    // MARK: - UITableView Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        
        self.setThumbnail(imgV: cell.thumbnailImageView, urlStr: self.productArray[indexPath.row].thumbnailImageUrl)
        cell.nameLabel.text = self.productArray[indexPath.row].name
        cell.descriptionLabel.text = self.productArray[indexPath.row].shortDescription
        cell.priceLabel.text = String(format: "$ %.2f", self.productArray[indexPath.row].price)
        cell.ratingView.text = String(format: "(%d)", self.productArray[indexPath.row].numReviews)
        cell.ratingView.rating = Double(self.productArray[indexPath.row].customerRating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.producturl = self.productArray[indexPath.row].productUrl
        self.performSegue(withIdentifier: "goItemDetailSegue", sender: nil)
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goItemDetailSegue" {
            let vc = segue.destination as! ItemDetailViewController
            vc.productUrlStr = self.producturl
        }
    }

}
