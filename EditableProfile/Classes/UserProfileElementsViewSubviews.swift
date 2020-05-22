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

final class UserProfileButton: UIButton, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent

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
		let title = content.text ?? content.placeholder
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

final class UserProfileTextField: UITextField, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent
    
    override init(frame: CGRect) {
		super.init(frame: frame)
        
		translatesAutoresizingMaskIntoConstraints = false
        layer.shadowRadius = 0.5
        backgroundColor = .white
        layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textColor = .gray
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
    }
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
    
    func setContent(_ content: Content) {
        text = content.text
        placeholder = content.placeholder
    }
}

final class UserProfileTextView: UITextView, UserProfileSubview {
	typealias Content = UserProfileElementsView.Element.TextContent
    
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .white
		layer.shadowRadius = 0.5
		textColor = .gray
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = .zero
		layer.shadowOpacity = 1
		clipsToBounds = false
	}
	
	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
    
    func setContent(_ content: Content) {
        let title = content.text ?? content.placeholder
        text = title
    }
}
