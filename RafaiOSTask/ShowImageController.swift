//
//  ShowImageController.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import UIKit
import Foundation

class ShowImageController: UIViewController {
    
    var imgurObject: ImgurObject?

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var downvotesLabel: UILabel!
    @IBOutlet var upvotesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var photoImgView: UIImageView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = imgurObject?.title
        activityIndicator.hidden = true
        
        if let upvotes = imgurObject?.ups {
            
            let upsAttachment = NSTextAttachment()
            upsAttachment.image = UIImage(named: "ThumbUp24dp")
            
            let upsText = " " + String(upvotes)
            let upsTextAttributed = NSAttributedString(string: upsText)
            let upsAttachmentString = NSAttributedString(attachment: upsAttachment)
            let upsAttributedText = NSMutableAttributedString(attributedString: upsAttachmentString)
            upsAttributedText.appendAttributedString(upsTextAttributed)
            
            upvotesLabel.attributedText = upsAttributedText
            
            //upvotesLabel.text = "Ups: " + String(upvotes)
        } else { upvotesLabel.text = "" }
        
        if let downvotes = imgurObject?.downs {
            
            let downsAttachment = NSTextAttachment()
            downsAttachment.image = UIImage(named: "ThumbDown24dp")
            let downsAttachmentString = NSAttributedString(attachment: downsAttachment)
            
            let downsText = " " + String(downvotes)
            let downsTextAttributed = NSAttributedString(string: downsText)
            let downsAttributedText = NSMutableAttributedString(attributedString: downsAttachmentString)
            downsAttributedText.appendAttributedString(downsTextAttributed)
            
            downvotesLabel.attributedText = downsAttributedText
            
        } else { downvotesLabel.text = "" }
        
        if let score = imgurObject?.score {
            
            let scoreAttachment = NSTextAttachment()
            scoreAttachment.image = UIImage(named: "Top24dp")
            let scoreAttachmentString = NSAttributedString(attachment: scoreAttachment)
            
            let scoreText = " " + String(score)
            let scoreTextAttributed = NSAttributedString(string: scoreText)
            let scoreAttributedText = NSMutableAttributedString(attributedString: scoreAttachmentString)
            scoreAttributedText.appendAttributedString(scoreTextAttributed)
            
            scoreLabel.attributedText = scoreAttributedText
            
        } else { scoreLabel.text = "" }
        
        if let description = imgurObject?.description {
            descriptionLabel.text = description
        }
        else { descriptionLabel.hidden = true }
        
        if let isAlbum = imgurObject?.isAlbum {
            
            let url = NSURL(string: imgurObject!.link)!
            
            if isAlbum {
            
                scrollView.hidden = true
                webView.hidden = false
                webView.delegate = self
                
                activityIndicator.hidden = false
                activityIndicator.startAnimating()
                
                let urlRequest = NSURLRequest(URL: url)
                webView.loadRequest(urlRequest)
                
                descriptionLabel.hidden = true
            }
            else {
                
                webView.hidden = true
                scrollView.hidden = false
                
                photoImgView.sd_setImageWithURL(url)
            }
            
        }
        
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
}











