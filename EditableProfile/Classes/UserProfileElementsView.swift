//
//  UserProfileElementsView.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit

final class UserProfileElementsView: UIView {
	
	enum Element {
		typealias TextContent = (text: String?, placeholder: String?)
		
		case profileImage(UIImage?)
		case displayName(TextContent)
		case realName(TextContent)
		case location(TextContent)
		case bDay(TextContent)
		case gender(TextContent)
		case ethnicity(TextContent)
		case religion(TextContent)
		case figure(TextContent)
		case maritalStatus(TextContent)
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
        static let doneButtonSize = CGSize(width: 100, height: 50)
        
        static let containerViewInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		static let verticalSpacing: CGFloat = 20.0
		static let singleChoiceViewHeight: CGFloat = 150.0
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let pictureButton: UserProfilePictureButton = {
		let button = UserProfilePictureButton(target: self, action: #selector(pictureButtonDidTap))
        button.layer.cornerRadius = Constants.pictureButtonSize.width * 0.5
        
        return button
    }()
    private let displayNameField = UserProfileTextField()
    private let realNameField = UserProfileTextField()
    private let locationField = UserProfileTextField()
    private let bDayButton = UserProfileButton(target: self, action: #selector(bDayButtonDidTap))
    private let genderButton = UserProfileButton(target: self, action: #selector(genderButtonDidTap))
    private let maritalStatusButton = UserProfileButton(target: self, action: #selector(maritalStatusButtonDidTap))
    private let ethnicityButton = UserProfileButton(target: self, action: #selector(ethnicityButtonDidTap))
    private let religionButton = UserProfileButton(target: self, action: #selector(religionButtonDidTap))
    private let figureButton = UserProfileButton(target: self, action: #selector(figureButtonDidTap))
    private let heightField = UserProfileTextField()
    private let occupationField = UserProfileTextField()
    private let aboutMeField = UserProfileTextView()
    private let doneButton: UserProfileButton = {
        let button = UserProfileButton(target: self, action: #selector(doneButtonDidTap))
        button.layer.cornerRadius = 8.0
        button.backgroundColor = .blue
        return button
    }()
	private lazy var singlePickerView = SingleChoicePickerView()
	private var singlePickerViewConstraints: [NSLayoutConstraint] = []
    
    private let elementInteractionClosure: (Element) -> Void
    private let singlePickerClosure: (SingleChoicePickerViewChoicable, Element) -> Void
	
	init(elementInteractionClosure: @escaping (Element) -> Void, singlePickerClosure: @escaping (SingleChoicePickerViewChoicable, Element) -> Void) {
        self.elementInteractionClosure = elementInteractionClosure
		self.singlePickerClosure = singlePickerClosure
        super.init(frame: .zero)
        
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        setupLayout()
    }
	
	func updateView(with elements: [Element]) {
		elements.forEach { element in
			switch element {
			case .profileImage(let image): pictureButton.setContent(image)
			case .displayName(let text): displayNameField.setContent(text)
			case .realName(let text): realNameField.setContent(text)
			case .location(let text): locationField.setContent(text)
			case .bDay(let text): bDayButton.setContent(text)
			case .gender(let text): genderButton.setContent(text)
			case .ethnicity(let text): ethnicityButton.setContent(text)
			case .religion(let text): religionButton.setContent(text)
			case .figure(let text): figureButton.setContent(text)
			case .maritalStatus(let text): maritalStatusButton.setContent(text)
			case .height(let text, let isEnabled): heightField.setContent(text)
			case .occupation(let text): occupationField.setContent(text)
			case .aboutMe(let text): aboutMeField.setContent(text)
			case .doneButton(let text): doneButton.setContent(text)
			}
		}
	}
	
	func setupSingleChoicePicker(for element: UserProfileElementsView.Element, with choices: [SingleChoicePickerViewChoicable]) {
		let relatedView = view(for: element)

		setupSinglePickerLayout(with: relatedView)
		singlePickerView.setup(with: choices) { [weak self] choice in
			self?.singlePickerClosure(choice, element)
		}
	}
	
	func dismissSinglePicker() {
		singlePickerView.removeFromSuperview()
		NSLayoutConstraint.deactivate(singlePickerViewConstraints)
		singlePickerViewConstraints = []
	}
}

fileprivate extension UserProfileElementsView {
	
	func view(for element: Element) -> UIView {
		switch element {
		case .profileImage: return pictureButton
		case .displayName: return displayNameField
		case .realName: return realNameField
		case .location: return locationField
		case .bDay: return bDayButton
		case .gender: return genderButton
		case .ethnicity: return ethnicityButton
		case .religion: return religionButton
		case .figure: return figureButton
		case .maritalStatus: return maritalStatusButton
		case .height: return heightField
		case .occupation: return occupationField
		case .aboutMe: return aboutMeField
		case .doneButton: return doneButton
		}
	}
}

// MARK: - button actions

fileprivate extension UserProfileElementsView {
	
	@objc func pictureButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.profileImage(sender.image(for: .normal)))
    }
	
	@objc func bDayButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.bDay((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func genderButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.gender((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func maritalStatusButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.maritalStatus((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func ethnicityButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.ethnicity((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func religionButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.religion((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func figureButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.figure((text: sender.title(for: .normal), placeholder: nil)))
    }
	
	@objc func doneButtonDidTap(_ sender: UserProfileButton) {
		elementInteractionClosure(.doneButton((text: sender.title(for: .normal), placeholder: nil)))
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
}
