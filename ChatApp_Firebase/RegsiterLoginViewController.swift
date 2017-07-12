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
    
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
    var formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child("Users")
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier:"GMT")
        
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
                    self.addIntoDatabase()
                    self.performSegue(withIdentifier: "AuthSegue", sender: nil)
                }
            }
        }
        
    }
    
    func addIntoDatabase(){
        
        let currentDT = Date()
        let dStr = formatter.string(from: currentDT)
        
        let newRef = ref.childByAutoId()
        let newUser = [
            "Name" : name.text!,
            "EmailId" : emailID.text!,
            "LastMessageSeen" : dStr
            ] as [String : Any]
        
        newRef.setValue(newUser)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AuthSegue"{
            if let destination = segue.destination as? GroupsViewController{
                
                if emailID.text != ""{                      //User registered
                    destination.mailid = emailID.text!
                }
                else{                                       //User Signed in
                    destination.mailid = loginMailID.text!
                }
                
                
            }
        }
        
        
    }
    
    
    

}
