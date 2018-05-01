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
    @IBOutlet weak var artworkImage: UIImageView!
    
    // MARK: - Properties
    var artist: String = ""
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            artist = textField.text!
        }
        print("artist: \(artist)")
        querySong()
        textField.resignFirstResponder()
        return true
    }
    
    func querySong() {
        // create base URL
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        
        // create dictionary with key/value pairs for query
        let queryDictionary: [String: String] = [
            "term": artist,
            "media": "music",
            "limit": "1",
            "lang": "en_us"
        ]
        
        let extensionQuery = baseURL.withQueries(queryDictionary)!
        print("extensionQuery: \(extensionQuery)")
        
        let task = URLSession.shared.dataTask(with: extensionQuery) { (data, response, error) in
            print("in completion handler")
            let jsonDecoder = JSONDecoder()
            var artworkUrl: String
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data,
                let results = try? jsonDecoder.decode(Results.self, from: data) {
                print("results \(results)")
                artworkUrl = results.results[0].artworkUrl60
                
                print("artworkUrl: \(artworkUrl)")
            }
            
        }
        task.resume()
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url
    }
}
