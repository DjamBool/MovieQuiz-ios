//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 16.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    // MARK: - свойства
    let questionsAmount: Int = 10 // шаг 1.3
    private var currentQuestionIndex: Int = 0 // шаг 1.3
    
    var currentQuestion: QuizQuestion? // шаг 2.1
    weak var viewController: MovieQuizViewController? // шаг 2.1
   
    
    var correctAnswers: Int = 0 // шаг 2.5
    var questionFactory: QuestionFactoryProtocol? // шаг 2.5

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
//        guard let currentQuestion = currentQuestion else {
//                    return
//                }
//                
//                let givenAnswer = true
//                
//                viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//            }
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
    
    // MARK: - didReceiveNextQuestion
    func didReceiveNextQuestion(question: QuizQuestion?) { // Шаг 2.4
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
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
  }

