//
//  AuthorizationViewController.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 21.10.2022.
//

import AsyncDisplayKit

protocol AuthorizationViewControllerProtocol: AnyObject {

	func hideActivityIndicator()

	func showActivityIndicator()
}

final class AuthorizationViewController: ASDKViewController<ASDisplayNode> {

	var interactor: AuthorizationInteractorProtocol?

	// MARK: - Private properties

	private var isTheKeyboardDisplayed = false

	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.frame = node.frame
		activityIndicator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		return activityIndicator
	}()

	private let scrollNode: ASScrollNode = {
		let scrollNode = ASScrollNode()
		scrollNode.automaticallyManagesSubnodes = true
		scrollNode.automaticallyManagesContentSize = true
		return scrollNode
	}()

	private let githubLogo: ASImageNode = {
		let githubIcon = ASImageNode()
		githubIcon.image = UIImage(named: Asserts.gitHubLogo)
		githubIcon.style.height = ASDimension(unit: .points, value: 120)
		githubIcon.style.width = ASDimension(unit: .points, value: 120)
		return githubIcon
	}()

	private lazy var tokenTextField: ASEditableTextNode = {
		let font = UIFont.systemFont(ofSize: 18)
		let tokenTextField = ASEditableTextNode()
		tokenTextField.textContainerInset = UIEdgeInsets(top: 9,
														 left: 15,
														 bottom: 4,
														 right: 15)
		tokenTextField.enablesReturnKeyAutomatically = true
		tokenTextField.attributedPlaceholderText = NSAttributedString(string: Strings.tokenPlaceholder,
																	  attributes: [NSAttributedString.Key.font: font,
																				   NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
		tokenTextField.textView.font = font
		tokenTextField.borderColor = UIColor.black.cgColor
		tokenTextField.borderWidth = 2
		tokenTextField.cornerRadius = 20
		tokenTextField.style.height = ASDimension(unit: .points, value: 80)
		tokenTextField.style.width = ASDimension(unit: .fraction, value: 1)
		return tokenTextField
	}()

	private lazy var authButton: ASButtonNode = {
		let button = ASButtonNode()
		button.addTarget(self, action: #selector(authButtonTapped), forControlEvents: .touchUpInside)
		button.cornerRadius = 20
		button.setTitle(Strings.authorize,
						with: UIFont.boldSystemFont(ofSize: 18),
						with: .white, for: .normal)
		button.style.height = ASDimension(unit: .points, value: 40)
		button.style.width = ASDimension(unit: .fraction, value: 1)
		button.backgroundColor = .black
		return button
	}()

	// MARK: - Init

	override init() {
		super.init(node: scrollNode)
		node.backgroundColor = .white
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
		addHideKeyboardGesture()
		node.view.addSubview(activityIndicator)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardDidShow(notification:)),
											   name: UIResponder.keyboardDidShowNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardDidHide(notification:)),
											   name: UIResponder.keyboardDidHideNotification,
											   object: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		view.window?.endEditing(true)
	}
}

// MARK: - AuthorizationViewControllerProtocol

extension AuthorizationViewController: AuthorizationViewControllerProtocol {

	func hideActivityIndicator() { activityIndicator.stopAnimating() }

	func showActivityIndicator() { activityIndicator.startAnimating() }
}

// MARK: - Private methods

private extension AuthorizationViewController {

	func setupLayout() {
		node.layoutSpecBlock = { _, _ in
			let content = ASStackLayoutSpec(
				direction: .vertical,
				spacing: 10,
				justifyContent: .start,
				alignItems: .center,
				children: [self.githubLogo,
						   self.tokenTextField,
						   self.authButton]
			)

			content.style.maxWidth = ASDimension.init(unit: .points, value: 100)

			var sideInset: CGFloat
			var bottomInset: CGFloat

			if UIDevice.current.orientation.isLandscape {
				let elementsWidth = UIScreen.main.bounds.height
				sideInset = (UIScreen.main.bounds.width - elementsWidth) / 2
				bottomInset = self.isTheKeyboardDisplayed ? 250 : 0
			} else {
				bottomInset = 0
				sideInset = 32
			}

			let centeredContent = ASInsetLayoutSpec(
				insets: UIEdgeInsets(top: 50,
									 left: sideInset,
									 bottom: bottomInset,
									 right: sideInset),
				child: content
			)

			return centeredContent
		}
	}

	func addHideKeyboardGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tapGesture)
	}
}

// MARK: - Actions

private extension AuthorizationViewController {

	@objc func authButtonTapped() {
		hideKeyboard()
		interactor?.startAuthorization(with: tokenTextField.textView.text)
	}

	@objc func hideKeyboard() { view.endEditing(true) }

	@objc func keyboardDidShow(notification: Notification) {
		isTheKeyboardDisplayed = true
		node.setNeedsLayout()
	}

	@objc func keyboardDidHide(notification: Notification) {
		isTheKeyboardDisplayed = false
		node.setNeedsLayout()
	}
}
