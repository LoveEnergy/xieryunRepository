//
//  BaseActionSheetView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

protocol BaseActionSheetViewDelegate: class {
    func baseActionSheetDidSelect(index: Int)
}

class BaseActionSheetView: UIView, XibLoadable, Popable {
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var secondActionButton: UIButton!
    @IBOutlet weak var firstActionButton: UIButton!
    
    weak var delegate: BaseActionSheetViewDelegate?
    let disposeBag: DisposeBag = DisposeBag()
    
    var autoDismiss: Bool {
        return true
    }
    
    var title: String? {
        didSet {
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    var actionTitles: [String] = [] {
        didSet {
            if actionTitles.count >= 1 {
                firstActionButton.setTitle(actionTitles[0], for: .normal)
            }
            
            if actionTitles.count >= 2 {
                secondActionButton.setTitle(actionTitles[1], for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        Observable.of(
            (firstActionButton.rx.tap).map{ return 0 },
            (secondActionButton.rx.tap).map{ return 1 }
        )
        .merge()
            .subscribe(onNext: { (index) in
                self.popDismiss()
                self.delegate?.baseActionSheetDidSelect(index: index)
                
            })
            .disposed(by: disposeBag)
    }
    

}
