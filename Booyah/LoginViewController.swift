//
//  LoginViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    @IBAction func SignInButtonTouched(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
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
