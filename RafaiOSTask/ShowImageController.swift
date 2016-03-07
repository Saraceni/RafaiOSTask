//
//  ShowImageController.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import UIKit

class ShowImageController: UIViewController {
    
    //var data: NSDictionary?
    var imgurObject: ImgurObject?
    //var img: UIImage?

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var downvotesLabel: UILabel!
    @IBOutlet var upvotesLabel: UILabel!
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet var photoImgView: UIImageView!
    @IBOutlet var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //picture.image = img
        
        //let title = data?.objectForKey("title") as? String
        //self.title = title
        
        self.title = imgurObject?.title
        
        if let upvotes = imgurObject?.ups {
            upvotesLabel.text = "Ups: " + String(upvotes)
        } else { upvotesLabel.text = "" }
        
        if let downvotes = imgurObject?.downs {
            downvotesLabel.text = "Downs: " + String(downvotes)
        } else { downvotesLabel.text = "" }
        
        if let score = imgurObject?.score {
            scoreLabel.text = "Score: " + String(score)
        } else { scoreLabel.text = "" }
        
        if let isAlbum = imgurObject?.isAlbum {
            
            let url = NSURL(string: imgurObject!.link)!
            
            if isAlbum {
            
                photoImgView.hidden = true
                webView.hidden = false
                webView.delegate = self
                
                let urlRequest = NSURLRequest(URL: url)
                webView.loadRequest(urlRequest)
            }
            else {
                
                webView.hidden = true
                photoImgView.hidden = false
                
                photoImgView.sd_setImageWithURL(url)
            }
            
        }
        
        /*if let upvotes = data?.objectForKey("ups") as? Int
        {
            upvotesLabel.text = "Ups: " + String(upvotes)
        } else { upvotesLabel.text = "" }
        
        if let downvotes = data?.objectForKey("downs") as? Int
        {
            downvotesLabel.text = "Downs: " + String(downvotes)
        } else { downvotesLabel.text = "" }
        
        if let score = data?.objectForKey("score") as? Int
        {
            scoreLabel.text = "Score: " + String(score)
        } else { scoreLabel.text = "" }*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShowImageController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
            print(error)
        }
    }
}
