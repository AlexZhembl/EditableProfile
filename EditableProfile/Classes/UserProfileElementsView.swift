//
//  UserProfileElementsView.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit
import Toast_Swift

// MARK: - Main class which contains input views

final class UserProfileElementsView: UIView {
	
	enum Element {
		typealias TextContent = (text: String?, placeholder: String?)?
		typealias AttributesContent = (attr: UserAttribute?, placeholder: String?)?
		typealias LocationContent = (loc: UserLocation?, placeholder: String?)?
		typealias DateContent = (date: Date?, placeholder: String?)?
		
		case profileImage(UIImage?)
		case displayName(TextContent)
		case realName(TextContent)
		case location(LocationContent)
		case bDay(DateContent)
		case gender(AttributesContent)
		case ethnicity(AttributesContent)
		case religion(AttributesContent)
		case figure(AttributesContent)
		case maritalStatus(AttributesContent)
		case height(TextContent, isEnabled: Bool)
		case occupation(TextContent)
		case aboutMe(TextContent)
		case doneButton(TextContent)
	}
    
    private enum Constants {
        static let pictureButtonSize = CGSize(width: 70, height: 70)
        static let singleLineFiledHeight: CGFloat = 50.0
        static let singleChoiceButtonHeight: CGFloat = 50.0
        static let aboutMeViewHeight: CGFloat = 140.0
        static let doneButtonSize = CGSize(width: 150, height: 50)
        
        static let containerViewInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		static let verticalSpacing: CGFloat = 20.0
		static let singleChoiceViewHeight: CGFloat = 150.0
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
		view.delegate = self
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let pictureButton: UserProfilePictureButton = {
		let button = UserProfilePictureButton(target: self, action: #selector(buttonDidTap), ai: "pictureButton")
        button.layer.cornerRadius = Constants.pictureButtonSize.width * 0.5
        
        return button
    }()
	private lazy var displayNameField = UserProfileTextField(delegate: self, ai: "displayNameField")
    private lazy var realNameField = UserProfileTextField(delegate: self, ai: "realNameField")
    private lazy var locationField = UserProfileLocationField(delegate: self, ai: "locationField")
    private lazy var bDayButton = UserProfileDateButton(target: self, action: #selector(buttonDidTap), ai: "bDayButton")
	private lazy var genderButton = UserProfileAttributesButton(target: self, action: #selector(buttonDidTap), ai: "genderButton")
    private lazy var maritalStatusButton = UserProfileAttributesButton(target: self, action: #selector(buttonDidTap), ai: "maritalStatusButton")
    private lazy var ethnicityButton = UserProfileAttributesButton(target: self, action: #selector(buttonDidTap), ai: "ethnicityButton")
    private lazy var religionButton = UserProfileAttributesButton(target: self, action: #selector(buttonDidTap), ai: "religionButton")
    private lazy var figureButton = UserProfileAttributesButton(target: self, action: #selector(buttonDidTap), ai: "figureButton")
    private lazy var heightField = UserProfileTextField(delegate: self, ai: "heightField")
    private lazy var occupationField = UserProfileTextField(delegate: self, ai: "occupationField")
	private lazy var aboutMeField = UserProfileTextView(delegate: self, ai: "aboutMeField")
    private lazy var doneButton = UserProfileTextButton(target: self, action: #selector(buttonDidTap), ai: "doneButton")
	private lazy var singlePickerView = SingleChoicePickerView()
	private var singlePickerViewConstraints: [NSLayoutConstraint] = []
    
    private let elementInteractionClosure: (Element, String?) -> Void
    private let singlePickerChoiceClosure: (SingleChoicePickerViewChoicable, Element) -> Void
	private let singlePickerDateClosure: (Date, Element) -> Void
	
	init(elementInteractionClosure: @escaping (Element, String?) -> Void,
		 singlePickerChoiceClosure: @escaping (SingleChoicePickerViewChoicable, Element) -> Void,
		 singlePickerDateClosure: @escaping (Date, Element) -> Void) {
        self.elementInteractionClosure = elementInteractionClosure
		self.singlePickerChoiceClosure = singlePickerChoiceClosure
		self.singlePickerDateClosure = singlePickerDateClosure
        super.init(frame: .zero)
        
        setupSubviews()
		setupToastManager()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        setupLayout()
    }
	
	func updateView(with elements: [Element]) {
		// MARK: - Point where we initiating elements with date from model
		elements.forEach { element in
			switch element {
			case .profileImage(let image): 		 pictureButton.setContent(image)
			case .displayName(let text): 		 displayNameField.setContent(text)
			case .realName(let text): 		  	 realNameField.setContent(text)
			case .location(let location): 		 locationField.setContent(location)
			case .bDay(let date):			     bDayButton.setContent(date)
			case .gender(let attr): 			 genderButton.setContent(attr)
			case .ethnicity(let attr): 			 ethnicityButton.setContent(attr)
			case .religion(let attr): 			 religionButton.setContent(attr)
			case .figure(let attr): 			 figureButton.setContent(attr)
			case .maritalStatus(let attr): 		 maritalStatusButton.setContent(attr)
			case .occupation(let text): 		 occupationField.setContent(text)
			case .aboutMe(let text): 			 aboutMeField.setContent(text)
			case .doneButton(let text): 		 doneButton.setContent(text)
			case .height(let text, let isEnabled):
				heightField.setContent(text)
				heightField.keyboardType = .numberPad
				heightField.isEnabled = isEnabled
			}
		}
	}
	
	func setupSingleChoicePicker(for element: UserProfileElementsView.Element, with choices: [SingleChoicePickerViewChoicable]) {
		let relatedView = view(for: element)

		setupSinglePickerLayout(with: relatedView)
		singlePickerView.setup(with: choices) { [weak self] choice in
			self?.singlePickerChoiceClosure(choice, element)
		}
	}
	
	// MARK: - In normal app this method should be part of method above but i have no time
	func setupDateChoicePicker(for element: UserProfileElementsView.Element) {
		let relatedView = view(for: element)

		setupSinglePickerLayout(with: relatedView)
		singlePickerView.setupForDate { [weak self] date in
			self?.singlePickerDateClosure(date, element)
		}
	}
	
	func dismissSinglePicker() {
		singlePickerView.removeFromSuperview()
		NSLayoutConstraint.deactivate(singlePickerViewConstraints)
		singlePickerViewConstraints = []
	}
	
	func showError(for element: Element, error: String) {
		scrollView.setContentOffset(.zero, animated: true)
		
		let relatedView = view(for: element)
		let relatedPoint = CGPoint(x: relatedView.bounds.midX, y: relatedView.bounds.midY)
		let point = relatedView.convert(relatedPoint, to: contentView)
		contentView.makeToast(error, point: point, title: nil, image: nil, completion: nil)
	}
}

// MARK: - Support methods to easy map view->element, element->view

fileprivate extension UserProfileElementsView {
	
	func view(for element: Element) -> UIView {
		switch element {
		case .profileImage: 	return pictureButton
		case .displayName: 		return displayNameField
		case .realName: 		return realNameField
		case .location:		    return locationField
		case .bDay: 			return bDayButton
		case .gender: 			return genderButton
		case .ethnicity: 		return ethnicityButton
		case .religion: 		return religionButton
		case .figure: 			return figureButton
		case .maritalStatus: 	return maritalStatusButton
		case .height: 			return heightField
		case .occupation: 		return occupationField
		case .aboutMe: 			return aboutMeField
		case .doneButton: 		return doneButton
		}
	}
	
	func element(for subview: UIView) -> Element? {
		switch subview {
		case pictureButton: 		return .profileImage(nil)
		case displayNameField: 		return .displayName(nil)
		case realNameField: 		return .realName(nil)
		case locationField: 		return .location(nil)
		case bDayButton: 			return .bDay(nil)
		case genderButton: 			return .gender(nil)
		case ethnicityButton: 		return .ethnicity(nil)
		case religionButton: 		return .religion(nil)
		case figureButton: 			return .figure(nil)
		case maritalStatusButton: 	return .maritalStatus(nil)
		case heightField: 			return .height(nil, isEnabled: heightField.isEnabled)
		case occupationField: 		return .occupation(nil)
		case aboutMeField: 			return .aboutMe(nil)
		case doneButton: 			return .doneButton(nil)
		default:					return nil
		}
	}
	
	@objc func buttonDidTap(_ sender: UIButton) {
		guard let element = element(for: sender) else {
			assertionFailure("Could not find element for subview")
			return
		}
		endEditing(true)
		scrollViewToTop(sender)
		elementInteractionClosure(element, nil)
    }
	
	private func scrollViewToTop(_ subview: UIView) {
		// MARK: - Just add some ux. Usually we should count
		// different betwen keyboard height and the current frame
		// then calculate which offset could be used to place our input view
		// to thee top of keyboard. TODO: if I'll have time
		let convertedFrame = contentView.convert(subview.frame, from: subview.superview)
		let bottomPoint = CGPoint(x: scrollView.contentOffset.x,
								  y: convertedFrame.minY)
		scrollView.setContentOffset(bottomPoint, animated: true)
	}
}

// MARK: - TextView's and TextFeild's deleagtes to tell our model what's happening

extension UserProfileElementsView: UITextFieldDelegate, UITextViewDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		scrollViewToTop(textField)
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let changedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
		guard let element = element(for: textField) else {
			assertionFailure("Could not find element for subview")
			return true
		}
		elementInteractionClosure(element, changedText)
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		scrollViewToTop(textView)
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		textView.resignFirstResponder()
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		guard let element = element(for: textView) else {
			assertionFailure("Could not find element for subview")
			return
		}
		elementInteractionClosure(element, textView.text)
	}
}

// MARK: - Just some UX

extension UserProfileElementsView: UIScrollViewDelegate {
	
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		endEditing(true)
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		endEditing(true)
	}
}

// MARK: - extension with layout only

fileprivate extension UserProfileElementsView {
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(pictureButton)
        
        let nameStackView = UIStackView(arrangedSubviews: [displayNameField, realNameField])
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.distribution = .fillEqually
        nameStackView.axis = .horizontal
        nameStackView.alignment = .fill
        nameStackView.spacing = 0
        contentView.addSubview(nameStackView)
        
        contentView.addSubview(locationField)
        
        let signleButtonsStackView = UIStackView(arrangedSubviews: [bDayButton,
                                                                    genderButton,
                                                                    maritalStatusButton,
                                                                    ethnicityButton,
                                                                    religionButton,
                                                                    figureButton])
        signleButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        signleButtonsStackView.distribution = .fillEqually
        signleButtonsStackView.axis = .vertical
        signleButtonsStackView.alignment = .fill
        signleButtonsStackView.spacing = 0
        contentView.addSubview(signleButtonsStackView)
        
        let heightAndOccupationStackView = UIStackView(arrangedSubviews: [heightField, occupationField])
        heightAndOccupationStackView.translatesAutoresizingMaskIntoConstraints = false
        heightAndOccupationStackView.distribution = .fillEqually
        heightAndOccupationStackView.axis = .vertical
        heightAndOccupationStackView.alignment = .fill
        heightAndOccupationStackView.spacing = 0
        contentView.addSubview(heightAndOccupationStackView)
        
        contentView.addSubview(aboutMeField)
        
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.containerViewInsets.top),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.containerViewInsets.left),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Constants.containerViewInsets.right),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.containerViewInsets.bottom),
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerViewInsets.left),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerViewInsets.right),
            
            pictureButton.widthAnchor.constraint(equalToConstant: Constants.pictureButtonSize.width),
            pictureButton.heightAnchor.constraint(equalToConstant: Constants.pictureButtonSize.height),
            pictureButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            
            pictureButton.widthAnchor.constraint(equalToConstant: Constants.pictureButtonSize.width),
            pictureButton.heightAnchor.constraint(equalToConstant: Constants.pictureButtonSize.height),
            pictureButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            
            nameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: Constants.singleLineFiledHeight),
            nameStackView.topAnchor.constraint(equalTo: pictureButton.bottomAnchor, constant: Constants.verticalSpacing),
            
            locationField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationField.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
            locationField.heightAnchor.constraint(equalToConstant: Constants.singleLineFiledHeight),
            
            signleButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signleButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signleButtonsStackView.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: Constants.verticalSpacing),
            signleButtonsStackView.heightAnchor.constraint(equalToConstant: Constants.singleLineFiledHeight * CGFloat(signleButtonsStackView.arrangedSubviews.count)),
            
            heightAndOccupationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heightAndOccupationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heightAndOccupationStackView.topAnchor.constraint(equalTo: signleButtonsStackView.bottomAnchor, constant: Constants.verticalSpacing),
            heightAndOccupationStackView.heightAnchor.constraint(equalToConstant: Constants.singleLineFiledHeight * CGFloat(heightAndOccupationStackView.arrangedSubviews.count)),
            
            aboutMeField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aboutMeField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aboutMeField.topAnchor.constraint(equalTo: heightAndOccupationStackView.bottomAnchor, constant: Constants.verticalSpacing),
            aboutMeField.heightAnchor.constraint(equalToConstant: Constants.aboutMeViewHeight),
            
            doneButton.widthAnchor.constraint(equalToConstant: Constants.doneButtonSize.width),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.doneButtonSize.height),
            doneButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: aboutMeField.bottomAnchor, constant: Constants.verticalSpacing),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2 * Constants.verticalSpacing),
        ])
    }
	
	func setupSinglePickerLayout(with relatedView: UIView) {
		addSubview(singlePickerView)
		NSLayoutConstraint.deactivate(singlePickerViewConstraints)
		singlePickerViewConstraints = [
			singlePickerView.topAnchor.constraint(equalTo: relatedView.bottomAnchor),
			singlePickerView.leadingAnchor.constraint(equalTo: relatedView.leadingAnchor),
			singlePickerView.trailingAnchor.constraint(equalTo: relatedView.trailingAnchor),
			singlePickerView.heightAnchor.constraint(equalToConstant: Constants.singleChoiceViewHeight)
		]
		NSLayoutConstraint.activate(singlePickerViewConstraints)
	}
	
	private func setupToastManager() {
		// No need to move it to any injection:
		// 1. We use it only like local view
		// 2. It is not a production design, so this dirty ui solition will be replaced
		ToastManager.shared.position = .center
		ToastManager.shared.isQueueEnabled = false
		ToastManager.shared.style.verticalPadding = 0
		ToastManager.shared.style.maxWidthPercentage = 0.4
		ToastManager.shared.style.titleAlignment = .center
	}
}
