//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 14.07.2023.
//

import Foundation
import UIKit

// Алерт с протоколом
protocol AlertPresenterProtocol {
    func show(alertModel: AlertModel)
}

final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
}

// MARK: - extension AlertPresenter: AlertPresenterProtocol
extension AlertPresenter: AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .default) { _ in
            alertModel.buttonAction()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

