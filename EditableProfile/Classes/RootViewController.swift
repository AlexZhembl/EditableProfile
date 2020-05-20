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
    func createButtons(register: RootButtonModel, changeProfile: RootButtonModel)
}

final class RootViewController: UIViewController {
    
    private let viewModel: RootViewModel

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Could be in loadView() but does not matter
        viewModel.viewDidLoad()
    }
    
    @objc func registerButtonDidTap() {
        viewModel.registerDidTap()
    }
    
    @objc func changeProfileButtonDidTap() {
        viewModel.editProfileDidTap()
    }
}

extension RootViewController: RootView {
    
    func createButtons(register: RootButtonModel, changeProfile: RootButtonModel) {
        func button(model: RootButtonModel, action: Selector) -> UIView {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(model.title, for: .normal)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: action, for: .touchUpInside)
            button.backgroundColor = UIColor.random
            button.isHidden = model.isHidden
            return button
        }

        let contentView = UIStackView(arrangedSubviews: [button(model: register, action: #selector(registerButtonDidTap)),
                                                         button(model: changeProfile, action: #selector(changeProfileButtonDidTap))])
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

extension UIColor {
    
    static var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
