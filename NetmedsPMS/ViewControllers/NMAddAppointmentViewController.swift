//
//  NMAddAppointmentViewController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

enum AppointmentInfoTableColumn: String{
    case patientName
    case doctorName
    case appointmentDate
    case appointmentTime
}

class NMAddAppointmentViewController: NMBaseViewController {
    
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    var patientModel: PatientModel?
    var appointmentDate: String?
    var appointmnetTime: String?
    
    @IBOutlet weak var patientdatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patientdatePicker.minimumDate = Date()
        appointmentsTableView.tableFooterView = UIView()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        self.appointmentsTableView.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        configureDateTimePicker()
    }
    
    func configureDateTimePicker(){
        //Picker One
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeStyle = DateFormatter.Style.short
        self.appointmnetTime = dateFormatter1.string(from: Date())
        
        //Picker Two
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.long
        let strDate = dateFormatter2.string(from: Date())
        self.appointmentDate = strDate
        
        //Customization
        self.patientdatePicker.isHidden = true
        self.patientdatePicker.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    
    //Hide pickers
    @objc func dismissPickerView(){
        self.patientdatePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    //End editing gesture recognizer
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(dismissPickerView))
        return tap
    }
    
    //Date select button clicked
    @IBAction func onDateTimePicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        if (self.patientdatePicker.datePickerMode == .time) {
            dateFormatter.timeStyle = DateFormatter.Style.short
            self.appointmnetTime = dateFormatter.string(from: self.patientdatePicker.date)
            appointmentsTableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        } else {
            dateFormatter.dateStyle = DateFormatter.Style.long
            let strDate = dateFormatter.string(from: patientdatePicker.date)
            appointmentDate = strDate
            appointmentsTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != self.patientdatePicker {
            self.patientdatePicker.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    @IBAction func addAppointmentButtonTapped(_ sender: Any) {
        saveAppointmentInfoRecordsToDatabase()
    }
    
    func saveAppointmentInfoRecordsToDatabase() {
        
        let tableName = TableNames.AppointmentInfo.rawValue
        if let patientInfoValues = createAppointmentInfoValues() {
            FMDBDatabase.insert(values: patientInfoValues, into: tableName) { (success, error) in
                showConfirmation(message: msgAppointmentDetailsSaved, error: error)
            }
        }
    }
    
    private func createAppointmentInfoValues() -> [String]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        let formattedDateString = dateFormatter.string(from: self.patientdatePicker.date)
        dateFormatter.dateFormat = kTimeFormat
        let formattedTimeString = dateFormatter.string(from: self.patientdatePicker.date)
        
        guard let patientName = patientModel?.name else{ return nil}
        let values : [String] = [patientName,
                                 kDoctorName,
                                 formattedDateString,
                                 formattedTimeString]
        return values.count > 0 ? values : nil
    }
}

extension NMAddAppointmentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasicAppointmentDetailCell.self)) as? BasicAppointmentDetailCell{
                if let patientModel = patientModel{
                    cell.configure(patientModel: patientModel)
                }
                return cell
            }
        case 1,2,3,4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommonAppointmentCell.self)) as? CommonAppointmentCell{
                cell.configure(indexPath: indexPath, appointmentDate : appointmentDate, appointmentTime: appointmnetTime)
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AppointmentDescriptionCell.self)) as? AppointmentDescriptionCell{
                return cell
            }
        case 6:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AppointmentBookingCell.self)) as? AppointmentBookingCell{
                return cell
            }
        case 7:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AppointmentNotificationCell.self)) as? AppointmentNotificationCell{
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension NMAddAppointmentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.row {
        case 3:
            patientdatePicker.isHidden = false
            patientdatePicker.datePickerMode = .date
        case 4:
            patientdatePicker.isHidden = false
            patientdatePicker.datePickerMode = .time
        default:
            patientdatePicker.isHidden = true
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
