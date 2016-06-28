//
//  UpdateIQViewController.swift
//  MovieIQ
//
//  Created by Debaprio Banik on 6/28/16.
//  Copyright © 2016 Debaprio Banik. All rights reserved.
//

import UIKit

class UpdateIQViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var actorListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true;
    }
    
    
}

