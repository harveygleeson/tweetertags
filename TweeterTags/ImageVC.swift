//
//  ImageVC.swift
//  TweeterTags
//
//  Created by Harvey on 22/11/2022.
//

import UIKit

class ImageVC: UIViewController {


    @IBOutlet weak var tweetImage: UIImageView! 
    var imageToDisplay:UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newImage = imageToDisplay {
            tweetImage.image = newImage
//            tweetImage.isUserInteractionEnabled = true
//
//            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector())
        }
    }
    
//    private func pinchGesture(sender: UIPinchGestureRecognizer)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
