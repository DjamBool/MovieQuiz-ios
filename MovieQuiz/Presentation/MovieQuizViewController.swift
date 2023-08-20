import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    // MARK: - свойства
    // т.к. в Attribute Inspector невозможно выбрать нужный шрифт -> нужны аутлеты для установки шрифта:
    @IBOutlet  weak var noButton: UIButton!
    @IBOutlet  weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet  weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var presenter: MovieQuizPresenter! // шаг 2.7
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installFont()
        installBorder()
        showLoadingIndicator()
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
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
    
    func lockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    func unlockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        self.imageView.layer.borderWidth = 0
    }
    
    func show(quiz step: QuizStepViewModel) { // Шаг 2.4 - убрать private
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // шаг 2.9
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
    }
    
    func showResults(quiz result: QuizResultsViewModel) { // шаг 2.6
        
        let message = presenter.makeResultMessage()
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message, // шаг 2.8
                                    buttonText: "Сыграть ещё раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex() //Шаг 1.5
            self.presenter.correctAnswers = 0 // шаг 2.6
            self.presenter.restartGame()  // шаг 2.7
            
        }
        alertPresenter?.show(alertModel: alertModel)
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
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

