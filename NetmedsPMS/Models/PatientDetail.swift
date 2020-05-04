//
//  PatientDetail.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 03/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import Foundation

enum Gender: String{
    case Male = "M"
    case Female = "F"
}

enum Languages: String{
    case English
}

struct PatientDetail{
    var firstName : String
    var middleName : String
    var lastName : String
    var gender : String
    var imageUrl : String
    var dob : String
    var age : String
    var contactNo : String
    var localId : String
    //let referralDoctor : Doctor
    //let referralPatient : Patient
    var email : String
    var language: String
}
