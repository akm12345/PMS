//
//  NMDataBaseController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 04/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import Foundation

class NMDatabaseController{
    
    static func start(){
        self.createPatientTable()
        self.createAppointmentTable()
    }
    
    static private func createAppointmentTable() {
        let table = TableNames.AppointmentInfo.rawValue
         if  let columns = createApointmentTableColumns(){
             FMDBDatabase.create(table: table, columns: columns) { (success, error) in
                 if let error = error{
                     print(error)
                 }
             }
         }
     }
     
    static private func createApointmentTableColumns() -> [TableColumn]? {
         var columns = [TableColumn]()
         
         columns.append(TableColumn(name:AppointmentInfoTableColumn.patientName.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:AppointmentInfoTableColumn.doctorName.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:AppointmentInfoTableColumn.appointmentDate.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:AppointmentInfoTableColumn.appointmentTime.rawValue, type: "TEXT NOT NULL"))
         return columns.count > 0 ? columns : nil
     }
    
    static func createPatientTable() {
        let table = TableNames.PatientInfo.rawValue
        if  let columns = createTableColumns(){
            FMDBDatabase.create(table: table, columns: columns) { (success, error) in
                //showConfirmation(message: "Patient details saved", error: error)
                if let error = error{
                    print(error)
                }
            }
        }
    }
    
    static private func createTableColumns() -> [TableColumn]? {
        var columns = [TableColumn]()
        
        columns.append(TableColumn(name:PatientInfoTableColums.firstName.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.middleName.rawValue, type: "TEXT"))
        columns.append(TableColumn(name:PatientInfoTableColums.lastName.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.gender.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.imageUrl.rawValue, type: "TEXT"))
        columns.append(TableColumn(name:PatientInfoTableColums.dob.rawValue, type: "TEXT"))
        columns.append(TableColumn(name:PatientInfoTableColums.age.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.contactNo.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.localId.rawValue, type: "TEXT NOT NULL"))
        columns.append(TableColumn(name:PatientInfoTableColums.email.rawValue, type: "TEXT"))
        columns.append(TableColumn(name:PatientInfoTableColums.language.rawValue, type: "TEXT NOT NULL"))
        return columns.count > 0 ? columns : nil
    }

}
