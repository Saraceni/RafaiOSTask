//
//  ViewController.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/12/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    var links = [String]()
    var data: NSArray?

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        RequestHelper.performRequest(RequestHelper.SECTION_HOT, page: "0", viral: false, callback: { response in
            if let array = DataParser.getArrays(response) {
                self.data = array
                self.links.removeAll()
                for element in array
                {
                    if let link = element["link"] as? String {
                        self.links.append(link)
                        print(link)
                    }
                }
                self.collectionView.reloadData()
                print("reloaded data")
                print(self.links.count)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDelegate
{
    
}

extension ViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        //let data = NSData(contentsOfURL: NSURL(string: links[indexPath.row])!)
        //cell.imageView.image = UIImage(data: data!)
        let url = NSURL(string: links[indexPath.row])!
        cell.imageView.sd_setImageWithURL(url)
        // Configure the cell
        return cell
    }
}










