//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Игорь Мунгалов on 14.08.2023.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication! // примитив приложения (символизирует приложение, которое тестируем)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // чтобы быть уверенными, что эта переменная будет проинициализирована на момент использования:
        app = XCUIApplication()
        app.launch()
        
        //если один тест не прошёл, то следующие тесты запускаться не будут
        continueAfterFailure = false
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testExample() throws {

        let app = XCUIApplication()
        app.launch()
        
    }
    
    // Этот метод будет хранить код теста
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
       // XCTAssertFalse(firstPosterData == secondPosterData)
       // XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    // тест, меняется ли лейбл с номером вопроса
    func testIndexLabel() {
        let indexLabel = app.staticTexts["Index"]
        app.buttons["Yes"].tap()
        sleep(3)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
}
