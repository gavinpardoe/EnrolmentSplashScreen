/*
  AppDelegate.swift
  enrolmentSplashScreen

  Created by Gavin on 22/03/2016.

 Designed for Use with JAMF Casper Suite.
 
 The MIT License (MIT)
 
 Copyright (c) 2016 Gavin Pardoe
 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var appWindowController: AppWindowController?

    var policytimer = NSTimer()
    let receiptPath = NSFileManager.defaultManager()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let appWindowController = AppWindowController()
        appWindowController.showWindow(self)
        self.appWindowController = appWindowController
        
        //receiptCheck() // Only Functions if App is Run as Root/Admin
        policyCheckTimer()
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func receiptCheck() { //Disabled by Default
        
        do {
            try receiptPath.removeItemAtPath("/Library/Application Support/JAMF/enrolment.receipt")
        }
            
        catch let error as NSError {
            print( (error))
            
        }
    }
    
    func policyCheckTimer() {
        
        let timerInt = NSTimeInterval(10.0)
        policytimer = NSTimer.scheduledTimerWithTimeInterval(timerInt, target: self, selector: #selector(AppDelegate.policyCheck), userInfo: nil, repeats: true)
        policytimer.fire()
        
    }
    
    func policyCheck() {
        
        
        if receiptPath.fileExistsAtPath("/Library/Application Support/JAMF/enrolment.receipt") {
            
            //debugPrint("Receipt Found")
            self.policytimer.invalidate()
            appWindowController!.enrolmentComplete()
            
        } else {
            
            //debugPrint("Receipt Not Found")
        }
    }
    
}

