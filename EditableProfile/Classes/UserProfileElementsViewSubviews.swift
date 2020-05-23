//
//  UserProfileElementsViewSubviews.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import UIKit

protocol UserProfileSubview {
	associatedtype Content
	
	func setContent(_ content: Content)
}

// MARK: - Buttons

final class UserProfileAttributesButton: UIButton, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.AttributesContent

	init(target: Any?, action: Selector) {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
        layer.shadowRadius = 0.5
        backgroundColor = .white
        setTitleColor(.gray, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        setImage(UIImage(named: "button_arrow"), for: .normal)
        titleLabel?.textAlignment = .left
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
		addTarget(target, action: action, for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
    func setContent(_ content: Content) {
		let title = content?.attr?.name ?? content?.placeholder
        setTitle(title, for: .normal)
    }
}

final class UserProfileTextButton: UIButton, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent

	init(target: Any?, action: Selector) {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8.0
		backgroundColor = UIColor.blue.withAlphaComponent(0.4)
		addTarget(target, action: action, for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
    func setContent(_ content: Content) {
		let title = content?.text ?? content?.placeholder
        setTitle(title, for: .normal)
    }
}

final class UserProfilePictureButton: UIButton, UserProfileSubview {
	typealias Content = UIImage?
	
	init(target: Any?, action: Selector) {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		addTarget(target, action: action, for: .touchUpInside)
		clipsToBounds = true
        layer.borderWidth = 0.5
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	func setContent(_ content: Content) {
		let image = content ?? UIImage(named: "default_profile")
		setImage(image, for: .normal)
    }
}

final class UserProfileDateButton: UIButton, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.DateContent
	
	init(target: Any?, action: Selector) {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
        layer.shadowRadius = 0.5
        backgroundColor = .white
        setTitleColor(.gray, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        setImage(UIImage(named: "button_arrow"), for: .normal)
        titleLabel?.textAlignment = .left
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
		addTarget(target, action: action, for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	func setContent(_ content: Content) {
		let title: String?
		if let date = content?.date {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			title = dateFormatter.string(from: date)
		}
		else {
			title = content?.placeholder
		}
		setTitle(title, for: .normal)
    }
}

// MARK: - TextFields

final class UserProfileTextField: UITextField, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent
    
	init(delegate: UITextFieldDelegate) {
		super.init(frame: .zero)
        
		translatesAutoresizingMaskIntoConstraints = false
        layer.shadowRadius = 0.5
        backgroundColor = .white
        layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textColor = .gray
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
		returnKeyType = .done
		self.delegate = delegate
    }
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
    
    func setContent(_ content: Content) {
        text = content?.text
        placeholder = content?.placeholder
    }
}

final class UserProfileLocationField: UITextField, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.LocationContent
    
	init(delegate: UITextFieldDelegate) {
		super.init(frame: .zero)
        
		translatesAutoresizingMaskIntoConstraints = false
        layer.shadowRadius = 0.5
        backgroundColor = .white
        layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textColor = .gray
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
		returnKeyType = .done
		self.delegate = delegate
    }
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
    
    func setContent(_ content: Content) {
		text = content?.loc?.city
        placeholder = content?.placeholder
    }
}

final class UserProfileTextView: UITextView, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent
    
	init(delegate: UITextViewDelegate) {
		super.init(frame: .zero, textContainer: nil)
		
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .white
		layer.shadowRadius = 0.5
		textColor = .gray
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = .zero
		layer.shadowOpacity = 1
		clipsToBounds = false
		returnKeyType = .done
		self.delegate = delegate
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
    
    func setContent(_ content: Content) {
        let title = content?.text ?? content?.placeholder
        text = title
    }
}
