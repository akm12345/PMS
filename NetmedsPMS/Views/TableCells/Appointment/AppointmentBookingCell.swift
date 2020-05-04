//
//  AppointmentBookingCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

class AppointmentBookingCell: UITableViewCell {

    @IBOutlet weak var appointmentBookingLabel: UILabel!
    @IBOutlet weak var bookingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func bookingSwitchToggled(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
