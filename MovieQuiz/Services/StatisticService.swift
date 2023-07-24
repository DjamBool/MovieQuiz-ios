//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Игорь Мунгалов on 19.07.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct count: Int, total amount: Int)
}

// MARK: - class StatisticServiceImplementation

final class StatisticServiceImplementation {
    // для хранения данных в userDefaults нужны ключи:
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    let userDefaults = UserDefaults.standard
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let dateProvider: () -> Date
    init(
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}

// MARK: - extension

extension StatisticServiceImplementation: StatisticService {
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  //декодировать это тип GameRecord из получ. data
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                print("Что-то пошло не так...")
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
            
        }
        set {
            guard let data = try? encoder.encode(newValue) else { print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        correct +=  count
        total += amount
        self.gamesCount += 1
        let date = dateProvider()
        
        let currentBestGame = GameRecord(correct: count, total: amount, date: date)
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame  {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
