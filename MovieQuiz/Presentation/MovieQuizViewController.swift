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
    
    // private var correctAnswers = 0 // шаг 2.6
    
    // private var questionFactory: QuestionFactoryProtocol? // шаг 2.7
    
    
    private var alertPresenter: AlertPresenterProtocol?
    //private var statisticService: StatisticService? // шаг 2.8
    
    // Рефакторинг
    // private let presenter = MovieQuizPresenter() //  Шаг 4, шаг 2.7
    private var presenter: MovieQuizPresenter! // шаг 2.7
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installFont()
        installBorder()
        
        showLoadingIndicator()
       // questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self) // шаг 2.7
        
        alertPresenter = AlertPresenter(viewController: self)
        // statisticService = StatisticServiceImplementation() // шаг 2.8
        
        //questionFactory?.loadData() // шаг 2.7
        
        presenter = MovieQuizPresenter(viewController: self)
       // presenter.viewController = self // шаг 2.1 //шаг 2.7
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - методы
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked() // шаг 2.4
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked() // шаг 2.4
    }
    
    func show(quiz step: QuizStepViewModel) { // Шаг 2.4 - убрать private
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func showAnswerResult(isCorrect: Bool) { // шаг 2.5
        if isCorrect {
            presenter.correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            //self.presenter.correctAnswers = self.correctAnswers
           // self.presenter.questionFactory = self.questionFactory // шаг 2.7
            self.presenter.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() { // Шаг 5 changed
            let text = "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте еще раз!"

            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            showResults(quiz: viewModel)
            installBorder()
        } else {
            presenter.switchToNextQuestion()    // Шаг 1.5
           // self.presenter.restartGame()  // шаг 2.7
        //    self.questionFactory?.requestNextQuestion() // шаг 2.7
        }
    }
    
  func showResults(quiz result: QuizResultsViewModel) { // шаг 2.6
//      statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount) // шаг 2.8
      let message = presenter.makeResultMessage()
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message, // шаг 2.8
                                    buttonText: "Сыграть ещё раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex() //Шаг 1.5
            self.presenter.correctAnswers = 0 // шаг 2.6
            self.presenter.restartGame()  // шаг 2.7
          //  self.questionFactory?.requestNextQuestion() // шаг 2.7
        }
        alertPresenter?.show(alertModel: alertModel)
    }
    /*
     // шаг 2.8
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService,
              let bestGame = statisticService.bestGame
        else {
            print("Результат неизвестен")
            return ""
        }
        let currentCorrectAnswers = "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)"
        let numberOfTestsPlayed = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestResult = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " " + "\(bestGame.date.dateTimeString)"
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let averageAccuracy = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [currentCorrectAnswers, numberOfTestsPlayed, bestResult, averageAccuracy].joined(separator: "\n")
        
        return resultMessage
    }
   */
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
    
     func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex() // //Шаг 1.5
            self.presenter.correctAnswers = 0
            
            // self.questionFactory?.requestNextQuestion() // шаг 2.7
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel: model)
    }
    
     func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

// MARK: - extension MovieQuizViewController: QuestionFactoryDelegate

// шаг 2.7
/*
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) { // Шаг 2.4  - перенос в презентер
        // let viewModel = presenter.convert(model: question) // Шаг 4
        presenter.didReceiveNextQuestion(question: question)
    }
}
*/

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
