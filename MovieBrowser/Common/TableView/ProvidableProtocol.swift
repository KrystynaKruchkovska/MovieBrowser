//
//  ProvidableProtocol.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import Foundation

protocol Providable {
    associatedtype ProvidedItem: Hashable
    func provide(_ item: ProvidedItem)
}
