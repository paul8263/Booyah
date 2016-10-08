//
//  SignInViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    let userBaseRef = FIRDatabase.database().reference(withPath: "users")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBAction func SignUpButtonTouched(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            let alertController = UIAlertController(title: "Oops", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { void in
                self.emailTextField.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            var isSuccess = false
            let alertController: UIAlertController!
            if user != nil && error == nil {
                alertController = UIAlertController(title: "Success", message: "Your account has been created", preferredStyle: .alert)
                isSuccess = true
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    self.saveUserInDatabase(user: user!)
                })
            } else {
                alertController = UIAlertController(title: "Error", message: "User account creation error", preferredStyle: .alert)
            }
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { void in                
                if isSuccess {
                    self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
                } else {
                    self.emailTextField.becomeFirstResponder()
                }
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    private func saveUserInDatabase(user: FIRUser) {
        let currentUserRef = userBaseRef.child(user.uid)
        let userDataDict: [String: Any] = [
            "email": user.email!,
            "chatgroups": [],
            "tasks": []
        ]
        currentUserRef.setValue(userDataDict)
    }

    @IBAction func backButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        backgroundImageView.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
