//
//  GameTypeViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class GameTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var fullVersionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var chosenCategory = Categories.animals
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Music.instance.playMusic(name: MusicTypes.mainTheme)
        
        addGestures()
        
        if (UserDefaults.standard.bool(forKey: "trial")) {
            fullVersionButton.isHidden = false
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        scanButton.layer.cornerRadius = scanButton.frame.size.height / 10
        scanButton.layer.borderWidth = 3
        scanButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        
        searchButton.layer.cornerRadius = searchButton.frame.size.height / 10
        searchButton.layer.borderWidth = 3
        searchButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        
        readButton.layer.cornerRadius = readButton.frame.size.height / 10
        readButton.layer.borderWidth = 3
        readButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        
        libraryButton.layer.cornerRadius = readButton.frame.size.height / 10
        libraryButton.layer.borderWidth = 3
        libraryButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        
        fullVersionButton.layer.cornerRadius = fullVersionButton.frame.size.height / 2
        
        infoView.layer.cornerRadius = infoView.frame.size.height / 10
        infoView.layer.borderColor = UIColor.gray.cgColor
        infoView.layer.borderWidth = 4
    }
    
    override func viewDidLayoutSubviews() {
       modeOn()
    }
    
    func getButton() -> UIButton? {
        let mode = GameMode(rawValue: UserDefaults.standard.string(forKey: "gameType")!)!
        
        switch mode {
        case GameMode.read:
           return readButton
        case GameMode.scan:
            return scanButton
        case GameMode.search:
            return searchButton
        case GameMode.library:
            return libraryButton
        default:
            return nil
        }
    }
    
    func animateOn(button: UIButton) {
        UIView.animate(withDuration: 0.7, animations: {
            button.frame =  button.frame.insetBy(dx: -10, dy: -10)
        }){ (succeed) -> Void in
           //
        }
    }
    
    func animateOff(button: UIButton) {
        UIView.animate(withDuration: 0.7, animations: {            
            button.frame =  button.frame.insetBy(dx: 10, dy: 10)
        }){ (succeed) -> Void in
            //
        }
    }
    
    func modeOn() {
        if let button = getButton() {
            animateOn(button: button)
        }
    }
    
    func modeOff() {
        if let button = getButton() {
            animateOff(button: button)
        }
    }
    
    
    func changeGameMode(_ mode: GameMode) {
        modeOff()
        UserDefaults.standard.set(mode.rawValue, forKey: "gameType")
        modeOn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        changeGameMode(GameMode.library)
    }
    
    @IBAction func readButtonPressed(_ sender: UIButton) {
        changeGameMode(GameMode.read)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        changeGameMode(GameMode.search)
    }
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        changeGameMode(GameMode.scan)
    }
    
    @IBAction func fullVersionButtonPressed(_ sender: UIButton) {
        // Buying full version
        UserDefaults.standard.set(false, forKey: "trial")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! LibraryCollectionViewCell

        let category = Categories.getCategories()[indexPath.row]
        
        cell.imageView.image = UIImage(named: category.rawValue)
        cell.layer.borderWidth = 3
        cell.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        cell.layer.cornerRadius =  cell.frame.size.height / 10
        cell.label.text = NSLocalizedString(category.rawValue, comment: "")
        
        if (UserDefaults.standard.bool(forKey: "trial") && !Categories.getTrialCategories().contains(category)) {
            cell.alpha = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.getCategories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCategory = Categories.getCategories()[indexPath.row]
        
        if (UserDefaults.standard.bool(forKey: "trial") && !Categories.getTrialCategories().contains(chosenCategory)) {
            infoLabel.text = NSLocalizedString("fullVersion", comment: "")
            infoView.isHidden = false
            return
        }
        
        if (Constants.getFilteredObjects(category: chosenCategory).count < 1) {
            infoLabel.text = NSLocalizedString("activate", comment: "")
            infoView.isHidden = false            
            return
        }
        
        
        let mode = GameMode(rawValue: UserDefaults.standard.string(forKey: "gameType")!)!
        
        switch mode {
        case GameMode.read:
            self.performSegue(withIdentifier: "startRead", sender: self)
        case GameMode.scan:
            self.performSegue(withIdentifier: "startScan", sender: self)
        case GameMode.search:
            self.performSegue(withIdentifier: "startSearch", sender: self)
        case GameMode.library:
            self.performSegue(withIdentifier: "startLibrary", sender: self)
        default:
            return
        }
    }
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideInfoView))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideInfoView() {
        if (!infoView.isHidden) {
            infoView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            Music.instance.stop()
            if identifier == "startScan" {
                if let viewController = segue.destination as? ScanViewController {
                    viewController.category = chosenCategory
                }
            }
            if identifier == "startSearch" {
                if let viewController = segue.destination as? LearnViewController {
                    viewController.category = chosenCategory
                }
            }
            if identifier == "startRead" {
                if let viewController = segue.destination as? ReadViewController {
                    viewController.category = chosenCategory
                }
            }
            
            if identifier == "startLibrary" {
                if let viewController = segue.destination as? LibraryViewController {
                    viewController.category = chosenCategory
                    viewController.fromGameType = true
                }
            }
        }
    }
    
}
