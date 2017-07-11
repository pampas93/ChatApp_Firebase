//
//  LoginViewController.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/10/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    var uName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func SignInButton(_ sender: Any) {
        //Sign in button function
        
        if username.text != ""{
            
            Auth.auth().signInAnonymously() { (user, error) in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                self.uName = self.username.text!
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                
            }//end of Auth
 
        }//end of if
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSegue"{
            if let destination = segue.destination as? GroupsViewController{
                username.text?.removeAll()
                destination.username = uName
            }
        }
        
        
    }

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
