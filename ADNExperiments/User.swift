//
//  User.swift
//  ADNExperiments
//
//  Created by dasdom on 24.05.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation

struct User : Printable {
  let username: String
  let name: String
  let avatarURLString: String
  let followers: Int
  let following: Int
  
  var description: String {
    return "@\(username), \(name), \(followers), \(following)"
  }
  
//  init(username: String, name: String, avatarURLString: String, followers: Int, following: Int) {
//    self.username = username
//    self.name = name
//    self.avatarURLString = avatarURLString
//    self.followers = followers
//    self.following = following
//  }
}