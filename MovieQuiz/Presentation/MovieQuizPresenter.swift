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
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var currentQuestionIndex: Int = 0
    
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?

    // MARK: - методы
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel  {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - кнопки и DRY для повторяющегося кода
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - didReceiveNextQuestion
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - showNextQuestionOrResults
    func showNextQuestionOrResults() {
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

