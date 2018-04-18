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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchObject(_ sender: UISwitch) {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FlatObjects")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(objectSwitch.isOn, forKey: objectName)
            }
            try context.save()
        } catch {
            print("Failed")
        }
    }
    
}
