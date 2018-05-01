//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Maribel Montejano on 4/30/18.
//  Copyright © 2018 Maribel Montejano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
        // create base URL
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        
        // create dictionary with key/value pairs for query
        let queryDictionary: [String: String] = [
            "term": "Johnny Cash",
            "media": "music",
            "limit": "10",
            "lang": "en_us"
        ]
        
        let extensionQuery = baseURL.withQueries(queryDictionary)!
        print("extensionQuery: \(extensionQuery)")
        
        let task = URLSession.shared.dataTask(with: extensionQuery) { (data, response, error) in
            print("in completion handler")
            let jsonDecoder = JSONDecoder()
            if let error = error {
                print(error)
                return
            }
            
            if let data = data,
                let results = try? jsonDecoder.decode(Results.self, from: data) {
                print(results)
            }
        }
        task.resume()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url
    }
}
