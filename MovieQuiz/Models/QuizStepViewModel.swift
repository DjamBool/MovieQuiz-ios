//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 11.07.2023.
//

import Foundation
import UIKit

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // картинка с афишей фильма с типом UIImage
    let image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}