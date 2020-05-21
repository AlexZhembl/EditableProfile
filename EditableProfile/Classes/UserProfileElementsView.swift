//
//  UserProfileElementsView.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit

final class UserProfileElementsView: UIView {
    
    struct Model {
        typealias Content = (text: String?, placeholder: String)
        
        let profileImage: UIImage?
        let displayName: Content
        let realName: Content
        let location: Content
        let bDay: Content
        let gender: Content
        let ethnicity: Content
        let religion: Content
        let figure: Content
        let maritalStatus: Content
        let height: Content
        let occupation: Content
        let aboutMe: Content
        let doneButtonText: String
    }
    
    private enum Constants {
        static let pictureButtonSize = CGSize(width: 70, height: 70)
        static let singleLineFiledHeight: CGFloat = 50.0
        static let singleChoiceButtonHeight: CGFloat = 50.0
        static let aboutMeViewHeight: CGFloat = 140.0
        static let doneButtonSize = CGSize(width: 100, height: 50)
        
        static let containerViewInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        static let verticalSpacing: CGFloat = 20.0
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
    private let pictureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.pictureButtonSize.width * 0.5
        button.clipsToBounds = true
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(pictureButtonDidTap), for: .touchUpInside)
        return button
    }()
    private let displayNameField = UITextField.singleLineTextField()
    private let realNameField = UITextField.singleLineTextField()
    private let locationField = UITextField.singleLineTextField()
    private let bDayButton = UIButton.singleChoiceButton()
    private let genderButton = UIButton.singleChoiceButton()
    private let maritalStatusButton = UIButton.singleChoiceButton()
    private let ethnicityButton = UIButton.singleChoiceButton()
    private let religionButton = UIButton.singleChoiceButton()
    private let figureButton = UIButton.singleChoiceButton()
    private let heightField = UITextField.singleLineTextField()
    private let occupationField = UITextField.singleLineTextField()
    private let aboutMeField = UITextView.configuredTextView()
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        button.backgroundColor = .blue
        return button
    }()
    
    private let pictureButtonAction: () -> Void
    
    init(pictureButtonAction: @escaping () -> Void) {
        self.pictureButtonAction = pictureButtonAction
        super.init(frame: .zero)
        
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        setupLayout()
    }
    
    func setup(with model: Model) {
        let profileImage = model.profileImage == nil ? UIImage(named: "default_profile") : model.profileImage
        pictureButton.setImage(profileImage, for: .normal)
        
        displayNameField.setContent(model.displayName)
        realNameField.setContent(model.realName)
        locationField.setContent(model.location)
        bDayButton.setContent(model.bDay)
        genderButton.setContent(model.gender)
        maritalStatusButton.setContent(model.maritalStatus)
        ethnicityButton.setContent(model.ethnicity)
        religionButton.setContent(model.religion)
        figureButton.setContent(model.figure)
        heightField.setContent(model.height)
        occupationField.setContent(model.occupation)
        aboutMeField.setContent(model.aboutMe)
    }
    
    @objc func pictureButtonDidTap() {
        pictureButtonAction()
    }
}

// MARK: - private extension for initializing elements

fileprivate extension UIButton {
    
    static func singleChoiceButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowRadius = 0.5
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.setImage(UIImage(named: "button_arrow"), for: .normal)
        button.titleLabel?.textAlignment = .left
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        return button
    }
    
    func setContent(_ content: UserProfileElementsView.Model.Content) {
        let title = content.text == nil ? content.placeholder : content.text
        setTitle(title, for: .normal)
    }
}

fileprivate extension UITextField {
    
    static func singleLineTextField() -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.shadowRadius = 0.5
        field.backgroundColor = .white
        field.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        field.textColor = .gray
        field.layer.shadowColor = UIColor.black.cgColor
        field.layer.shadowOffset = .zero
        field.layer.shadowOpacity = 1
        return field
    }
    
    func setContent(_ content: UserProfileElementsView.Model.Content) {
        text = content.text
        placeholder = content.placeholder
    }
}

fileprivate extension UITextView {
    
    static func configuredTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.shadowRadius = 0.5
        textView.textColor = .gray
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = .zero
        textView.layer.shadowOpacity = 1
        textView.clipsToBounds = false
        return textView
    }
    
    func setContent(_ content: UserProfileElementsView.Model.Content) {
        let title = content.text == nil ? content.placeholder : content.text
        text = title
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
}
