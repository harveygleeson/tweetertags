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
        print(tweets)
        tableView.reloadData()
    }}
    
    var twitterQueryText: String? = "#ucd"
    { didSet {
        tweets.removeAll()
        twitterQueryTextField.text = self.twitterQueryText
        refresh()
    } }
    
    @IBOutlet weak var twitterQueryTextField: UITextField!
    
    private func refresh() {
        if let twitterQueryText = twitterQueryText {
            let twitterRequest = TwitterRequest(search: twitterQueryText, count: 5)
            twitterRequest.fetchTweets { (tweets) -> Void in
                DispatchQueue.main.async { () -> Void in
                    self.tweets.append(tweets)
                    self.tableView.reloadData()
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
        self.twitterQueryTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refresh()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetTVCell
        cell.tweet = tweet
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mentionsSegue") {
            if let mentionsTVC = segue.destination as? MentionsTVC {
                if let index = self.tableView.indexPathForSelectedRow {
                    mentionsTVC.tweet = tweets[index.section][index.row]
                }
            }
        }
    }
}

