//
//  UpdateIQViewController.swift
//  MovieIQ
//
//  Created by Debaprio Banik on 6/28/16.
//  Copyright © 2016 Debaprio Banik. All rights reserved.
//

import UIKit
let getURLStr = "https://www.omdbapi.com/?t=%@&y=&plot=short&r=json"

class UpdateIQViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var actorListTableView: UITableView!
    
    // MARK: Properties
    var movieTitle: NSString?
    var actorList: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.titleTextField.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // MARK: TextField Delagate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = self.titleTextField.text {
            self.movieTitle = text.stringByReplacingOccurrencesOfString(" ", withString: "+");
            self.fetchMoviedetails();
        }
        self.titleTextField.text = "";
        self.titleTextField.resignFirstResponder();
        return true;
    }
    
    // MARK: Fetching
    func fetchMoviedetails() {
        let urlString = NSString(format: getURLStr, self.movieTitle!);
        let getURL = NSURL(string: urlString as String);
        
        var dataTask: NSURLSessionDataTask?
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        dataTask = NSURLSession.sharedSession().dataTaskWithURL(getURL!) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription);
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                }
            }
            else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if data != nil {
                        if let result = self.parseJSONData(data) {
                            self.fetchMoviePoster(result);
                        }
                    }
                }
            }
        }
        
        dataTask?.resume();
    }
    
    func fetchMoviePoster(dict: NSDictionary!) {
        var posterURLStr: NSString = (dict["Poster"] as? NSString)!;
        posterURLStr = posterURLStr.stringByReplacingOccurrencesOfString("http", withString: "https");
        let posterURL = NSURL(string: posterURLStr as String);
        
        var downloadTask: NSURLSessionDownloadTask?
        downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(posterURL!, completionHandler: { (location, response, error) in
            
            if let error = error {
                print(error.localizedDescription);
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                }
            }
            else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let posterData: NSData = NSData(contentsOfURL: location!)!;
                    let poster: UIImage = UIImage(data: posterData)!;
                    self.populateView(dict, img: poster);
                }
            }
        });
        
        downloadTask?.resume();
    }
    
    // MARK: Parsing
    func parseJSONData(data: NSData!) -> NSDictionary? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0));
            guard let result :NSDictionary = json as? NSDictionary else {
                print("Not a Dictionary")
                return nil;
            }
            
            return result;
        }
        catch let error as NSError {
            print("\(error)");
            return nil;
        }
    }
    
    // MARK: Populate UI
    func populateView(result: NSDictionary, img: UIImage) {
        dispatch_async(dispatch_get_main_queue()) {
            self.directorLabel.text = result["Director"] as? String;
            self.yearLabel.text = result["Year"] as? String;
            let actor :NSString = (result["Actors"] as? NSString)!;
            self.actorList = actor.componentsSeparatedByString(",");
            self.actorListTableView.reloadData();
            self.posterView.image = img;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        }
    }
    
    // MARK: TableView Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.actorList {
            return list.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Actor Cell", forIndexPath: indexPath);
        cell.textLabel?.text = self.actorList![indexPath.row] as? String;
        return cell;
    }
    
}

