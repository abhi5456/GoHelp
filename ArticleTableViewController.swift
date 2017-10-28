//
//  ArticleTableViewController.swift
//  imagepicker
//

import UIKit

class ArticleTableViewController: UITableViewController {

    var apiHandler: NewsApiHandler?
    var article = [Article]()
    var urlToPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        article = (apiHandler?.queryResults)!
        tableView.reloadData()
        print("RELOAD TABLE DATA")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        
        //image selector
        cell.titleLabel.text = article[indexPath.row].webTitle
        cell.categoryLabel.text = article[indexPath.row].articleType
        var picture: String
        switch (article[indexPath.row].articleType)! {
        case "Art and design", "Music", "Film": picture = "Art"
        case "Life and style": picture = "Life"
        case "Science", "Technology": picture = "Science"
        case "Sport": picture = "Sports"
        case "US news": picture = "USA"
        case "World", "News": picture = "World"
        case "Environment": picture = "Earth"
        case "Fashion": picture = "Fashion"
        case "Business", "Small network business": picture = "Business"
        case "Law", "Politics": picture = "Politics"
        case "Technology": picture = "Technology"
        default: picture = "AppIcon"
            
        }
        cell.imageLabel.image = UIImage(named: picture)
        cell.webUrl = article[indexPath.row].webUrl
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? ArticleSiteViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                destination.webUrl = article[row].webUrl
            }
        }
    }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        if let destination = subsequentVC as? ViewController {
//            print("we made it here")
//            destination.spinner.isHidden = true
//            destination.takeImageButton.isHidden = false
//            destination.selectImageButton.isHidden = false
//        }
//    }
}
