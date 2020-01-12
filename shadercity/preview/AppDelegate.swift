//
//  AppDelegate.swift
//  preview
//
//  Created by Alex Linkov on 1/11/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let configureSheet = ConfigureSheet.sharedInstance
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let screenSaverView = window.contentView as? MainView
          else { fatalError("could not cast window's contentView as a MainView") }
        guard let screen = NSScreen.main
          else { fatalError("could not retrive main screen") }

        window.setFrame(screen.frame, display: true)
        window.delegate = self
        let timer = Timer.scheduledTimer(timeInterval: screenSaverView.animationTimeInterval,
                                         target: screenSaverView,
                                         selector: #selector(screenSaverView.animateOneFrame),
                                         userInfo: nil,
                                         repeats: true)
        timer.fire()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func didOpenPrefs(_ sender: Any) {
        window.beginSheet(configureSheet.window, completionHandler: nil)
    }
    
}

extension AppDelegate: NSWindowDelegate {
  func windowDidResize(_ notification: Notification) {
    guard let screenSaverView = window.contentView as? MainView
      else { fatalError("could not cast window's contentView as a MainView") }
  }
}
