import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    // MARK: - свойства
    // т.к. в Attribute Inspector невозможно выбрать нужный шрифт -> нужны аутлеты для установки шрифта:
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    // Рефакторинг
    private let presenter = MovieQuizPresenter()
    // удалить convert()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installFont()
        installBorder()
        
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - методы
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() { // changed
            showResults()
            installBorder()
        } else {
            presenter.switchToNextQuestion()    // changed
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showResults() {
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount) // changed
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: makeResultMessage(),
                                    buttonText: "Сыграть ещё раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex() // changed
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService,
              let bestGame = statisticService.bestGame
        else {
            print("Результат неизвестен")
            return ""
        }
        let currentCorrectAnswers = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)"
        let numberOfTestsPlayed = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestResult = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " " + "\(bestGame.date.dateTimeString)"
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let averageAccuracy = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [currentCorrectAnswers, numberOfTestsPlayed, bestResult, averageAccuracy].joined(separator: "\n")
        
        return resultMessage
    }
    
    private func installFont() {
        noButton.titleLabel?.font = UIFont.init(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont.init(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
    private func installBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex() // changed
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

// MARK: - extension MovieQuizViewController: QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        self.currentQuestion = question
        //let viewModel = self.convert(model: question!)
        if let question = question {
            let viewModel = presenter.convert(model: question)
            self.show(quiz: viewModel)
        }
        
    }
}

/*
 Mock-данные
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
