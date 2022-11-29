//
//  ImageVC.swift
//  TweeterTags
//
//  Created by Harvey on 22/11/2022.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tweetImage: UIImageView!
    var imageToDisplay:UIImage? = nil
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { tweetImage }
    
    // Function to set display image and zoom
    func setImageAndZoom(imageToDisplay: UIImage) {
        tweetImage.image = imageToDisplay
        scrollView.addSubview(tweetImage)
        scrollView.sizeToFit()
        scrollView.contentSize = tweetImage.frame.size
        
        // Get image height
        let imageHeight = imageToDisplay.size.height
        let scrollViewHeight = scrollView.contentSize.height
        var zoomScale:CGFloat = 1

        if scrollViewHeight < imageHeight {
            zoomScale = imageHeight / scrollViewHeight
        } else {
            zoomScale = scrollViewHeight / imageHeight
        }
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.setZoomScale(zoomScale, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if let imageToDisplay = imageToDisplay {
            setImageAndZoom(imageToDisplay: imageToDisplay)
        }
    }
}
