//
//  CalendarTableCell.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

class CalendarTableCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var appointmentStatusLabel: RoundLabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(appointmentModel: AppointmentModel){
        patientNameLabel.text = appointmentModel.patientName
        doctorNameLabel.text = appointmentModel.doctorName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        if let date = dateFormatter.date(from: appointmentModel.appointmentDate){
            print(date)
        }
        
        startTimeLabel.text = appointmentModel.appointmentTime
        dateFormatter.dateFormat = kTimeFormat
        if let time = dateFormatter.date(from: appointmentModel.appointmentDate){
            print(time)
            let updatedTime = time.addingTimeInterval(30 * 60)
            endTimeLabel.text = dateFormatter.string(from: updatedTime)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
