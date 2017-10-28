//
//  File.swift
//  imagepicker
//

import SwiftyJSON

struct Article{
    let articleType: String?
    let webUrl: String?
    let pubDate: String?
    let webTitle: String?
}

class NewsApiHandler{
   
    var queryString: String = ""
    
    init?(query:String){
        self.queryString = query
    }
    
    var queryResults = [Article]()

    let session = URLSession.shared
    
    
    let guardianApiKey = "18500067-8626-4475-944c-b53c1bf3ff5e"
    var guardianURL: URL {
        return URL(string:"https://content.guardianapis.com/search?api-key=\(guardianApiKey)&q=\(queryString)")!
    }
    
    func newsRequest(completion: @escaping ()->Void){
        // Create our request URL
        
        var request = URLRequest(url: guardianURL)
        request.httpMethod = "GET"
        
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                //self.analyzeResults(data)
                // Use SwiftyJSON to parse results
                let json = JSON(data: data)
                let errorObj: JSON = json["error"]
                
                
                // Check for errors
                if (errorObj.dictionaryValue != [:]) {
                    return
                } else {
                    // Parse the response
                    print(json)
                    
                    var articles = [Article]()
                    
                    let response: JSON = json["response"]
                    
                    if(response["status"] == "ok"){
                        let results: JSON = response["results"]
                        
                        for (_, data) in results{
                            articles.append(Article(articleType: data["sectionName"].string, webUrl: data["webUrl"].string, pubDate: data["webPublicationDate"].string, webTitle: data["webTitle"].string))
                        }
                        
                        self.queryResults = articles
                        completion()
                    }
                }
            }
            task.resume()
        }
    }
}
