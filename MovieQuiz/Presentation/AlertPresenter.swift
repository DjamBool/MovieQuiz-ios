//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 14.07.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    var viewController = UIViewController()
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default)
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}

