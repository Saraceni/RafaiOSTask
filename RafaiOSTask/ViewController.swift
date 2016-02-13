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
    var data = NSMutableArray()
    
    @IBOutlet var userBarItem: UITabBarItem!
    @IBOutlet var topBarItem: UITabBarItem!
    @IBOutlet var hotBarItem: UITabBarItem!
    
    
    @IBOutlet var tabBar: UITabBar!
    
    func callback(response: (Response<AnyObject, NSError>)) -> ()
    {
        if let array = DataParser.getArrays(response) {
            //self.data = array
            self.data.removeAllObjects()
            self.links.removeAll()
            for element in array
            {
                if let link = element["link"] as? String where link.hasSuffix(".png") || link.hasSuffix(".gif") {
                    self.links.append(link)
                    self.data.addObject(element)
                    print(link)
                }
            }
            self.collectionView.reloadData()
            print("reloaded data")
            print(self.links.count)
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        tabBar.delegate = self
        
        tabBar.selectedItem = hotBarItem
        
        RequestHelper.performRequest(RequestHelper.SECTION_HOT, page: "0", viral: false, callback: callback)
        
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
        let url = NSURL(string: links[indexPath.row])!
        cell.imageView.sd_setImageWithURL(url)
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var viewSize = CGSize()
        
        if let width = collectionViewLayout.collectionView?.bounds.size.width { viewSize.width = width/3; viewSize.height = width/3 }
        else { viewSize.width = 128; viewSize.height = 128 }
        
        return viewSize
    }
}

extension ViewController: UITabBarDelegate
{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item === topBarItem
        {
            RequestHelper.performRequest(RequestHelper.SECTION_TOP, page: "0", viral: false, callback: callback)
        }
        else if item == userBarItem
        {
            RequestHelper.performRequest(RequestHelper.SECTION_USER, page: "0", viral: false, callback: callback)
        }
        else if item == hotBarItem
        {
            RequestHelper.performRequest(RequestHelper.SECTION_HOT, page: "0", viral: false, callback: callback)
        }
    }
}










