//
//  MoviesLoaderTests.swift
//  MyMovieQuizTests
//
//  Created by Игорь Мунгалов on 12.08.2023.
//


import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case.success(let movies):
                // проверка, что пришло два фильма 
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
       waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true) // хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { reult in
            // Then
            switch reult {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
