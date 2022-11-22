//
//  TweetTableViewCell.swift
//  TweeterTags
//
//  Created by Harvey on 20/11/2022.
//

import UIKit

class TweetTVCell: UITableViewCell {

    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!

    var tweet: TwitterTweet? {
        didSet {
            fillCell()
        }
    }
    
    private func fillCell() {
        if let tweet = tweet {
            if let imageUrl = tweet.user.profileImageURL {
                userImage.load(url: imageUrl)
            }
            
            username.text = tweet.user.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            let timeCreated = dateFormatter.string(from: tweet.created)
            tweetTime.text = timeCreated
            
            let attributedString = NSMutableAttributedString(string: tweet.text)
            let mentions = tweet.userMentions
            let urls = tweet.urls
            let hashtags = tweet.hashtags

            if !mentions.isEmpty {
                for mention in mentions {
                    let mentionNSRange = mention.nsrange
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemPink, range: mentionNSRange)
                }
            }
            if !hashtags.isEmpty {
                for hashtag in hashtags {
                    let hashtagNSRange = hashtag.nsrange
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemIndigo, range: hashtagNSRange)
                }
            }
            if !urls.isEmpty {
                for url in urls {
                    let urlNSRange = url.nsrange
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: urlNSRange)
                }
            }
            tweetContent.attributedText = attributedString
        }
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
