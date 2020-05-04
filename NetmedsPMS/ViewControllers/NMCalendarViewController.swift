//
//  NMCalendarViewController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit
import FSCalendar
import FMDB

struct AppointmentModel{
    var patientName: String
    var doctorName: String
    var appointmentDate: String
    var appointmentTime: String
}

class NMCalendarViewController: NMBaseViewController {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var datesArray = [String]()
    let dateFormatter = DateFormatter()
    
    var appointmetsList = [AppointmentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarProperties()
        calendarTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAppointmentDatesFromDatabase()
    }
    
    private func setupCalendarProperties(){
        calendar.layer.borderColor = UIColor.darkGray.cgColor
        calendar.layer.borderWidth = 1.0
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = kDateFormat
    }
    
    func getAppointmentDatesFromDatabase(){
        let table = TableNames.AppointmentInfo.rawValue
        let _ : [String] = [AppointmentInfoTableColumn.appointmentDate.rawValue]
        
        FMDBDatabase.query(on: table, where: nil) { (success, fmresult, error) in
            if let error = error {
                showAlert(message: error.localizedDescription)
            }
            if let fmresult = fmresult {
                createAppointmentDatesModel(fmresult: fmresult)
            }
        }
    }
    
    func createAppointmentDatesModel(fmresult: FMResultSet){
        datesArray = []
        while fmresult.next() {
            guard let formattedDate = fmresult.object(forColumnIndex: 3) as? String else {return}
            datesArray.append(formattedDate)
        }
        fmresult.close()
        calendar.reloadData()
    }
    
    private func getAppointmentsForDate(date: String){
        let table = TableNames.AppointmentInfo.rawValue
        let columnNames : [String] = [AppointmentInfoTableColumn.patientName.rawValue,
                                      AppointmentInfoTableColumn.doctorName.rawValue,
                                      AppointmentInfoTableColumn.appointmentDate.rawValue,
                                      AppointmentInfoTableColumn.appointmentTime.rawValue ]
        
        var conditions:[WhereCondition]?
        let condition = WhereCondition(column:AppointmentInfoTableColumn.appointmentDate.rawValue, value: date)
        conditions = [condition]
        
        FMDBDatabase.querySpecificColumns(columnNames: columnNames, on: table, where: conditions) { (success, fmresultSet, error) in
            if let error = error {
                showAlert(message: error.localizedDescription)
            }
            if let fmresult = fmresultSet {
                createAppointmentsModel(fmresult: fmresult)
            }
        }
    }
    
    private func createAppointmentsModel(fmresult: FMResultSet){
        appointmetsList = []
        while fmresult.next() {
            guard let patientName = fmresult.object(forColumnIndex: 0) as? String else {return}
            guard  let doctorName = fmresult.object(forColumnIndex: 1) as? String else {return}
            guard let appointmentDate = fmresult.object(forColumnIndex: 3) as? String else {return}
            guard  let appointmentTime = fmresult.object(forColumnIndex: 3) as? String else {return}
            
            let appointmentModel = AppointmentModel(patientName: patientName, doctorName: doctorName, appointmentDate: appointmentDate, appointmentTime: appointmentTime)
            appointmetsList.append(appointmentModel)
        }
        
        fmresult.close()
        updateCalendarTableView()
    }
    
    private func updateCalendarTableView() {
        calendarTableView.reloadData()
    }
}

extension NMCalendarViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointmetsList.count == 0{
            tableView.setEmptyTableView(msgNoAppointmentsFound)
        }else{
            tableView.restore()
        }
        return appointmetsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CalendarTableCell.self)) as? CalendarTableCell else {return UITableViewCell()}
        tableCell.configure(appointmentModel: appointmetsList[indexPath.row])
        return tableCell
    }
}

//MARK: FSCalendarDelegate menthods.
extension NMCalendarViewController: FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let date = dateFormatter.string(from: date)
        if( datesArray.contains(date)){
            getAppointmentsForDate(date: date)
        }else{
            showAlert(message: msgNoAppointmentsForDate)
        }
    }
    
    //MARK: FSCalendarAppearance menthods.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if datesArray.contains(dateFormatter.string(from: date)){
            return UIColor.red}
        else {return UIColor.white}
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if datesArray.contains(dateFormatter.string(from: date)){
            return UIColor.white}
        else {return UIColor.darkGray}
    }
}
