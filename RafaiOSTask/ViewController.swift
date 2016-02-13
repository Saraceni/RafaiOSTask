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
    var page = 0
    
    let viral = 0
    let non_viral = 1
    
    var isViral = true
    
    var isLoading = false
    
    var section = RequestHelper.SECTION_HOT
    
    @IBOutlet var userBarItem: UITabBarItem!
    @IBOutlet var topBarItem: UITabBarItem!
    @IBOutlet var hotBarItem: UITabBarItem!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var tabBar: UITabBar!
    
    func callback(response: (Response<AnyObject, NSError>)) -> ()
    {
        if let array = DataParser.getArrays(response) {
            //self.data = array
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
        
        isLoading = false
    }

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        tabBar.delegate = self
        
        tabBar.selectedItem = hotBarItem
        
        segmentedControl.selectedSegmentIndex = viral
        segmentedControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        isLoading = true
        RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreData()
    {
        guard !isLoading else { return }
        
        page++
        
        RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
    }
    
    func clearData()
    {
        self.data.removeAllObjects()
        self.links.removeAll()
        page = 0
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        print("valueChanged")
        isViral = sender.selectedSegmentIndex == 0 ? true : false
        clearData()
        RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
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
        
        cell.label.text = data.objectAtIndex(indexPath.row).valueForKey("description") as? String
        
        if indexPath.row == links.count-1 { loadMoreData() }
        
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
        
        isLoading = true
        clearData()
        
        if item === topBarItem { section = RequestHelper.SECTION_TOP }
        else if item == userBarItem { section = RequestHelper.SECTION_USER }
        else if item == hotBarItem { section = RequestHelper.SECTION_HOT }
        
        RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
    }
}










