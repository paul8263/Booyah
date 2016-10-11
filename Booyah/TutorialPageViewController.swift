//
//  TutorialViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

protocol TutorialPageViewControllerDelegate: class {
    func pageDidScrollTo(pageIndex: Int)
    func numberOfPages(numberOfPages: Int)
}

class TutorialPageViewController: UIPageViewController {
    
    var viewControllerList: [UIViewController] = []
    
    var pageScrollDelegate: TutorialPageViewControllerDelegate?
    
    func setUpControllers() {
        self.viewControllerList = [
            storyboard!.instantiateViewController(withIdentifier: "Tutorial1"),
            storyboard!.instantiateViewController(withIdentifier: "Tutorial2")
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        self.setUpControllers()
        self.pageScrollDelegate?.numberOfPages(numberOfPages: self.viewControllerList.count)
//        Change the color that displayed when swipe exceeds the index range
        self.view.backgroundColor = UIColor(red:0.93, green:0.67, blue:0.24, alpha:1.00)
        if let firstViewController = self.viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
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

extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllerList.index(of: viewController) else {
            return nil
        }
        let newIndex = currentIndex - 1
        if newIndex < 0 || newIndex >= self.viewControllerList.count {
            return nil
        } else {
            return self.viewControllerList[newIndex]
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllerList.index(of: viewController) else {
            return nil
        }
        let newIndex = currentIndex + 1
        if newIndex < 0 || newIndex >= self.viewControllerList.count {
            return nil
        } else {
            return self.viewControllerList[newIndex]
        }
    }
}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = self.viewControllers?.first {
            if let index = self.viewControllerList.index(of: currentViewController) {
                self.pageScrollDelegate?.pageDidScrollTo(pageIndex: index)
            }
        }
    }
}
