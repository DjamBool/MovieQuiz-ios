//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 20.08.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    func showResults(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func lockButtons()
    func unlockButtons()
}
