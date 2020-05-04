//
//  CommonTableCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CommonTableCell: UITableViewCell {
    
    @IBOutlet weak var commonCellTextField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(indexPath: IndexPath){
        switch indexPath.row {
        case 2:
            self.commonCellTextField.placeholder = "Contact No"
        case 3:
            self.commonCellTextField.placeholder = "Local ID"
        case 4:
            self.commonCellTextField.placeholder = "Select Referral Doctor"
            self.accessoryType = .disclosureIndicator
        case 5:
            self.commonCellTextField.placeholder = "Select Referral Patient"
            self.accessoryType = .disclosureIndicator
        case 6:
            self.commonCellTextField.placeholder = "Email (Optional)"
        case 7:
            self.commonCellTextField.placeholder = "Language"
            self.commonCellTextField.text = "English"
            self.accessoryType = .disclosureIndicator
        default:
            return
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
