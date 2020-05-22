//
//  SingleChoicePickerView.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import UIKit

protocol SingleChoicePickerViewChoicable {
	var title: String { get }
	var uid: String { get }
}

class SingleChoicePickerView: UIView {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
		tableView.backgroundColor = UIColor(red: 0.85, green: 0.9, blue: 1.0, alpha: 1.0)
		tableView.layer.borderWidth = 1.0
        return tableView
    }()
	private var choices: [SingleChoicePickerViewChoicable] = []
    private var choiceClosure: ((SingleChoicePickerViewChoicable) -> Void)?
    
	override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
	func setup(with choices: [SingleChoicePickerViewChoicable], choiceClosure: @escaping (SingleChoicePickerViewChoicable) -> Void) {
		self.choiceClosure = choiceClosure
		self.choices = choices
		tableView.contentOffset = .zero
		tableView.reloadData()
	}
    
    private func setupLayout() {
		translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension SingleChoicePickerView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return choices.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
		guard let choice = choices[safe: indexPath.row] else {
			assertionFailure("Coulnd not find choice")
			return cell
		}

		cell.textLabel?.text = choice.title
		cell.backgroundColor = tableView.backgroundColor
		return cell
	}
}

extension SingleChoicePickerView: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let choice = choices[safe: indexPath.row] else {
			assertionFailure("Coulnd not find choice")
			return
		}
		choiceClosure?(choice)
	}
}

fileprivate extension Array {
	subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
