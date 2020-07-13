
//
//  AvatorViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class AvatorViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BaseActionSheetViewDelegate {
    var avator: Variable<UIImage> = Variable(R.image.my_head()!)
    let disposeBag = DisposeBag()
    override init() {
        super.init()
        if let user = LoginHelper.shared.currentUser.value, let url = URL(string: user.headUrl) {
            KingfisherManager.shared.downloader.downloadImage(with: url, retrieveImageTask: nil, options: nil, progressBlock: nil) {[weak self] (image, error, url, data) in
                guard let `self` = self else { return }
                if let image = image {
                    self.avator.value = image
                }
            }
        }
        
    }
    
    func clickToChange() {
//        
        let action = BaseActionSheetView.loadXib()
        action.title = "设置头像"
        action.actionTitles = ["拍照", "从手机相册选择"]
        action.delegate = self
        action.popShow()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.avator.value = image
            RequestHelper.shared.uploadImage(image: image, type: 1)
            .asObservable()
                .subscribe(onNext: {[weak self] (model) in
                    guard let `self` = self else { return }
                    guard let data = model.data else { return }
                    self.updateAvator(data.headerUrl)
                })
            .disposed(by: disposeBag)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateAvator(_ url: String) {
        UserHelper.shared.updateUserInfo(dic: ["headUrl": url])
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                LoginHelper.shared.updateUserInfo()
            })
        .disposed(by: disposeBag)
        
    }
    
    func baseActionSheetDidSelect(index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        switch index {
        case 0:
            imagePicker.sourceType = .camera
        case 1:
            imagePicker.sourceType = .photoLibrary
        default:
            break
        }
        CurrentControllerHelper.presentViewController(viewController: imagePicker)
    }
    
    
    
    
}
