//
//  ObjectsListsTableViewCell.swift
//  InFocusGame
//
//  Created by Kirill Babich on 18/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import CoreData

class ObjectsListsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var objectSwitch: UISwitch!
    var objectName = ""
    var category = Categories.flat
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchObject(_ sender: UISwitch) {
        // TODO - change for many sections
        CoreDataManager.instance.setValue(entity: category.rawValue, key: objectName, value: objectSwitch.isOn)
    }
    
}
