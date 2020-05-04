//
//  CommonAppointmentCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

class CommonAppointmentCell: UITableViewCell {

    @IBOutlet weak var commonImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(indexPath: IndexPath, appointmentDate : String?, appointmentTime: String?){
        switch indexPath.row {
        case 1:
            label.text = kClinicName
        case 2:
            self.accessoryType = .disclosureIndicator
            label.text = kDoctorName
        case 3:
            self.accessoryType = .disclosureIndicator
            commonImageView.image = UIImage(systemName: "calendar")
            label.text = appointmentDate
        case 4:
            self.accessoryType = .disclosureIndicator
            commonImageView.image = UIImage(systemName: "clock")
            label.text = appointmentTime
        default:
            return
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
