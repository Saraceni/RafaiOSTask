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
    
    var shouldUpdatePreferences = false
    
    var data = [ImgurObject]()
    var page = 0
    
    
    let list = 0
    let grid = 1
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
    @IBOutlet var imgurTableView: UITableView!
    
    // MARK: - Preferences Variables
    var preferencesWindow: String?
    var preferencesSort: String?
    var preferencesShowViral = true
    
    
    func callback(response: (Response<AnyObject, NSError>), requestUUID: String) -> ()
    {
        
        guard requestUUID == currentRequestUUID else { return }
        
        if let array = DataParser.getArrays(response) {
            
            for element in array {
                
                if let link = element["link"] as? String {
                    
                    let imgurObject = ImgurObject(link: link)
                    imgurObject.description =  element["description"] as? String
                    imgurObject.ups = element["ups"] as? Int
                    imgurObject.downs = element["downs"] as? Int
                    imgurObject.score = element["score"] as? Int
                    imgurObject.title = element["title"] as? String
                    if let isAlbum = element["is_album"] as? Bool where isAlbum {
                        imgurObject.isAlbum = true
                        
                        if let images = element["images"] as? NSArray where images.count > 0 {
                            
                            if let firstImage = images[0] as? NSDictionary, let imgLink = firstImage["link"] as? String {
                                
                                imgurObject.firstImageLink = imgLink
                            }
                        }
                    }
                    data.append(imgurObject)
                }
            }
            
            self.collectionView.reloadData()
            self.imgurTableView.reloadData()
        }
        
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        imgurTableView.dataSource = self
        imgurTableView.delegate = self
        tabBar.delegate = self
        tabBar.selectedItem = hotBarItem
        
        self.preferencesWindow = Prefs.getWindow()
        self.preferencesSort = Prefs.getSort()
        self.preferencesShowViral = Prefs.getShowViral()
        
        self.currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: preferencesShowViral, sort: preferencesSort, window: preferencesWindow,callback: callback)
        
        segmentedControl.selectedSegmentIndex = list
        segmentedControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.shouldUpdatePreferences {
            updatePreferences()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePreferences() {
        preferencesWindow = Prefs.getWindow()
        preferencesSort = Prefs.getSort()
        preferencesShowViral = Prefs.getShowViral()
        shouldUpdatePreferences = false
        reloadData()
    }
    
    func reloadData() {
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        clearData()
        
        self.currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: preferencesShowViral, sort: preferencesSort, window: preferencesWindow, callback: callback)
        
    }
    
    func loadMoreData()
    {
        guard activityIndicator.hidden else { return }
    
        page++
    
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: preferencesShowViral, sort: preferencesSort, window: preferencesWindow, callback: callback)
    }
    
    func clearData()
    {
        self.data.removeAll()
        page = 0
        collectionView.reloadData()
        imgurTableView.reloadData()
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        
        if segmentedControl.selectedSegmentIndex == list {
            self.collectionView.hidden = true
            self.imgurTableView.hidden = false
        }
        else if segmentedControl.selectedSegmentIndex == grid {
            self.imgurTableView.hidden = true
            self.collectionView.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destController = segue.destinationViewController
        if let showImageController = destController as? ShowImageController
        {
            if let cell = sender as? ImageCollectionViewCell{
                showImageController.imgurObject = cell.imgurObject
                
            }
            else if let cell = sender as? ImgurTableViewCell {
                showImageController.imgurObject = cell.imgurObject
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ImgurTableViewCell.identifier, forIndexPath: indexPath) as! ImgurTableViewCell
        
        let imgurObject = data[indexPath.row]
        
        if imgurObject.isAlbum {
            
            if let firstImageLink = imgurObject.firstImageLink {
                let url = NSURL(string: firstImageLink)!
                cell.imgurImageView.sd_setImageWithURL(url)
            }
            else { cell.imgurImageView.image = UIImage(named: "Imgur48dp") }
        }
        else {
            let url = NSURL(string: imgurObject.link)!
            cell.imgurImageView.sd_setImageWithURL(url)
        }
        
        cell.imgurLabel.text = imgurObject.description
        
        cell.imgurObject = imgurObject
        
        if indexPath.row == data.count-1 { loadMoreData() }
        
        return cell
        
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let imgurObject = data[indexPath.row]
        
        if imgurObject.isAlbum {
            
            if let firstImageLink = imgurObject.firstImageLink {
                let url = NSURL(string: firstImageLink)!
                cell.picture.sd_setImageWithURL(url)
            }
            else { cell.picture.image = UIImage(named: "Imgur48dp") }
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
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        clearData()
        
        if item === topBarItem { section = RequestHelper.SECTION_TOP }
        else if item == userBarItem { section = RequestHelper.SECTION_USER  }
        else if item == hotBarItem { section = RequestHelper.SECTION_HOT }
        
        self.currentRequestUUID = RequestHelper.performRequest(section, page: String(page), viral: preferencesShowViral, sort: preferencesSort, window: preferencesWindow, callback: callback)
    }
}











