//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 11.07.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate? // weak чтобы избежать retain cycle
    private let moviesLoader: MoviesLoading // добавлен загрузчик фильмов
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) { // обновлен init
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    
    private var questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        guard let question = questions.randomElement() else {
            assertionFailure("question is empty")
            return
        }
        // сообщить контроллеру, что мы достали именно этот вопрос - паттерн Delegate => у QuestionFactory будет сущ зависимость на другой класс через протокол QuestionFactoryDelegate
        delegate?.didReceiveNextQuestion(question: question)
    }
}
