//
//  ViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {

    // associate storyboard components
    @IBOutlet weak var selection: customSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
   
    // variable for VC
    var emailValue: String?
    var passwordValue : String?
    var confirmpasswordValue : String?

    // variable for Firebase
    
    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hiding textField
        nameTextField.isHidden = true
        confirmpasswordTextField.isHidden = true
        
    }

    
    @IBAction func selectionButton(_ sender: Any) {
        // LOGIN Selected
        if selection.selectedSegmentIndex == 0
        {
       nameTextField.isHidden = true
    confirmpasswordTextField.isHidden = true
            
          
        
        }
            
            // REGISTER Selected
        else{
            nameTextField.isHidden = false
            confirmpasswordTextField.isHidden = false
            
            

            
        }
    }
    
// action on pressing submit
    @IBAction func submitButton(_ sender: Any) {

        // FOR REGISTER SCENARIO
        emailValue = emailTextField.text!
        passwordValue = passwordTextField.text!
        confirmpasswordValue = confirmpasswordTextField.text!
        print("value: " + passwordValue! + " " + confirmpasswordValue!)

        if selection.selectedSegmentIndex == 1{
            if passwordValue == confirmpasswordValue{
                
                var randomID = self.ref?.childByAutoId().key
                
                Auth.auth().createUser(withEmail: emailValue!, password: passwordValue!) { (user, error) in
                    if user != nil{
                        self.ref = Database.database().reference()
                        self.ref?.child(randomID!).child("Name").setValue(self.nameTextField.text!)
                        self.ref?.child(randomID!).child("Email").setValue(self.emailValue)
                        print("SUCCESSFUL")

                    }
                   
                }
            }
            
            else{
            print("Password doesnot match")
            }
       
        }
            
            // FOR LOGIN SCENARIO
        else{
        Auth.auth().signIn(withEmail: emailValue!, password: passwordValue!, completion: { (user, error) in
            if user != nil{
            print("Sign IN Success")
            
            }
           
        })
        }
    }

}

 
