//
//  LibraryViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 03/05/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ModalViewControllerDelegate {
    
    var category = Categories.animals
    var fromGameType = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    var objects: [String] = []
    var pressedObject = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objects = Constants.getFilteredObjects(category: category)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if (fromGameType) {
            self.performSegue(withIdentifier: "showGametype", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "showScan", sender: self)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCollectionViewCell
        
        cell.imageView.image = UIImage(named: objects[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressedObject = objects[indexPath.row]
        self.overlayBlurredBackgroundView(style: .dark)
        self.performSegue(withIdentifier: "showInfo", sender: self)
    }
    
    func removeBlurredBackgroundView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func continueProcess(from: String?) {
        //
    }
    
    func overlayBlurredBackgroundView(style: UIBlurEffectStyle) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: style)
        
        view.addSubview(blurredBackgroundView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showInfo" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.pressedObject
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.mode = HelpMode.help
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showScan" {
                if let viewController = segue.destination as? ScanViewController {
                    viewController.category = self.category
                }
            }            
        }      
    }
}
