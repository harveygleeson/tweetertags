//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Harvey on 16/11/2022.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {

    
    var tweets = [[TwitterTweet]]()
    { didSet {
        tableView.reloadData()
    } }
    
    var twitterQueryText: String? = "#ucd"
    { didSet {
        let defaults = UserDefaults.standard
        
        // Check if an array already exists
        if var existingDefaults = defaults.object(forKey: "tweeterTags.searchHistory") as? [String] {
            // If it does and length is greater than 100, remove last and update
            if existingDefaults.count > 100 {
                existingDefaults.removeLast()
                existingDefaults.insert(twitterQueryText!, at: 0)
            } else {
                print("existingDefaults is \(existingDefaults)")
                // Length is not 100 yet, just insert
                existingDefaults.insert(twitterQueryText!, at: 0)
                defaults.set(existingDefaults, forKey: "tweeterTags.searchHistory")
            }
        } else {
            // If array does not exist, create one and put query in
            var searchHistory = [String]()
            searchHistory.append(twitterQueryText!)
            defaults.set(searchHistory, forKey: "tweeterTags.searchHistory")
        }
        print("1. \(self.tweets.description)")
        tweets.removeAll()
        print("2. \(self.tweets.description)")
        twitterQueryTextField.text = twitterQueryText
        refresh()
        print("3. \(self.tweets.description)")
    } }
    
    @IBOutlet weak var twitterQueryTextField: UITextField!
    
    private func refresh() {
        if let twitterQueryText = twitterQueryText {
            let twitterRequest = TwitterRequest(search: twitterQueryText, count: 5)
            twitterRequest.fetchTweets { (tweets) -> Void in
                DispatchQueue.main.async { () -> Void in
                    self.tweets.append(tweets)
                }
            }
         }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        twitterQueryText = textField.text
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twitterQueryTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
//        let defaults = UserDefaults.standard
//        if let existingDefaults = defaults.object(forKey: "tweeterTags.searchHistory") as? [String] {
//            let mostRecentSearch = existingDefaults.first
//            twitterQueryText = mostRecentSearch
//        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTVCell
        cell.tweet = tweet
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        switch StoryboardIdentifiers(segue)! {
        case .mentionsTVCSegue:
            if let mentionsTVC = destinationVC as? MentionsTVC {
                if let index = self.tableView.indexPathForSelectedRow {
                    mentionsTVC.tweet = tweets[index.section][index.row]
                }
            }
        // Never reached due to shouldPerformSegue conditions
        default:
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch StoryboardIdentifiers(rawValue: identifier)! {
        case .mentionsTVCSegue:
            return true
        default:
            return false
        }
    }
}

