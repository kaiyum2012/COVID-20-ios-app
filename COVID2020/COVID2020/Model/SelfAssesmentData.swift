//
//  SelfAssesmentData.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import Foundation

//Reference: https://www.811healthline.ca/covid-19-self-assessment/are-you-experiencing-any-of-the-following/

public enum OptionType {
    case MULTIPLE
    case TRUE_OR_FALSE
}

struct SelfAssesment {
    var queNO : Int
    var question : String
    var options : [String]
    var type : OptionType
}

let assesments : [SelfAssesment] = [
    SelfAssesment(queNO: 1  , question: "Are you experiencing any of the following:", options: [
        "severe difficulty breathing (e.g., struggling for each breath, speaking in single words)",
        "severe chest pain",
        "having a very hard time waking up",
        "feeling confused",
        "lost consciousness",
        "Unable to lie down due to shortness of breath"
    ],type : OptionType.MULTIPLE),
    
    SelfAssesment(queNO: 2, question: "Do you have two or more of the following symptoms (new or worsening):", options: [
        "Fever (or signs of a fever such as chills, sweats, muscle aches and lightheadedness)",
        "cough",
        "headache",
        "sore throat",
        "runny nose"
    ],type : OptionType.MULTIPLE),
    
    SelfAssesment(queNO: 3, question: "In the past 14 days have you had close contact with someone who is confirmed as having COVID-19?", options: [
        "provided care for the individual, including healthcare workers, family members or other caregivers, or who had other similar close physical contact without consistent and appropriate use of personal protective equipment OR",
        "who lived with or otherwise had close prolonged contact (within 2 meters) with the person while they were infectious OR",
        "had direct contact with infectious bodily fluids of the person (e.g. was coughed or sneezed on) while not wearing recommended personal protective equipment"
    ],type : OptionType.MULTIPLE)
]
