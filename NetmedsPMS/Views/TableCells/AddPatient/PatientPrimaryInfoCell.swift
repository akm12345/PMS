//
//  PatientPrimaryInfoCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PatientPrimaryInfoCell: UITableViewCell {
   
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var middleNametextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var patientprofileImageButton: RoundButton!
    @IBOutlet weak var patientGendersegmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
