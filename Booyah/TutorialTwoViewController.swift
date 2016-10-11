//
//  TutorialTwoViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 11/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class TutorialTwoViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!

    @IBAction func startButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.startButton.transform = CGAffineTransform.identity
            }, completion: nil)
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
