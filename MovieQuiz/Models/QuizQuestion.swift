//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 11.07.2023.
//

import Foundation
// структура вопроса при работе с сетью
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
}



/* структура вопроса. начало
struct QuizQuestion {
    // строка с названием фильма,совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
*/
    
