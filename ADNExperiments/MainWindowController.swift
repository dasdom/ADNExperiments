//
//  MainWindowController.swift
//  ADNExperiments
//
//  Created by dasdom on 24.05.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  var posts: [Post] = []
  @IBOutlet weak var tableView: NSTableView!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()

    let urlString = "https://api.app.net/" + "posts/stream/global"
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    let urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    urlRequest.HTTPMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let sessionTask = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> () in
      
      let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
      
      var jsonError: NSError? = nil
      let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
      //    println("dictionary: \(dictionary)")
      let data = dictionary["data"] as! [AnyObject]
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy_MM_dd'T'HH_mm_ss'Z'"
      //    println("data: \(data)")
      
      var postsToAdd = [Post]()
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        for post in data {
          //                    println("post: \(post)")
          if let text = post["text"] as? String,
            id = (post["id"] as? String)?.toInt(),
            threadId = (post["thread_id"] as? String)?.toInt(),
            dateString = post["created_at"] as? String,
            numReplies = post["num_replies"] as? Int,
            numReposts = post["num_reposts"] as? Int,
            numStars = post["num_stars"] as? Int,
            rawUser = post["user"] as? [String:AnyObject] {
              
              if let username = rawUser["username"] as? String,
                name = rawUser["name"] as? String,
                avatar = rawUser["avatar_image"] as? [String:AnyObject],
                avatarURLString = avatar["url"] as? String,
                counts = rawUser["counts"] as? [String:Int],
                followers = counts["followers"],
                following = counts["following"] {
                  
                  let user = User(username: username, name: name, avatarURLString: avatarURLString, followers: followers, following: following)
                  if let date = dateFormatter.dateFromString(dateString) {
                    
                    let attributedString = NSMutableAttributedString(string: text)

                    let entities = post["entities"] as? [String:AnyObject]
                   
                    var links = [Link]()
                    if let rawLinks = entities?["links"] as? [[String:AnyObject]] {
                      for rawLink in rawLinks {
                        if let pos = rawLink["pos"] as? Int,
                          len = rawLink["len"] as? Int,
                          text = rawLink["text"] as? String,
                          urlString = rawLink["url"] as? String {
                            let link = Link(pos: pos, len: len, text: text, urlString: urlString)
                            links.append(link)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.greenColor(), range: NSRange(location: pos, length: len))
                        }
                      }
                    }
                    
                    var mentions = [Mention]()
                    if let rawMentions = entities?["mentions"] as? [[String:AnyObject]] {
                      for rawMention in rawMentions {
                        println("rawMention: \(rawMention)")
                        if let pos = rawMention["pos"] as? Int,
                          len = rawMention["len"] as? Int,
                          id = (rawMention["id"] as? String)?.toInt(),
                          name = rawMention["name"] as? String {
                            println("within if")
                            let isLeading = rawMention["is_leading"] as? Bool
                            let mention = Mention(pos: pos, len: len, id: id, name: name, isLeading: isLeading)
                            mentions.append(mention)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSRange(location: pos, length: len))
                        }
                      }
                    }
                    
                    var hashtags = [Hashtag]()
                    if let rawHashtags = entities?["hashtags"] as? [[String:AnyObject]] {
                      for rawHashtag in rawHashtags {
                        println("rawMention: \(rawHashtag)")
                        if let pos = rawHashtag["pos"] as? Int,
                          len = rawHashtag["len"] as? Int,
                          name = rawHashtag["name"] as? String {
                            println("within if")
                            let hashtag = Hashtag(pos: pos, len: len, name: name)
                            hashtags.append(hashtag)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.blueColor(), range: NSRange(location: pos, length: len))
                        }
                      }
                    }
                    
                    let post = Post(id: id, threadId: threadId, text: attributedString, date: date, numReplies: numReplies, numReposts: numReposts, numStars: numStars, user: user, links: links, mentions: mentions, hashtags: hashtags)
                    //            println("\(dateString)")
//                    println("*** \(post) **********")
                    //            println("\(text)\n\n")
                    postsToAdd.append(post)
                  }
              }
          }
        }
        self.posts = postsToAdd
        self.tableView.reloadData()
      })
    }
    sessionTask.resume()

  }
  
  
}

extension MainWindowController : NSTableViewDataSource {
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return posts.count
  }
}

extension MainWindowController : NSTableViewDelegate {
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
    let post = posts[row]
    
    let cellView = tableView .makeViewWithIdentifier("PostCell", owner: self) as! PostCellView
    cellView.usernameLabel.stringValue = post.user.username
    cellView.postLabel.attributedStringValue = post.text
    return cellView
  }
}

