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
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let sectionIndex = indexPath.section
//        if sections[sectionIndex].name == "Urls" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "mentionsContent", for: indexPath) as! MentionsTVCell
//            if let text = cell.mentionText.text {
//                UIApplication.shared.open(URL(string: text)!)
//            }
//        }
//    }
    
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionIndex = indexPath.section
        if sections[sectionIndex].name == "Images" { return 200 }
        else { return 45 }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tweetsSegue") {
            if let tweetsTVC = segue.destination as? TweetsTVC {
                let indexPath = tableView.indexPathForSelectedRow!
                if let cell = tableView.cellForRow(at: indexPath) as? MentionsTVCell {
                    if let cellText = cell.mentionText.text {
                            tweetsTVC.twitterQueryText = cellText
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "tweetsSegue" {
            let indexPath = tableView.indexPathForSelectedRow!
            let sectionIndex = indexPath.section
            if sections[sectionIndex].name == "Urls" {
                let cell = tableView.cellForRow(at: indexPath) as! MentionsTVCell
                let cellText = cell.mentionText.text!
                UIApplication.shared.open(URL(string: cellText)!)
                return false
            }
            return true
        }
        return false
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
