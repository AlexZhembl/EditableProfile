//
//  ImagePicker.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit

protocol ImagePicker {
    func showPicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void)
}

final class ImagePickerImpl: NSObject, ImagePicker, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    private var pickerCompletion: ((UIImage?) -> Void)?

    func showPicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        pickerCompletion = completion
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        UIImagePickerController.SourceType.allCases
            .filter { UIImagePickerController.isSourceTypeAvailable($0) }
            .map { type in
                return UIAlertAction(title: type.title, style: .default) { [weak viewController] _ in
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.mediaTypes = ["public.image"]
                    picker.sourceType = type
                    viewController?.present(picker, animated: true)
                }
            }
        .forEach { alertController.addAction($0) }
            
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.pickerController(nil, didSelect: nil)
        })

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = viewController.view
            alertController.popoverPresentationController?.sourceRect = viewController.view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        viewController.present(alertController, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        pickerController(picker, didSelect: info[.editedImage] as? UIImage)
    }
    
    private func pickerController(_ controller: UIImagePickerController?, didSelect image: UIImage?) {
        controller?.dismiss(animated: true, completion: nil)

        if let completion = pickerCompletion {
            completion(image)
            pickerCompletion = nil
        }
    }
}

extension UIImagePickerController.SourceType: CaseIterable {
    public typealias AllCases = [UIImagePickerController.SourceType]
    
    public static var allCases: AllCases = [.camera, .savedPhotosAlbum, .photoLibrary]
    
    var title: String {
        switch self {
        case .camera: return "Camera"
        case .savedPhotosAlbum: return "Saved photos album"
        case .photoLibrary: return "Photo library"
        @unknown default:
            preconditionFailure("Undefined enum falue")
        }
    }
}
