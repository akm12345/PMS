//
//  NMAddPatientViewController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

class NMAddPatientViewController: NMBaseViewController {
    
    @IBOutlet weak var addPatientTableView: UITableView!
    var patientdetails: PatientDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        getUpdatedValues()
        savePatientDetailsToDatabase()
    }
    
    func savePatientDetailsToDatabase(){
        if validateEntries(){
            savePatientInfoRecordsToDatabase()
        }else{
            showAlert(message: msgFieldvalidationsfailed)
        }
    }
    
    func validateEntries() -> Bool{
        let cell: PatientPrimaryInfoCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PatientPrimaryInfoCell
        if let firstName = cell.firstNameTextField.text, firstName.count <= 0{
            showAlert(message: msgValidFirstName)
            return false
        }
        if let lastName = cell.lastNameTextField.text, lastName.count <= 0{
            showAlert(message: msgValidLastName)
            return false
        }
        
        let dobAndAgeCell: PatientDOBAndAgeCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PatientDOBAndAgeCell
        if let age = dobAndAgeCell.patientAgeTextField.text, !Utility.isValidAge(age: age){
            showAlert(message: msgValidAge)
            return false
        }
        
        let contactNocell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! CommonTableCell
        if let phoneNo = contactNocell.commonCellTextField.text, !Utility.isValidPhone(phone: phoneNo){
            showAlert(message: msgValidMobile)
            return false
        }
        
        let localIDCell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! CommonTableCell
        if let localId = localIDCell.commonCellTextField.text, localId.count <= 0{
            showAlert(message: msgValidLocalId)
            return false
        }
        
        let emailcell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! CommonTableCell
        if let email = emailcell.commonCellTextField.text, !Utility.isValidEmail(testStr: email){
            showAlert(message: msgValidEmail)
            return false
        }
        return true
    }
    
    func getUpdatedValues(){
        patientdetails = PatientDetail(firstName: "", middleName: "", lastName: "", gender: Gender.Male.rawValue, imageUrl: "", dob: "", age: "", contactNo: "", localId: "",  email: "", language: msgEnglish)
        let cell: PatientPrimaryInfoCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PatientPrimaryInfoCell
        patientdetails?.firstName = cell.firstNameTextField.text!
        patientdetails?.middleName = cell.middleNametextField.text!
        patientdetails?.lastName = cell.lastNameTextField.text!
        patientdetails?.gender = cell.patientGendersegmentedControl.selectedSegmentIndex == 0 ? Gender.Male.rawValue : Gender.Female.rawValue
        
        let dobAndAgeCell: PatientDOBAndAgeCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PatientDOBAndAgeCell
        patientdetails?.dob = dobAndAgeCell.patientDobTextfield.text!
        patientdetails?.age = dobAndAgeCell.patientAgeTextField.text!
        
        let contactNocell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! CommonTableCell
        patientdetails?.contactNo = contactNocell.commonCellTextField.text!
        
        let localIDell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! CommonTableCell
        patientdetails?.localId = localIDell.commonCellTextField.text!
        
        let emailcell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! CommonTableCell
        patientdetails?.email = emailcell.commonCellTextField.text!
        
        let languageCell: CommonTableCell = self.addPatientTableView.cellForRow(at: IndexPath(row: 7, section: 0)) as! CommonTableCell
        patientdetails?.language = languageCell.commonCellTextField.text!
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        //Todo:-
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func savePatientInfoRecordsToDatabase() {
        
        let tableName = TableNames.PatientInfo.rawValue
        if let patientInfoValues = createPatientInfoValues() {
            FMDBDatabase.insert(values: patientInfoValues, into: tableName) { (success, error) in
                showConfirmation(message: msgPatientDetailsSaved, error: error)
            }
        }
    }
    
    private func createPatientInfoValues() -> [String]? {
        guard let patientdetails = patientdetails else{ return nil}
        let values : [String] = [patientdetails.firstName,
                                 patientdetails.middleName,
                                 patientdetails.lastName,
                                 patientdetails.gender,
                                 patientdetails.imageUrl,
                                 patientdetails.dob,
                                 patientdetails.age,
                                 patientdetails.contactNo,
                                 patientdetails.localId,
                                 patientdetails.email,
                                 patientdetails.language,]
        return values.count > 0 ? values : nil
    }
    
    //End editing when user taps outside of textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension NMAddPatientViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            if let primaryInfoCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PatientPrimaryInfoCell.self)) as? PatientPrimaryInfoCell{
                return primaryInfoCell
            }
        case 1:
            if let patientDobAndAgeCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PatientDOBAndAgeCell.self)) as? PatientDOBAndAgeCell{
                return patientDobAndAgeCell
            }
        case 2,3,4,5,6,7:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommonTableCell.self)) as? CommonTableCell{
                cell.configure(indexPath: indexPath)
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

//MARK:- keyboard avoiding
extension NMAddPatientViewController{
    @objc func keyboardWillShow(_ notification:Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            addPatientTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            addPatientTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
