//
//  SingleChoicePickerView.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import UIKit

// MARK: - UIView used for presenting single choice values like gender, date, ...

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
		tableView.layer.borderWidth = 1.0
		tableView.backgroundColor = backgroundColor
        return tableView
    }()
	private lazy var datePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.datePickerMode = .date
		return datePicker
	}()
	private lazy var datePickerDoneButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle("Choose date", for: .normal)
		button.layer.borderWidth = 0.5
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(datePickerDoneDidTap), for: .touchUpInside)
		button.accessibilityIdentifier = "datePickerDoneButton"
		return button
	}()
	private var choices: [SingleChoicePickerViewChoicable] = []
    private var choiceClosure: ((SingleChoicePickerViewChoicable) -> Void)?
	private var dateClosure: ((Date) -> Void)?
    
	override init(frame: CGRect) {
        super.init(frame: frame)
        
		backgroundColor = UIColor(red: 0.85, green: 0.9, blue: 1.0, alpha: 1.0)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
	func setup(with choices: [SingleChoicePickerViewChoicable], choiceClosure: @escaping (SingleChoicePickerViewChoicable) -> Void) {
		self.choiceClosure = choiceClosure
		self.choices = choices
		tableView.isHidden = false
		datePicker.isHidden = true
		datePickerDoneButton.isHidden = true
		tableView.contentOffset = .zero
		tableView.reloadData()
	}
	
	func setupForDate(dateClosure: @escaping (Date) -> Void) {
		self.dateClosure = dateClosure
		tableView.isHidden = true
		datePicker.isHidden = false
		datePickerDoneButton.isHidden = false
		datePicker.setDate(Date(), animated: false)
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
		
		addSubview(datePickerDoneButton)
		addSubview(datePicker)
		NSLayoutConstraint.activate([
			datePickerDoneButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			datePickerDoneButton.topAnchor.constraint(equalTo: topAnchor),
			datePickerDoneButton.heightAnchor.constraint(equalToConstant: 44),
			
			datePicker.topAnchor.constraint(equalTo: datePickerDoneButton.bottomAnchor),
			datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
			datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
			datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
    }
	
	@objc func datePickerDoneDidTap() {
		dateClosure?(datePicker.date)
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

		cell.backgroundColor = tableView.backgroundColor
		cell.textLabel?.text = choice.title
		cell.accessibilityIdentifier = "SingleChoicePickerViewCell"
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
