//
//  TutorialViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 10/05/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var mode = GameMode.scan    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var pages: [UIViewController] = {
        if mode == GameMode.scan {
            return [
                self.getViewController(withIdentifier: "scanTutorial1"),
                self.getViewController(withIdentifier: "scanTutorial2"),
                self.getViewController(withIdentifier: "scanTutorial3"),
                self.getViewController(withIdentifier: "scanTutorial4"),
                self.getViewController(withIdentifier: "tutorialFinish")
            ]
        }
        return []
    }()
    
    func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard pages.count > previousIndex else { return nil }
        
        self.currentIndex = previousIndex
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        self.currentIndex = nextIndex
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
         return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}
