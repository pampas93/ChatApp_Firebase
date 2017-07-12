//
//  RegsiterLoginViewController.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/11/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import UIKit
import Firebase

class RegsiterLoginViewController: UIViewController {

    @IBOutlet weak var loginMailID: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        
        if loginMailID.text != "" && loginPassword.text != ""{
            
            Auth.auth().signIn(withEmail: loginMailID.text!, password: loginPassword.text!) { (user, error) in
                
                if error == nil{
                    print("User signed in")
                    self.performSegue(withIdentifier: "AuthSegue", sender: nil)
                }
            }
        }
        
    }
   
    @IBAction func registerButton(_ sender: Any) {
        
        if name.text != "" && emailID.text != "" && password.text != ""{
            
            Auth.auth().createUser(withEmail: emailID.text!, password: password.text!) { (user, error) in
                
                if error == nil{
                    print("User successfully registered and signed in")
                    self.performSegue(withIdentifier: "AuthSegue", sender: nil)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AuthSegue"{
            if let destination = segue.destination as? GroupsViewController{
                destination.username = "Some Name"
            }
        }
        
        
    }
    
    
    

}
