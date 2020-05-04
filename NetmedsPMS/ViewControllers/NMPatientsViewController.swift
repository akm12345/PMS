//
//  NMPatientsViewController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit
import FMDB

struct PatientModel{
    var name: String
    var imageUrl: String
    var mobileNo: String
    var localId: String
}

class NMPatientsViewController: NMBaseViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var registeredPatientsTableView: UITableView!
    
    var patientsList = [PatientModel]()
    var isDynamicSearchOn: Bool = false
    var filteredPatientList = [PatientModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredPatientList = patientsList
        registeredPatientsTableView.tableFooterView = UIView()
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPatientsListFromDatabase()
    }
    
    func getPatientsListFromDatabase() {
        let table = TableNames.PatientInfo.rawValue
//        let columnNames : [String] = [PatientInfoTableColums.firstName.rawValue,
//                                      PatientInfoTableColums.middleName.rawValue,
//                                      PatientInfoTableColums.lastName.rawValue,
//                                      PatientInfoTableColums.imageUrl.rawValue,
//                                      PatientInfoTableColums.contactNo.rawValue,
//                                      PatientInfoTableColums.localId.rawValue
//        ]
//        FMDBDatabase.querySpecificColumns(columnNames: columnNames, on: table) { (success, fmresultSet, error) in
//            if let error = error {
//                showAlert(message: error.localizedDescription)
//            }
//        }
        
        FMDBDatabase.query(on: table, where: nil) { (success, fmresult, error) in
            if let error = error {
                showAlert(message: error.localizedDescription)
            }
            
            if let fmresult = fmresult {
                createPatientsModel(fmresult: fmresult)
            }
        }
    }
    
    private func createPatientsModel(fmresult: FMResultSet){
        patientsList = []
        while fmresult.next() {
            guard let firstName = fmresult.object(forColumnIndex: 1) as? String else {return}
            guard  let middelName = fmresult.object(forColumnIndex: 2) as? String? else {return}
            guard let lastName = fmresult.object(forColumnIndex: 3) as? String else {return}
            guard  let imageUrl = fmresult.object(forColumnIndex: 5) as? String else {return}
            guard  let mobile = fmresult.object(forColumnIndex: 8) as? String else {return}
            guard  let localId = fmresult.object(forColumnIndex: 9) as? String else {return}
            
            var name : String = firstName
            if let middleName = middelName{
                name += " \(middleName)"
            }
            name += " \(lastName)"
            let pateientModel = PatientModel(name: name, imageUrl: imageUrl, mobileNo: mobile, localId: localId)
            patientsList.append(pateientModel)
        }
        
        fmresult.close()
        updatePatientsTableView()
    }
    
    private func updatePatientsTableView() {
        filteredPatientList = patientsList
        registeredPatientsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NMAddAppointmentViewController{
            print(sender as Any)
            destinationVC.patientModel = sender as? PatientModel
        }
    }
    
    @IBAction func onSearchTextChanged(_ sender: UITextField) {
        if var searchText = sender.text {
            searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            isDynamicSearchOn = searchText.count > 0
            self.dynamicSearchPatientName(searchedString: searchText)
        }
    }
    
    //Hide keyboard when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchTextField.resignFirstResponder()
    }
}

extension NMPatientsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPatientList.count == 0{
            tableView.setEmptyTableView(msgNoPatientRecords)
        }else{
            tableView.restore()
        }
        return filteredPatientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PatientsTableCell.self)) as? PatientsTableCell else {return UITableViewCell()}
        tableCell.configure(patientModel: filteredPatientList[indexPath.row])
        return tableCell
    }
}

extension NMPatientsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "idSegueToAddAppointment", sender: filteredPatientList[indexPath.row])
    }
}

//MARK: Extension for TextFieldDelegate methods
extension NMPatientsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Dynamic search methods
extension NMPatientsViewController {
    //Function to dynamically search patient names
    func dynamicSearchPatientName(searchedString: String) {
        
        if (searchedString.count != 0){
            filteredPatientList = self.searchService(searchString: searchedString, serviceArray: patientsList)
        }
        else {
            filteredPatientList = patientsList
        }
        registeredPatientsTableView.reloadData()
    }
    
    func searchService(searchString: String, serviceArray: [PatientModel]) -> [PatientModel] {
        var searchResult = [PatientModel]()
        
        searchResult = serviceArray.filter { (model: PatientModel) -> Bool in
            return model.name.lowercased().contains(searchString.lowercased())
        }
        return searchResult
    }
}
