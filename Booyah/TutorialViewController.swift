//
//  TutorialViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 11/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var tutorialPageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tutorialPageControl.currentPage = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            tutorialPageViewController.pageScrollDelegate = self
        }
    }
    

}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    func pageDidScrollTo(pageIndex: Int) {
        self.tutorialPageControl.currentPage = pageIndex
    }
    func numberOfPages(numberOfPages: Int) {
        self.tutorialPageControl.numberOfPages = numberOfPages
    }
}
