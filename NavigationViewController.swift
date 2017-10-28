//
//  NavigationViewController.swift
//  imagepicker
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor(red:0.18, green:0.11, blue:0.56, alpha:1.0)
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 28, weight: UIFontWeightHeavy)]
        navigationBar.barStyle = UIBarStyle.black
        navigationBar.tintColor = UIColor.white;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
