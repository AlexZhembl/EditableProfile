//
//  RootViewController.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import UIKit

struct RootButtonModel {
    let title: String
    let isHidden: Bool
}

protocol RootView: class {
    func setupButtons(register: RootButtonModel, changeProfile: RootButtonModel)
}

final class RootViewController: UIViewController {
    
    private let viewModel: RootViewModel
	private lazy var registerButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.numberOfLines = 0
		button.titleLabel?.textAlignment = .center
		button.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
		button.backgroundColor = UIColor.random
		button.accessibilityIdentifier = "registerButton"
		return button
	}()
	private lazy var changeProfileButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.numberOfLines = 0
		button.titleLabel?.textAlignment = .center
		button.addTarget(self, action: #selector(changeProfileButtonDidTap), for: .touchUpInside)
		button.backgroundColor = UIColor.random
		button.accessibilityIdentifier = "changeProfileButton"
		return button
	}()

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
       
        // Never use it, otherwise you'll see this file and line in crash log on device
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
		layoutButtons()
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    @objc func registerButtonDidTap() {
        viewModel.registerDidTap()
    }
    
    @objc func changeProfileButtonDidTap() {
        viewModel.editProfileDidTap()
    }
	
	private func layoutButtons() {
		let contentView = UIStackView(arrangedSubviews: [registerButton, changeProfileButton])
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.distribution = .fillEqually
        contentView.axis = .horizontal
        contentView.alignment = .fill
        contentView.spacing = 30.0
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
	}
}

extension RootViewController: RootView {
    
	func setupButtons(register: RootButtonModel, changeProfile: RootButtonModel) {
		registerButton.setTitle(register.title, for: .normal)
		changeProfileButton.setTitle(changeProfile.title, for: .normal)
		
		registerButton.isHidden = register.isHidden
		changeProfileButton.isHidden = changeProfile.isHidden
    }
}

extension UIColor {
    
    static var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
