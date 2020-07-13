//
//  VerifyPhoneViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyPhoneViewController: UIViewController {

    @IBOutlet weak var phoneTextField: BaseTextField!
    @IBOutlet weak var passwordTextField: BaseTextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var nextButton: BaseButton!
    
    
    let disposeBag = DisposeBag()
    
    override var backgroundColor: UIColor { return .white }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bind() {
        
    }
    
}
