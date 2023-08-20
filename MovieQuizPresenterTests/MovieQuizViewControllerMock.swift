//
//  MovieQuizViewControllerMock.swift
//  MovieQuizPresenterTests
//
//  Created by Игорь Мунгалов on 20.08.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
func show(quiz step: QuizStepViewModel) {

}

func showResults(quiz result: QuizResultsViewModel) {
    
}

func highlightImageBorder(isCorrectAnswer: Bool) {
    
}

func showLoadingIndicator() {
    
}

func hideLoadingIndicator() {
    
}

func showNetworkError(message: String) {
    
}

}
