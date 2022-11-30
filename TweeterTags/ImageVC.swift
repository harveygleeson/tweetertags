//
//  ImageVC.swift
//  TweeterTags
//
//  Created by Harvey on 22/11/2022.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    private var imageView = UIImageView()
    var imageToDisplay: UIImage? = nil
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    
    // Function to set display image and zoom
    func setImageAndZoom(imageToDisplay: UIImage) {
        imageView.image = imageToDisplay
        imageView.sizeToFit()

        scrollView.contentSize = imageView.frame.size

        scrollView.minimumZoomScale = scrollView.bounds.width / imageView.frame.size.width
        scrollView.maximumZoomScale = 5
        scrollView.zoomScale = scrollView.bounds.height / imageView.frame.size.height
        
        let offsetX = (scrollView.contentSize.width / 2) - (scrollView.bounds.width / 2)
        scrollView.contentOffset.x = offsetX
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToDisplay = imageToDisplay {
            setImageAndZoom(imageToDisplay: imageToDisplay)
        }
    }
}
