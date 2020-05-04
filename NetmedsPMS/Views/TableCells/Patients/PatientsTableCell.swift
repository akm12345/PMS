//
//  PatientsTableCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

class PatientsTableCell: UITableViewCell {
    
    @IBOutlet weak var patientProfileImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientMobileNoLabel: UILabel!
    @IBOutlet weak var patientLocalIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(patientModel: PatientModel){
        self.patientNameLabel.text = patientModel.name
        self.patientMobileNoLabel.text = patientModel.mobileNo
        self.patientLocalIDLabel.text = patientModel.localId
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
