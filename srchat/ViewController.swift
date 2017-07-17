//
//  ViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    // associate storyboard components
    @IBOutlet weak var selection: customSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    @IBOutlet weak var notification: UILabel!
   
    // variable for VC
    
    var name: String?
    var email: String?
    var password : String?
    var confirmpassword : String?

    
    var FBref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // GOOGLE LOGIN STUFF
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "1096381658159-23gk0fjf4q6je5q9ud26e9hduu3chf7f.apps.googleusercontent.com"
        
        
        // hiding textField
        nameTextField.isHidden = true
        confirmpasswordTextField.isHidden = true
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(Auth.auth().currentUser)
        
        
        // TO PERFORM NEXT VC ACTION IF PREVIOUS SIGNED IN & USER HAS NOT LOGGED OUT 
        Auth.auth().addStateDidChangeListener { (authen, userDetail) in
           
            if userDetail != nil{
            print(userDetail)
                
                self.nextVC()
            }
            else{
            print("ACCESS DENIED")
            }
        }
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
        
        name = nameTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        confirmpassword = confirmpasswordTextField.text!

        
        
        /*
         
        ************************* FOR REGISTER SCENARIO *************************
         
         
         */
        
        
        

        

        

        if selection.selectedSegmentIndex == 1{
               let reguserInfo: chatRoom = chatRoom(nameValue: name!, emailValue: email!, passwordValue: password!, confirmpasswordValue: confirmpassword!)
            if password! == confirmpassword! {
                print("value: " + password! + " " + confirmpassword!)
                
// SAVE value in chatroom array
                chatRoom.userInfo = reguserInfo

// CALL EMAIL REGISTTER FUCNTION
                helper.Help.emailReg()
                nextVC()
                
            }
            
            else{
           notification.text = "Password doesnot match"
                
            }
       
        }
            

            
            
            /*
             
           *************************  FOR LOGIN SCENARIO *************************
        
        
             */
            
        else{
           
            let loginuserInfo: chatRoom = chatRoom(nameValue: "", emailValue: email!, passwordValue: password!, confirmpasswordValue: "")
            
            chatRoom.userInfo = loginuserInfo

            
          Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, err) in
            if err == nil{
            print(user?.uid)
                chatHelper.chathelp.userIdentity = (user?.uid)!
//                chatHelper.chathelp.userDisplayName = (user?.displayName)!
                self.nextVC()

            }
            else{
                print(err)
            self.notification.text = "ERROR"
            }
          })
            
                    }
}
    
// ----------------- ACTION ON GOOGLE BUTTON ----------------------------
    @IBAction func googleButton(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print (user.authentication)
        
        
        if helper.Help.loginInGoogle(userAuth: user.authentication) == true{
         nextVC()
        }
        
        else{
            return
        }
       
   
        

    }
    
    func nextVC(){
    
        performSegue(withIdentifier: "naviController", sender: self)
        
        

    }
    
}

 
