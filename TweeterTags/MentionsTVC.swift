//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by Harvey on 21/11/2022.
//

import UIKit

struct Section {
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}

enum StoryboardIdentifiers: String {
    case tweetsTVCSegue = "tweetsTVCSegue"
    case imageVCSegue = "imageVCSegue"
    case mentionsTVCSegue = "mentionsTVCSegue"
    case historySegue = "historySegue"
    
    init?(_ segue: UIStoryboardSegue) {
        self.init(rawValue: segue.identifier!)
    }
}

class MentionsTVC: UITableViewController {
    var sections: [Section] = []
    var tweet: TwitterTweet? {
        didSet
        {
            self.title = tweet?.user.name
            print("Set tweet media to \(tweet?.media.description ?? "nothing")")
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let tweet = tweet {
            if tweet.media.count != 0 {
                sections.append(Section(name: "Images", count: tweet.media.count))
            }
            if tweet.urls.count != 0 {
                sections.append(Section(name: "Urls", count: tweet.urls.count))
            }
            if tweet.hashtags.count != 0 {
                sections.append(Section(name: "Hashtags", count: tweet.hashtags.count))
            }
            if tweet.userMentions.count != 0 {
                sections.append(Section(name: "UserMentions", count: tweet.userMentions.count))
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tweet = tweet {
            let sectionIndex = indexPath.section
            switch sections[sectionIndex].name {
            case "Images":
                let cell = tableView.dequeueReusableCell(withIdentifier: "images", for: indexPath) as! ImageTVCell
                let imageUrl = tweet.media[indexPath.row].url
                cell.tweetImage.load(url: imageUrl)
                return cell
            case "Urls":
                let cell = tableView.dequeueReusableCell(withIdentifier: "mentionsContent", for: indexPath) as! MentionsTVCell
                let url = tweet.urls[indexPath.row].keyword
                cell.mentionText.text = url
                return cell
            case "Hashtags":
                let cell = tableView.dequeueReusableCell(withIdentifier: "mentionsContent", for: indexPath) as! MentionsTVCell
                let hashtag = tweet.hashtags[indexPath.row].keyword
                cell.mentionText.text = hashtag
                return cell
            case "UserMentions":
                let cell = tableView.dequeueReusableCell(withIdentifier: "mentionsContent", for: indexPath) as! MentionsTVCell
                let userMention = tweet.userMentions[indexPath.row].keyword
                cell.mentionText.text = userMention
                return cell
            default:
                break
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionsContent", for: indexPath)
        cell.textLabel?.text = "No Data Available"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionIndex = indexPath.section
        if sections[sectionIndex].name == "Images" { return 200 }
        else { return 45 }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        switch StoryboardIdentifiers(segue)! {
        case .tweetsTVCSegue:
            if let tweetsTVC = destinationVC as? TweetsTVC {
                let indexPath = tableView.indexPathForSelectedRow!
                if let cell = tableView.cellForRow(at: indexPath) as? MentionsTVCell {
                    if let cellText = cell.mentionText.text {
                            tweetsTVC.twitterQueryText = cellText
                    }
                }
            }
        case .imageVCSegue:
            if let imageVC = destinationVC as? ImageVC {
                let indexPath = tableView.indexPathForSelectedRow!
                if let cell = tableView.cellForRow(at: indexPath) as? ImageTVCell {
                    imageVC.imageToDisplay = cell.tweetImage.image
                }
            }
        // Never reached due to shouldPerformSegue conditions
        default:
            break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch StoryboardIdentifiers(rawValue: identifier)! {
        case .tweetsTVCSegue:
            let indexPath = tableView.indexPathForSelectedRow!
            let sectionIndex = indexPath.section
            if sections[sectionIndex].name == "Urls" {
                let cell = tableView.cellForRow(at: indexPath) as! MentionsTVCell
                let cellText = cell.mentionText.text!
                UIApplication.shared.open(URL(string: cellText)!)
                return false
            } else {
                // In the case of mention or hashtag
                return true
            }
        case .imageVCSegue:
            return true
        case .mentionsTVCSegue:
            return false
        case .historySegue:
            return false
        }
    }
}
