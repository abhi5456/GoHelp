// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import SwiftyJSON


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    var apiRequest: NewsApiHandler? = nil
    
    
    var googleAPIKey = "AIzaSyBoiOHKlzYk_yQqCGkaEFDDoQCt49A3jAg"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var takeImageButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBAction func selectImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.isHidden = true
        spinner.hidesWhenStopped = true
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(spinner.isHidden == true){
            takeImageButton.isHidden = false
            selectImageButton.isHidden = false
        }
        self.reloadInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destinationViewController = segue.destination as? ArticleTableViewController {
            destinationViewController.apiHandler = self.apiRequest
        }
    }
}



/// Image processing

extension ViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
//            self.spinner.stopAnimating()
//            self.labelResults.isHidden = false
//            self.webResults.isHidden = false
//            self.textResults.isHidden = false
//            self.faceResults.isHidden = false
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get face annotations
//                let faceAnnotations: JSON = responses["faceAnnotations"]
//                if faceAnnotations != JSON.null {
//                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
//
//                    let numPeopleDetected:Int = faceAnnotations.count
//
//                    self.faceResults.text = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
//
//                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
//                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
//
//                    for index in 0..<numPeopleDetected {
//                        let personData:JSON = faceAnnotations[index]
//
//                        // Sum all the detected emotions
//                        for emotion in emotions {
//                            let lookup = emotion + "Likelihood"
//                            let result:String = personData[lookup].stringValue
//                            emotionTotals[emotion]! += emotionLikelihoods[result]!
//                        }
//                    }
//                    // Get emotion likelihood as a % and display in UI
//                    for (emotion, total) in emotionTotals {
//                        let likelihood:Double = total / Double(numPeopleDetected)
//                        let percent: Int = Int(round(likelihood * 100))
//                        self.faceResults.text! += "\(emotion): \(percent)%\n"
//                    }
//                } else {
//                    self.faceResults.text = "No faces found"
//                }
                
                 //Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                } else {
                    print("No labels found")
                }

                
                // Get Web annotations
                let webDetection: JSON = responses["webDetection"]
                let webEntities: JSON = webDetection["webEntities"]
                let numEntities: Int = webDetection.count
                var entities: Array<String> = []
                if numEntities > 0 {
                    var webResultsText:String = "Web Results found: "
                    for index in 0..<numEntities {
                        let entity = webEntities[index]["description"].stringValue
                        entities.append(entity)
                    }
                    for entity in entities {
                        // if it's not the last item add a comma
                        if entities[entities.count - 1] != entity {
                            webResultsText += "\(entity), "
                        } else {
                            webResultsText += "\(entity)"
                        }
                    }
                } else {
                    print("No Web results found")
                }
                
                
                // Get text detection
                let textAnnotations: JSON = responses["textAnnotations"]
                let numText: Int = textAnnotations.count
                var words: Array<String> = []
                if numText > 0 {
                    var textResultsText:String = "Text found: "
                    for index in 0..<numText {
                        let text = textAnnotations[index]["description"].stringValue
                        words.append(text)
                    }
                    for text in words {
                        // if it's not the last item add a comma
                        if words[words.count - 1] != text {
                            textResultsText += "\(text), "
                        } else {
                            textResultsText += "\(text)"
                        }
                    }
                } else {
                    print("No text found")
                }
                
                
                //MARK: Assembly News Query
                if(numText > 0){
                    var query = entities[0]  
                    query.append("%20OR%20")
                    query.append(words[1])
                    //query.append((words[1] + "%20AND%20" + words[2] + "%20AND%20" + words[3]))
                    //query.append("\"\(words[0])\"")

                    let finalQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                    
                    print("QUERY: query")
                    
                    self.apiRequest = NewsApiHandler(query:finalQuery!)!
                }
                else{
                    let query = entities[0]
                    let finalQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                    
                    self.apiRequest = NewsApiHandler(query:finalQuery!)!
                }
                
                self.apiRequest?.newsRequest(completion: self.retriveNewsResults)
            }
        })
        
    }
    
    
    func retriveNewsResults(){
        DispatchQueue.main.async(execute: {
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "tableViewSegue", sender: Any.self)
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .scaleAspectFit
            //imageView.image = pickedImage
            //imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage

            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
        }
        
        takeImageButton.isHidden = true
        selectImageButton.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension ViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 5
                    ],
//                    [
//                        "type": "FACE_DETECTION",
//                        "maxResults": 5
//                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 5
                    ],
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 5
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
    
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
