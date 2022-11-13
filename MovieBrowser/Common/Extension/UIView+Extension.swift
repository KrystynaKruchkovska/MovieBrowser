//
//  UIView+Extension.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 11/11/2022.
//  
//


import UIKit

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}
