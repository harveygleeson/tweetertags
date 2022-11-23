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
    func setImage(imageToDisplay: UIImage) {
        tweetImage.image = imageToDisplay
        scrollView.contentSize = imageToDisplay.size
        scrollView.frame = CGRect(x: 0, y: 0, width: imageToDisplay.size.width, height: imageToDisplay.size.height)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.addSubview(tweetImage)
        scrollView.setZoomScale(2, animated: false)
        scrollView.contentOffset.x = (imageToDisplay.size.width / 2) - (UIScreen.main.bounds.maxX / 2)
        scrollView.contentOffset.x = (imageToDisplay.size.height / 2) - (UIScreen.main.bounds.maxY / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if let imageToDisplay = imageToDisplay {
            setImage(imageToDisplay: imageToDisplay)
        }
    }
}
