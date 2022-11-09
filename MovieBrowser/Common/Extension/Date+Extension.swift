//
//  String+Extension.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import Foundation

extension Date {
    var extractYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter.string(from: self)
    }
}
