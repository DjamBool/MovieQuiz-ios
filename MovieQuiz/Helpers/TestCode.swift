//
//  TestCode.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 29.06.2023.
//

import UIKit

// т.к. в Attribute Inspector невозможно выбрать нужный шрифт -> аутлеты для кнопок:
// в коде нужно @IBOutlet
private weak var noButton: UIButton!
private weak var yesButton: UIButton!

private weak var questionTitleLabel: UILabel!
private weak var indexLabel: UILabel!
private weak var questionLabel: UILabel!

// функция назначения шрифта для title кнопок и лейблов, если такой шрифт есть
private func installFont() {
        for family: String in UIFont.familyNames{
            for names: String in UIFont.fontNames(forFamilyName: family){
                if names == "YSDisplay-Medium" {
                noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20) ?? UIFont(name: "Zapfino", size: 25)

                yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
                questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
                indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
                questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
            }
        }
    }
}
private func setButtonAppearance(button: UIButton) {
    //button.titleLabel!.font =  UIFont(name: "YSDisplay-Medium", size: 20)
    button.setTitle("Net", for: .normal)
    
}

protocol YandexFontProtocol {
    var font: UIFont {get}
    func setFont()
}

extension UIButton: YandexFontProtocol {
    var font: UIFont {
        return UIFont(name: "YSDisplay-Medium", size: 20) ?? UIFont(name: "Zapfino", size: 25)!
    }
    func setFont() {
        self.titleLabel?.font = font
    }
}
