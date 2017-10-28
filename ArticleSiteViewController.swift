//
//  ArticleSiteViewController.swift
//  imagepicker
//


import UIKit
import WebKit
class ArticleSiteViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var siteWebView: WKWebView!
    var webUrl: String?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        siteWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        siteWebView.uiDelegate = self
        view = siteWebView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(webUrl!)
        loadURL(articleURL: webUrl!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURL(articleURL:String){
        let myURL = URL(string: articleURL)
        let myRequest = URLRequest(url: myURL!)
        siteWebView.load(myRequest)
    }
}
