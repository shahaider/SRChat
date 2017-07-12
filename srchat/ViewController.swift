//
//  ViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    // associate storyboard components
    @IBOutlet weak var selection: customSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
   
    // variable for VC
    
    var name: String?
    var email: String?
    var password : String?
    var confirmpassword : String?

    
//    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // GOOGLE LOGIN STUFF
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().clientID = "1096381658159-23gk0fjf4q6je5q9ud26e9hduu3chf7f.apps.googleusercontent.com"
        
        
        // hiding textField
        nameTextField.isHidden = true
        confirmpasswordTextField.isHidden = true
        
    }

 
    
    
    
// ----------------- ACTION ON SEGMENT CONTROL BUTTON ----------------------------
    
    
    
    
    
    @IBAction func selectionButton(_ sender: Any) {
       
        
        /*
         
         ************************* LOGIN Selected *************************
         
         */
        
        if selection.selectedSegmentIndex == 0
        {
       nameTextField.isHidden = true
    confirmpasswordTextField.isHidden = true
   
        }
            
            
            
            
            /*
 
             ************************* REGISTER Selected *************************
             
             
             */
        else{
            nameTextField.isHidden = false
            confirmpasswordTextField.isHidden = false
        }
    }
    
    
    
    
    
    
    
// ----------------- ACTION ON SUBMIT BUTTON ----------------------------
   
    
    @IBAction func submitButton(_ sender: Any) {

        /* 
         
        ************************* FOR REGISTER SCENARIO *************************
         
         
         */
        
        
        
       name = nameTextField.text!
      email = emailTextField.text!
        password = passwordTextField.text!
        confirmpassword = confirmpasswordTextField.text!
        
        let userInfo: chatRoom = chatRoom(nameValue: name!, emailValue: email!, passwordValue: password!, confirmpasswordValue: confirmpassword!)
        

        if selection.selectedSegmentIndex == 1{
            if password! == confirmpassword! {
                print("value: " + password! + " " + confirmpassword!)
                
// SAVE value in chatroom array
                chatRoom.userInfo = userInfo

// CALL EMAIL REGISTTER FUCNTION
                helper.Help.emailReg()
                
            }
            
            else{
            print("Password doesnot match")
            }
       
        }
            

            
            
            /*
             
           *************************  FOR LOGIN SCENARIO *************************
        
        
             */
            
        else{
            
            helper.Help.login()
            
    }
}
    
// ----------------- ACTION ON GOOGLE BUTTON ----------------------------
    @IBAction func googleButton(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        helper.Help.loginInGoogle()
    }
    
    
}

 
