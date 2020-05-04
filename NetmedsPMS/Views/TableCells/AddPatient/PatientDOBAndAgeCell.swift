//
//  PatientDOBAndAgeCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PatientDOBAndAgeCell: UITableViewCell {
    @IBOutlet weak var patientDobTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var patientAgeTextField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
