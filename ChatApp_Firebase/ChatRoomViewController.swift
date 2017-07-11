//
//  ChatRoomViewController.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/11/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController {
    
    var groupName : String = "Blah"
    var username : String = ""
    
    @IBOutlet weak var grouptitle: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.senderId = Auth.auth().currentUser?.uid
        //OR self.senderId = username
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(groupName)
        grouptitle.title = groupName


        // Do any additional setup after loading the view.
    }
    

   
}
