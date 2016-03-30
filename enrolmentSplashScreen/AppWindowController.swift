/*
  AppWindowController.swift
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
import WebKit

class AppWindowController: NSWindowController {
    
    // IB Outlets
    @IBOutlet weak var quitButtonDisable: NSButton!
    @IBOutlet weak var statusImage: NSImageView!
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var displayLog: NSTextField!
    @IBOutlet weak var runSelfService: NSButton!
    @IBOutlet weak var progWheel: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    
    var timer = NSTimer()
    
    override var windowNibName: String? {
        return "AppWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Set Window Dimensions & Level
        self.window!.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        let screenSize: NSRect = (NSScreen.mainScreen()?.frame)!
        let percent: CGFloat = 0.6
        let offset: CGFloat = (1.0-percent)/2.0
        self.window!.setFrame(NSMakeRect(screenSize.size.width*offset, screenSize.size.height*offset, screenSize.size.width*percent, screenSize.size.height*percent), display: true)
        self.window!.makeKeyAndOrderFront(nil)
       
        // Load HTML Content
        let htmlPage = NSBundle.mainBundle().URLForResource("index", withExtension: "html")
        webView.mainFrame.loadRequest(NSURLRequest(URL: htmlPage!))
        
        // On Load Values
        progWheel.displayedWhenStopped = false
        self.statusImage.image = NSImage(named: "macbookproBars.png")
        
        logTimer()
        

    }
    
    func logTimer() {
        
        runSelfService.state = NSOffState
        quitButtonDisable.enabled = false
        self.progWheel.startAnimation(self)
        
        let timerInt = NSTimeInterval(2.0)
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInt, target: self, selector: #selector(AppWindowController.updateDisplayLog), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    func updateDisplayLog() {
        
        displayLog.stringValue = showLog()
        
    }
    
    func showLog() ->String {
        
        let jamfLog = NSData(contentsOfFile: "/private/var/log/jamf.log")
        
        let logString = NSString(data: jamfLog!, encoding: NSUTF8StringEncoding)
        let theRange = logString?.rangeOfString("]:", options: NSStringCompareOptions.BackwardsSearch)
        let scanner = NSScanner(string: logString as! String)
        scanner.scanLocation = (theRange?.location)!
        
        let lineReturn = NSMutableCharacterSet.newlineCharacterSet()
        
        var logLine = NSString?()
        while scanner.scanUpToCharactersFromSet(lineReturn, intoString: &logLine),
        let _ = logLine
            
        {
            
        }
        
        let trimTimeStamp = logLine!.stringByReplacingOccurrencesOfString("]:", withString: "")
        let removedSlash =  trimTimeStamp.stringByReplacingOccurrencesOfString("\"", withString: "")
        let trimedWhiteSpace = removedSlash.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        return trimedWhiteSpace
        
    }
    
    func enrolmentComplete() {
        
        self.statusImage.image = NSImage(named: "macbookpro.png")
        quitButtonDisable.enabled = true
        self.progWheel.stopAnimation(self)
        statusLabel.stringValue = "Setup Completed"
        
    }
    
    @IBAction func quitButton(sender: AnyObject) {
        
        if runSelfService.state == NSOnState {
            NSWorkspace.sharedWorkspace().openURL(NSURL(fileURLWithPath: "/Applications/Self Service.app"))
        }
        
        NSApplication.sharedApplication().terminate(self)
    }
    
}
