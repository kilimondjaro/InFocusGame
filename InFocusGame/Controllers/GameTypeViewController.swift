//
//  GameTypeViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class GameTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var backButton: UIButton!        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var chosenCategory = Categories.animals
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        backButton.layer.cornerRadius = backButton.frame.size.height / 2
        
        highlightMode()
    }
    
    func highlightMode() {
        let mode = GameMode(rawValue: UserDefaults.standard.string(forKey: "gameType")!)!
        
        switch mode {
        case GameMode.read:
            readButton.layer.borderColor = UIColor.red.cgColor
        case GameMode.scan:
            scanButton.layer.borderColor = UIColor.red.cgColor
        case GameMode.search:
            searchButton.layer.borderColor = UIColor.red.cgColor
        default:
            return
        }
    }
    
    func clearBorder() {
        readButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        searchButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        scanButton.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
    }
    
    
    func changeGameMode(_ mode: GameMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: "gameType")
        clearBorder()
        highlightMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! LibraryCollectionViewCell

        let category = Categories.getCategories()[indexPath.row].rawValue
        
        cell.imageView.image = UIImage(named: category)
        cell.layer.borderWidth = 3
        cell.layer.borderColor = #colorLiteral(red: 0.4426150219, green: 0.2310840463, blue: 0.1296991088, alpha: 1)
        cell.layer.cornerRadius =  cell.frame.size.height / 10
        cell.label.text = NSLocalizedString(category, comment: "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.getCategories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCategory = Categories.getCategories()[indexPath.row]
        
        let mode = GameMode(rawValue: UserDefaults.standard.string(forKey: "gameType")!)!
        
        switch mode {
        case GameMode.read:
            self.performSegue(withIdentifier: "startRead", sender: self)
        case GameMode.scan:
            self.performSegue(withIdentifier: "startScan", sender: self)
        case GameMode.search:
            self.performSegue(withIdentifier: "startSearch", sender: self)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
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
        }
    }
    
}
