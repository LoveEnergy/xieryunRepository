//
//  RechargeViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/5/12.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RechargeViewController: UIViewController {

    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [RegisteredPurchase] = [.virtual8]
    let disposeBag: DisposeBag = DisposeBag()
    
    var selectedData: RegisteredPurchase = .virtual8 {
        didSet {
            self.collectionView.reloadData()
            self.priceLabel.text = "¥ \(selectedData.price)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "学点充值"
        
        collectionView.register(R.nib.rechargeCollectionViewCell)
        collectionView.delegate = self
        collectionView.dataSource = self
//        IAPHandler.shared.purchase(.study6, atomically: true)
//        IAPHandler.shared.purchaseStatusBlock = { status in
//            
//        }
        // Do any additional setup after loading the view.
        rechargeButton.addTarget(self, action: #selector(rechargeButtonClick), for: .touchUpInside)
    }
    
    @objc func rechargeButtonClick() {
        HUD.loading(text: "")
        RequestHelper.shared.getIAPOrder(money: selectedData.price, orderID: 3000)
        .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                result.errorDeal {
                    IAPHandler.shared.purchase(self.selectedData, atomically: true)
                    IAPHandler.shared.purchaseStatusBlock = { status in
                        HUD.hideLoading()
                    }
                }
            })
        .disposed(by: disposeBag)
    }
}

extension RechargeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.rechargeCollectionViewCell, for: indexPath)!
        
        let model = data[indexPath.row]
        cell.configure(model: model)
        cell.beSelected = selectedData == model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 13)/3.0
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedData = data[indexPath.row]
    }
    
    
}
