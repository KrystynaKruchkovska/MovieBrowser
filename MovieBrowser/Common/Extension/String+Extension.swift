//
//  String+Extension.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import Foundation

extension String {
    var extractYear: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"

        guard let date = dateFormatter.date(from: self) else {
                return ""
        }
        
        let yearComponent = Calendar.current.dateComponents([.year], from: date)
        
        guard let year = yearComponent.year else {
            return ""
        }
        
        return  Self(year)
    }
}
