//
//  ViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // associate storyboard components
    @IBOutlet weak var selection: customSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hiding textField
        nameTextField.isHidden = true
        confirmpasswordTextField.isHidden = true
        
    }

    @IBOutlet weak var selectionButton: customSegmentedControl!
    
    @IBAction func selectionButton(_ sender: Any) {
        if selection.selectedSegmentIndex == 0
        {
       nameTextField.isHidden = true
    confirmpasswordTextField.isHidden = true
        
        }
        else{
            nameTextField.isHidden = false
            confirmpasswordTextField.isHidden = false
        }
    }
    
// action on pressing submit
    @IBAction func submitButton(_ sender: Any) {
    }

}

 
