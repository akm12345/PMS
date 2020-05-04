//
//  File.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 04/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import Foundation

enum TableNames: String{
    case PatientInfo
    case AppointmentInfo
}

enum PatientInfoTableColums: String{
    case firstName
    case middleName
    case lastName
    case gender
    case imageUrl
    case dob
    case age
    case contactNo
    case localId
    //let referralDoctor : Doctor
    //let referralPatient : Patient
    case email
    case language
}

class Utility{
    
    //MARK:- Email validation
    static func isValidEmail(testStr: String?) -> Bool {
        if testStr == nil {return false}
        if testStr!.count == 0 {return false}
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr!)
    }
    
    static func isValidPhone(phone: String?) -> Bool{
        if phone == nil {return false}
        if phone!.count != 10 {return false}
        return kAllowedDecimalCharacters.isSuperset(of: CharacterSet(charactersIn: phone!))
    }
    
    static func isValidAge(age: String?) -> Bool{
        if age == nil {return false}
        if age!.count == 0 {return false}
        return kAllowedDecimalCharacters.isSuperset(of: CharacterSet(charactersIn: age!))
    }
}
