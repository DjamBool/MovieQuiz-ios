//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 11.07.2023.
//

import Foundation

//структура вопроса
struct QuizQuestion {
    // строка с названием фильма,совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
