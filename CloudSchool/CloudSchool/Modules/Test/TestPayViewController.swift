//
//  TestPayViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/2.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import StoreKit
import HXPhotoPicker
import RxSwift
import ObjectMapper
import Rswift

class TestPayViewController: UIViewController, HXPhotoViewDelegate,UIImagePickerControllerDelegate{
    let kPhotoViewMargin: CGFloat = 12.0
    var scrollView: UIScrollView?
    var needDeleteItem: Bool?
    var photoView: HXPhotoView?
    var selectImgList: [HXPhotoModel] = [HXPhotoModel]()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        #if __IPHONE_13_0
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.init(dynamicProvider: { (_ traitcollection) -> UIColor in
                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark{
                    return .black
                }
                return .white
            })
        }
        #endif
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT) - 50))
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        
        let width = scrollView.frame.size.width
        let photoView = HXPhotoView.photoManager(self.manager, scrollDirection: .vertical)
        photoView?.frame = CGRect(x: 0, y: kPhotoViewMargin, width: width, height: 0)
        photoView?.collectionView.contentInset = UIEdgeInsets(top: 0, left: kPhotoViewMargin, bottom: 0, right: kPhotoViewMargin)
        photoView?.delegate = self
        photoView?.outerCamera = true
        photoView?.previewStyle = .dark
        photoView?.showAddCell = true
        photoView?.collectionView.reloadData()
        scrollView.addSubview(photoView!)
        self.photoView = photoView
        
        let cameraItem = UIBarButtonItem.init(title: "设置", style: .plain, target: self, action: #selector(didNavBtnClick))
        self.navigationItem.rightBarButtonItems = [cameraItem]
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.submitBtn)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.changeStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.changeStatus()
    }
    
    func changeStatus(){
        #if __IPHONE_13_0
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == UIUserInterfaceStyle.dark {
                UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
                return
            }
        }
        #endif
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        #if __IPHONE_13_0
        self.preferredStatusBarUpdateAnimation
        self.changeStatus()
        #endif
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        #if __IPHONE_13_0
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == UIUserInterfaceStyle.dark {
                return UIStatusBarStyle.lightContent
            }
        }
        #endif
        return .default
    }
    
    lazy var bottomView : UIButton = {
        var bottomView = UIButton.init(type: .custom)
        bottomView.setTitle("删除", for: .normal)
        bottomView.setTitleColor(.white, for: .normal)
        bottomView.setBackgroundColor(.red, forState: .normal)
        bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 50 - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT), width: SCREEN_WIDTH, height: 50)
        bottomView.alpha = 0
        return bottomView
    }()
    
    
    lazy var submitBtn : UIButton = {
        var submitBtn = UIButton.init(type: .custom)
        submitBtn.setTitle("删除", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setBackgroundColor(.red, forState: .normal)
        submitBtn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 50 - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT), width: SCREEN_WIDTH, height: 50)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        return submitBtn
    }()
    
    lazy var manager: HXPhotoManager = {
        weak var weakSelf = self
        var manager = HXPhotoManager.init(type: HXPhotoManagerSelectedType.photoAndVideo)
        manager?.configuration.lookLivePhoto = true
        manager?.configuration.photoMaxNum = 9
        manager?.configuration.videoMaxNum = 1
        manager?.configuration.maxNum = 9
        manager?.configuration.videoMaximumSelectDuration = 15
        manager?.configuration.videoMinimumSelectDuration = 0
        manager?.configuration.videoMaximumDuration = 15
        manager?.configuration.creationDateSort = false
        manager?.configuration.saveSystemAblum = true
        manager?.configuration.showOriginalBytes = true
        manager?.configuration.selectTogether = false
        manager?.configuration.requestImageAfterFinishingSelection = true
        manager?.configuration.navBarBackgroudColor = UIColor.colorWithHex(hex: "3C83EE")
        manager?.configuration.themeColor = .white
        manager?.configuration.statusBarStyle = .lightContent
        manager?.configuration.navigationTitleColor = .white
        manager?.configuration.cellSelectedBgColor = UIColor.colorWithHex(hex: "3C83EE")
        manager?.configuration.cellSelectedTitleColor = .white
        manager?.configuration.selectedTitleColor = UIColor.colorWithHex(hex: "3C83EE")
        manager?.configuration.navBarTranslucent = false
        manager?.configuration.bottomViewBgColor = UIColor.colorWithHex(hex: "3C83EE")
        manager?.configuration.bottomViewTranslucent = false
        manager?.configuration.selectVideoBeyondTheLimitTimeAutoEdit = true
        manager?.configuration.photoListBottomView = {(bottomView) in
            
        }
        manager?.configuration.previewBottomView = {(bottomView) in
            
        }
        manager?.configuration.shouldUseCamera = {(viewController, cameratype, manager) in
            var imagePickerController = UIImagePickerController.init()
            imagePickerController.delegate = weakSelf as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.allowsEditing = false
            let requiredMediaTypeImage = "\(kUTTypeImage)"
            let requiredMediaTypeMovie = "\(kUTTypeMovie)"
            var arrMediaTypes: [String]?
            if cameratype == HXPhotoConfigurationCameraType.photo{
                arrMediaTypes = [requiredMediaTypeImage]
            }else if cameratype == HXPhotoConfigurationCameraType.video{
                arrMediaTypes = [requiredMediaTypeMovie]
            }else{
                arrMediaTypes = [requiredMediaTypeImage, requiredMediaTypeMovie]
            }
            imagePickerController.mediaTypes = arrMediaTypes ?? []
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.videoMaximumDuration = 60
            imagePickerController.sourceType = .camera
            imagePickerController.navigationController?.navigationBar.tintColor = .white
            imagePickerController.modalPresentationStyle = .currentContext
            viewController?.present(imagePickerController, animated: true, completion: nil)
        }
        return manager!
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true, completion: nil)
        let mediaType = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaType")]
        if "\(String(describing: mediaType))" == kUTTypeImage as String {
            let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as! UIImage
            if self.manager.configuration.saveSystemAblum {
                HXPhotoTools.savePhotoToCustomAlbum(withName: self.manager.configuration.customAlbumName, photo: image, location: nil) { (model, success) in
                    if success{
                        weakSelf?.manager.configuration.useCameraComplete(model)
                    }else{
                        HUD.showText(text: "保存图片失败")
                    }
                }
            }else{
                let model = HXPhotoModel.init(image: image)
                weakSelf?.manager.configuration.useCameraComplete(model)
            }
        }else if "\(String(describing: mediaType))" == kUTTypeMovie as String {
            let url = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as! URL
            if self.manager.configuration.saveSystemAblum {
                HXPhotoTools.saveVideoToCustomAlbum(withName: self.manager.configuration.customAlbumName, videoURL: url, location: nil) { (model, success) in
                    if success{
                        weakSelf?.manager.configuration.useCameraComplete(model)
                    }else{
                        HUD.showText(text: "保存图片失败")
                    }
                }
            }else{
                let model = HXPhotoModel.init(videoURL: url)
                weakSelf?.manager.configuration.useCameraComplete(model)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func didNavBtnClick(){
        
    }
    
    func photoView(_ photoView: HXPhotoView!, changeComplete allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        self.changeStatus()
        self.selectImgList.removeAll()
        self.selectImgList = allList
    }
    
    func photoViewCurrentSelected(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        for photoModel in allList{
            print("当前选择----> \(photoModel.selectIndexStr)")
        }
    }
    
    func photoView(_ photoView: HXPhotoView!, deleteNetworkPhoto networkPhotoUrl: String!) {
        print("\(networkPhotoUrl)")
    }
    
    func photoView(_ photoView: HXPhotoView!, updateFrame frame: CGRect) {
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: frame.size.height + frame.origin.y + kPhotoViewMargin)
    }
    
    func photoViewPreviewDismiss(_ photoView: HXPhotoView!) {
        self.changeStatus()
    }
    
    func photoViewDidCancel(_ photoView: HXPhotoView!) {
        self.changeStatus()
    }
    
    func photoView(_ photoView: HXPhotoView!, currentDelete model: HXPhotoModel!, currentIndex index: Int) {
        print("\(model) --> \(index)")
    }
    
    func photoView(_ photoView: HXPhotoView!, collectionViewShouldSelectItemAt indexPath: IndexPath!, model: HXPhotoModel!) -> Bool {
        return true
    }
    
    func photoViewShouldDeleteCurrentMoveItem(_ photoView: HXPhotoView!, gestureRecognizer longPgr: UILongPressGestureRecognizer!, indexPath: IndexPath!) -> Bool {
        return self.needDeleteItem!
    }
    
    func photoView(_ photoView: HXPhotoView!, gestureRecognizerBegan longPgr: UILongPressGestureRecognizer!, indexPath: IndexPath!) {
        UIView.animate(withDuration: 0.25) {
            self.bottomView.alpha = 0.5
        }
        print("长按手势开始了 - \(indexPath.item)")
    }
    
    func photoView(_ photoView: HXPhotoView!, gestureRecognizerChange longPgr: UILongPressGestureRecognizer!, indexPath: IndexPath!) {
        var point = longPgr.location(in: self.view)
        if point.y >= self.bottomView.top {
            UIView.animate(withDuration: 0.25) {
                self.bottomView.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.25) {
                self.bottomView.alpha = 0.5
            }
        }
//        print("长按手势改变了 \(nsstringfrompoint) - \(indexPath.item)")
    }
    
    func photoView(_ photoView: HXPhotoView!, gestureRecognizerEnded longPgr: UILongPressGestureRecognizer!, indexPath: IndexPath!) {
        let point = longPgr.location(in: self.view)
        if point.y >= self.bottomView.top {
            self.needDeleteItem = true
            self.photoView?.deleteModel(with: indexPath.item)
        }else{
            self.needDeleteItem = false
        }
        UIView.animate(withDuration: 0.25) {
            self.bottomView.alpha = 0
        }
        print("长按手势结束了 - \(indexPath.item)")
    }
    
    @objc func submitBtnClick(){
        var imagesArr: [UIImage] = [UIImage]()
        for item in self.selectImgList {
            imagesArr.append(item.previewPhoto!)
        }
        RequestHelper.shared.moreImageUpLoad(images: imagesArr, kind: 1).asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            
        }).disposed(by: disposeBag)
    }
}
