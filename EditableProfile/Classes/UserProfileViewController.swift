//
//  UserProfileViewController.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit

protocol UserProfileView: class {
	typealias Element = UserProfileElementsView.Element
	
	func updateElementsView(with elements: [Element])
	func showSingleChoicePicker(for element: Element, with choices: [SingleChoicePickerViewChoicable])
	func dismissSinglePicker()
	func showError(for element: Element, error: String)
}

final class UserProfileViewController: UIViewController {
    
    private let viewModel: UserProfileViewModel
    private lazy var elementsView: UserProfileElementsView = {
		let elementsView = UserProfileElementsView(elementInteractionClosure: { [weak self] element, value in
				self?.viewModel.didInteractElement(element, value: value)
			},
			singlePickerClosure: { [weak self] choice, element in
				self?.viewModel.singleChoicePickerDidSelect(choice, for: element)
		})
        elementsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(elementsView)
        NSLayoutConstraint.activate([
            elementsView.topAnchor.constraint(equalTo: view.topAnchor),
            elementsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            elementsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            elementsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return elementsView
    }()

    init(viewModel: UserProfileViewModel) {
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
}

extension UserProfileViewController: UserProfileView {
	func updateElementsView(with elements: [Element]) {
		elementsView.updateView(with: elements)
	}
	
	func showSingleChoicePicker(for element: Element, with choices: [SingleChoicePickerViewChoicable]) {
		elementsView.setupSingleChoicePicker(for: element, with: choices)
	}
	
	func dismissSinglePicker() {
		elementsView.dismissSinglePicker()
	}
	
	func showError(for element: Element, error: String) {
		elementsView.showError(for: element, error: error)
	}
}
