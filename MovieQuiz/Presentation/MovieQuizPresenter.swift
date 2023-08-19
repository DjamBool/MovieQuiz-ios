//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 16.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - свойства
    let questionsAmount: Int = 10 // шаг 1.3
    private var currentQuestionIndex: Int = 0 // шаг 1.3
    
    var currentQuestion: QuizQuestion? // шаг 2.1
    private weak var viewController: MovieQuizViewController? // шаг 2.1
    
    
    var correctAnswers: Int = 0 // шаг 2.5
    var questionFactory: QuestionFactoryProtocol? // шаг 2.5
    
     // Шаг 2.8
    private let statisticService: StatisticService!
    
    // шаг 2.7
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()   // Шаг 2.8
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    // delegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
        
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - методы
    func isLastQuestion() -> Bool { //Шаг 1.5
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() { //Шаг 1.5
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() { //Шаг 1.5
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel  { // шаг 2
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - кнопки и DRY для повторяющегося кода
    func yesButtonClicked() { // шаг 2.1
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() { // шаг 2.2
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) { // Шаг 2.3
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - showNextQuestionOrResults
    func showNextQuestionOrResults() { // шаг 2.5
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            self.viewController?.showResults(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Шаг 2.8
     func makeResultMessage() -> String {
        guard let statisticService = statisticService,
              let bestGame = statisticService.bestGame
        else {
            print("Результат неизвестен")
            return ""
        }
         statisticService.store(correct: correctAnswers, total: questionsAmount)
         
//         let bestGame = statisticService.bestGame
         
        let currentCorrectAnswers = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let numberOfTestsPlayed = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestResult = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " " + "\(bestGame.date.dateTimeString)"
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let averageAccuracy = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [currentCorrectAnswers, numberOfTestsPlayed, bestResult, averageAccuracy].joined(separator: "\n")
        
        return resultMessage
    }
}

