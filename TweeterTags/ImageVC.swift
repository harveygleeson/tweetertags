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
        scrollView.contentSize = imageToDisplay.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.addSubview(tweetImage)
        scrollView.setZoomScale(2, animated: false)

        scrollView.contentOffset.x = (scrollView.contentSize.width / 2) - (scrollView.frame.width / 2)
        scrollView.contentOffset.y = (scrollView.contentSize.height / 2) - (scrollView.frame.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if let imageToDisplay = imageToDisplay {
            setImageAndZoom(imageToDisplay: imageToDisplay)
        }
    }
}
