//
//  ViewController.swift
//  scheduleonce-test
//
//  Created by Manuel Thurner on 31.07.19.
//  Copyright © 2019 Manuel Thurner. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coachName = "manuel_en-US".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let firstName = "Manu".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let email = "manuel@kaia-health.com".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let html = """
        <html>
        <head>
        <title></title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        body, html, iframe { width: 100%; height: 100%; margin: 0; padding: 0; }
        iframe { border: 0; }
        </style>
        </head>
        <body>
        <iframe src="https://go.oncehub.com/\(coachName)?brdr=1pxd8d8d8&amp;dt=&amp;em=1&amp;Si=1&amp;m=true&amp;name=\(firstName)&amp;email=\(email)" width="100%" height="100%"></iframe>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // Check if the web view redirects to kaiahealth.com, then we know that the booking has been completed
    // This can be achieved in a similar way on Android with shouldOverrideUrlLoading: https://stackoverflow.com/questions/32871641/android-how-to-retrieve-redirect-url-from-a-webview/42433654
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url!
        
        if url.host != nil && url.host!.hasPrefix("www.kaiahealth.com") {
            // retrieve information, e.g. meetingTime from the query parameters
            var meetingTime = "unknown"
            if url.query != nil {
                let arr = url.query!.components(separatedBy:"&")
                var data = [String:String]()
                for row in arr {
                    let pairs = row.components(separatedBy:"=")
                    data[pairs[0]] = pairs[1]
                }
                meetingTime = data["meetingTime"]!.removingPercentEncoding!
            }
            
            
            let alert = UIAlertController(title: "Booking completed", message: "Meeting time: \(meetingTime)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        print(url)
        decisionHandler(.allow)
    }
}

