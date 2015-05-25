//
//  Post.swift
//  ADNExperiments
//
//  Created by dasdom on 24.05.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation

struct Post : Printable {
  let id: Int
  let threadId: Int
  let text: NSAttributedString
  let date: NSDate
  let numReplies: Int
  let numReposts: Int
  let numStars: Int
  let user: User
  let links: [Link]?
  let mentions: [Mention]?
  let hashtags: [Hashtag]?
  
  var description: String {
    return "@\(user.username)\n\(text), \n\(id), \(threadId), \(date), \(numReplies), \(numReposts), \(numStars), \(user)"
  }
  
//  init(id: Int, threadId: Int, text: String, date: NSDate, numReplies: Int, numReposts: Int, numStars: Int, user: User) {
//    self.id = id
//    self.threadId = threadId
//    self.text = text
//    self.date = date
//    self.numReplies = numReplies
//    self.numReposts = numReposts
//    self.numStars = numStars
//    self.user = user
//  }
  
}

struct Link {
  let pos: Int
  let len: Int
  let text: String
  let urlString: String
}

struct Mention {
  let pos: Int
  let len: Int
  let id: Int
  let name: String
  let isLeading: Bool?
}

struct Hashtag {
  let pos: Int
  let len: Int
  let name: String
}
