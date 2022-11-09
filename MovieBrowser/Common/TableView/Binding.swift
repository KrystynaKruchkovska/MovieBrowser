//
//  Binding.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import Foundation

class Binding<T> {
    typealias Handler = (T) -> Void
    
    private var handler: Handler?
    
    public var value: T {
        didSet {
            handler?(value)
        }
    }
        
    public init(_ value: T) {
        self.value = value
    }
    
    public func bind(_ handler: Handler?) {
        handler?(value)
        self.handler = handler
    }
}
