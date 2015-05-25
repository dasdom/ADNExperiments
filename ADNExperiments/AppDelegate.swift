//
//  AppDelegate.swift
//  ADNExperiments
//
//  Created by dasdom on 24.05.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var mainWindowController: MainWindowController?
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    
    let mainWindowController = MainWindowController()
    mainWindowController.showWindow(self)
    self.mainWindowController = mainWindowController
  }
  
}

