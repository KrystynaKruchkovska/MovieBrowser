//
//  InfoAlert.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 14/11/2022.
//  
//


import UIKit

final class DefaultInfoAlert {

    enum DefaultInfo: String {
        case somethingWrongTitle = "Something went wrong."
        case okButtontitle = "Ok"
    }
    func show(
        on viewController: UIViewController,
        title: String = DefaultInfo.somethingWrongTitle.rawValue,
        message: String?,
        buttonTitle: String = DefaultInfo.okButtontitle.rawValue,
        acceptanceCompletion: (() -> Void)?) {
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            acceptanceCompletion?()
        })
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
