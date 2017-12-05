//
//  ViewController.swift
//  FBSigninDemo
//
//  Created by APPLE MAC MINI on 05/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblEmail: UILabel!
    
    
    @IBOutlet weak var lblAccessToken: UITextView!
    
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //This code is for entering credentials again and again when click on login with facebook...by this we can also sign in using different account...
        
        //fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
       
    }

    @IBAction func LoginFB(_ sender: UIButton) {
        
        
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                print(result)
                
                
                
                // if user cancel the login
                if (result?.isCancelled)!{
                    
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")){
                    if((FBSDKAccessToken.current()) != nil){
                        
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                //everything works print the user data
                               
                                let info = result as! [String : AnyObject]
                                print(info["name"] as! String)
                                print(info)
                                print(FBSDKAccessToken.current().tokenString)
                                
                                self.lblName.text = info["name"] as? String
                                self.lblEmail.text = (info["email"] as? String)
                                self.lblAccessToken.text = FBSDKAccessToken.current().tokenString
                                
                                let urlString = ((info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                                
                                let url = NSURL(string: urlString!)
                                
                                let imgData = NSData(contentsOf: url! as URL)
                                
                                self.profilePic.image = UIImage(data: imgData! as Data)
                                
                                
                            }
                        })
                        
                    }
                }
            }
            }
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton) {
        
        profilePic.image = nil
        profilePic.backgroundColor = UIColor.gray
        
        lblAccessToken.text = "Name : Please Login First"
        lblEmail.text = "Email : Please Login First"
        lblName.text = "Access Token : Please Login First"
        
        
        fbLoginManager.logOut()
        
        print("Logout")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

