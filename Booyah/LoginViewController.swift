//
//  LoginViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBAction func SignInButtonTouched(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            let alertController = UIAlertController(title: "Oops", message: "Invalid email or password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { void in
                self.emailTextField.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if user != nil && error == nil {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Oops", message: "Email or password error", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { void in
                    self.passwordTextField.becomeFirstResponder()
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func checkHasViewedTutorial() {
        let userDefault = UserDefaults.standard
        let hasViewedTutorial = userDefault.bool(forKey: "hasViewedTutoral")
        
//        Todo
//        uncomment these 3 lines when finished testing
//        if !hasViewedTutorial {
//            userDefault.set(true, forKey: "hasViewedTutoral")
            let tutorialViewController = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController")
            present(tutorialViewController, animated: true, completion: nil)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkHasViewedTutorial()
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
