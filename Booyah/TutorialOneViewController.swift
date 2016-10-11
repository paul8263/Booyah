//
//  TutorialOneViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 11/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class TutorialOneViewController: UIViewController {
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelOne.alpha = 0
        self.labelTwo.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Animate only once when view appears
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startAnimation()
    }
    
//    Animate every time when view appears
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startAnimation()
//    }
    
    func startAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseInOut, animations: { 
            self.labelOne.alpha = 1.0
            }, completion: { (completed) in
                if completed {
                    self.labelTwo.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                    UIView.animate(withDuration: 1.0, animations: {
                        self.labelTwo.transform = CGAffineTransform.identity
                        self.labelTwo.alpha = 1.0
                    }, completion: nil)
                }
        })
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
