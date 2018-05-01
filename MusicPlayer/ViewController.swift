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
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    // MARK: - Properties
    var artist: String = ""
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
    }

    @IBAction func PlayButtonPressed(_ sender: UIButton) {
        if searchTextField.text != nil {
            artist = searchTextField.text!
        }
        querySong()
    }
    
    // MARK: - TextField Delegate Method (Optional)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helper Methods
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
            var trackNameString: String
            var artistNameString: String
            var artworkUrl: String
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data,
                let results = try? jsonDecoder.decode(Results.self, from: data) {
                print("results \(results)")
                
                trackNameString = results.results[0].artistName
                artistNameString = results.results[0].trackName
                artworkUrl = results.results[0].artworkUrl60
                
                print("artworkUrl: \(artworkUrl)")
                self.queryArtwork(url: artworkUrl)
                self.updateLabels(trackName: trackNameString, artistName: artistNameString)
            }
        }
        task.resume()
    }
    
    func queryArtwork(url: String) {
        let searchUrl = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: searchUrl) { (data, response, error) in
            print("in queryArtwork completion handler")
            
            var displayImage: UIImage?
            
            if error != nil {
                print("Error in queryArtwork \(error!)")
            }
            
            if let imageData = data {
                displayImage = UIImage(data: imageData)
            }
            
            DispatchQueue.main.async {
                self.artworkImage.image = displayImage
            }
        }
        task.resume()
    }
    
    func updateLabels(trackName: String, artistName: String) {
        DispatchQueue.main.async {
            self.trackNameLabel.text = trackName
            self.artistNameLabel.text = artistName
        }
    }
}

// MARK: - Extension
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url
    }
}
