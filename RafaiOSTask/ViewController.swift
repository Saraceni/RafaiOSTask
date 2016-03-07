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
    
    //var links = [String]()
    //var data = NSMutableArray()
    var data = [ImgurObject]()
    var page = 0
    
    
    let viral = 0
    let non_viral = 1
    var isViral = true
    //var isLoading = true
    var section = RequestHelper.SECTION_HOT
    
    // MARK: - RestRequest Variables
    let requestHelper = RequestHelper()
    var currentRequestUUID = NSUUID().UUIDString
    
    // MARK: - UI Variables
    @IBOutlet var userBarItem: UITabBarItem!
    @IBOutlet var topBarItem: UITabBarItem!
    @IBOutlet var hotBarItem: UITabBarItem!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var tabBar: UITabBar!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var collectionView: UICollectionView!
    
    func callback(response: (Response<AnyObject, NSError>), requestUUID: String) -> ()
    {
        
        guard requestUUID == currentRequestUUID else { return }
        
        if let array = DataParser.getArrays(response) {
            
            for element in array {
                
                //where link.hasSuffix(".png") || link.hasSuffix(".gif")
                if let link = element["link"] as? String {
                    
                    let imgurObject = ImgurObject(link: link)
                    imgurObject.description =  element["description"] as? String
                    imgurObject.ups = element["ups"] as? Int
                    imgurObject.downs = element["downs"] as? Int
                    imgurObject.score = element["score"] as? Int
                    imgurObject.title = element["title"] as? String
                    if let isAlbum = element["is_album"] as? Bool where isAlbum {
                        imgurObject.isAlbum = true
                    }
                    data.append(imgurObject)
                    //self.links.append(link)
                    //self.data.addObject(element)
                }
            }
            
            self.collectionView.reloadData()
        }
        
        activityIndicator.hidden = true
        //isLoading = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tabBar.delegate = self
        tabBar.selectedItem = hotBarItem
        
        segmentedControl.selectedSegmentIndex = viral
        segmentedControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        segmentedControl.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreData()
    {
        guard activityIndicator.hidden else { return }
        //guard !isLoading else { return }
        
        page++
        
        //isLoading = true
        activityIndicator.hidden = false
        
        //RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
        
        activityIndicator.hidden = false
        currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
    }
    
    func clearData()
    {
        //self.data.removeAllObjects()
        self.data.removeAll()
        //self.links.removeAll()
        page = 0
        collectionView.reloadData()
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        print("valueChanged")
        isViral = sender.selectedSegmentIndex == 0 ? true : false
        clearData()
        //RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
        
        //activityIndicator.hidden = false
        self.currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destController = segue.destinationViewController
        if let showImageController = destController as? ShowImageController
        {
            if let cell = sender as? ImageCollectionViewCell
            {
                showImageController.imgurObject = cell.imgurObject
                //showImageController.img = cell.picture.image
                //showImageController.data = cell.data
                
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate
{
   
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
        //return links.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let imgurObject = data[indexPath.row]
        
        if imgurObject.isAlbum {
            cell.picture.image = UIImage(named: "PhotoAlbum48dp")
        }
        else {
            let url = NSURL(string: imgurObject.link)!
            cell.picture.sd_setImageWithURL(url)
        }
        
        cell.label.text = imgurObject.description
    
        cell.imgurObject = imgurObject
        
        if indexPath.row == data.count-1 { loadMoreData() }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var viewSize = CGSize()
        
        let width = collectionView.frame.size.width
        viewSize.width = width/2; viewSize.height = width/2
        
        return viewSize
    }
    
}

extension ViewController: UITabBarDelegate
{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        //isLoading = true
        activityIndicator.hidden = false
        clearData()
        
        if item === topBarItem { section = RequestHelper.SECTION_TOP; segmentedControl.hidden = true }
        else if item == userBarItem { section = RequestHelper.SECTION_USER; segmentedControl.hidden = false  }
        else if item == hotBarItem { section = RequestHelper.SECTION_HOT; segmentedControl.hidden = true }
        
        //activityIndicator.hidden = false
        self.currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: isViral, callback: callback)
    }
}











