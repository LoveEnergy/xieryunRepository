//
//  CartHelper.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartHelper: NSObject {
    static let shared = CartHelper()
    var selectAll: PublishSubject<Bool> = PublishSubject()
    var refresh: PublishSubject<Void> = PublishSubject()
    var goodsNumber: Variable<Int> = Variable(0)
    
    var finalPrice: Variable<CGFloat> = Variable(0.0)
    var totalPrice: Variable<CGFloat> = Variable(0.0)
    var learnCardAmount: CGFloat = 0.0
    
    var isAllSelected: Variable<Bool> = Variable(false)
    var data: Variable<[CartListModel]> = Variable([])
    var selectedGoods: Variable<[CartGoodsModel]> = Variable([])
    var selectedArray: [CartGoodsModel] {
        var array: [CartGoodsModel] = []
        for item in self.data.value {
            let selectedItems = item.productList.filter { (model) -> Bool in
                return model.isChoosed.value
            }
            array.append(contentsOf: selectedItems)
        }
        return array
    }
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        loadData()
        selectAll.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                if value == true{
                    for item in 0...(self.data.value[0].productList.count - 1) {
                        self.data.value[0].productList[item].isChoosed.value = true
                    }
                }else{
                    for item in 0...(self.data.value[0].productList.count - 1) {
                        self.data.value[0].productList[item].isChoosed.value = false
                    }
                }
                self.updateTotalPrice()
            })
        .disposed(by: disposeBag)
    }
    
    func loadData() {
        UserHelper.shared.getCartList()
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                let number = model.data.reduce(0, { (value, object) -> Int in
                    return value + object.productList.count
                })
//                self.goodsNumber.value = number
                let cartListModelArr = model.data
                if cartListModelArr.count > 0{
                    let tempArr = cartListModelArr[0]
                    let cellModelArr = tempArr.productList
//                    let afterFilterArr = cellModelArr.filter{$0.type == 2 || $0.type == 4}
//                    self.goodsNumber.value = afterFilterArr.count
                    self.goodsNumber.value = cellModelArr.count
                }
                if let object = model.data.first {
                    self.learnCardAmount = object.totalAmount
                }
                self.data.value = model.data
                self.updateTotalPrice()
            })
        .disposed(by: disposeBag)
        
        updateLearnCard()
    }
    
    func updateLearnCard() {
        UserHelper.shared.learnCardAmount()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.learnCardAmount = CGFloat(result.data?.totalAmount ?? 0.0)
            })
            .disposed(by: disposeBag)
    }
    
    func selectGoods(model: CartGoodsModel) {
        var a = self.selectedArray
        var b = self.allGoodsArray()
        
        if a.count == b.count && a.contains(b) {
            isAllSelected.value = true
        } else {
            isAllSelected.value = false
        }
        updateTotalPrice()
    }
    
    func diselectGoods(model: CartGoodsModel) {
        var a = self.selectedArray
        var b = self.allGoodsArray()
        
        if a.count == b.count && a.contains(b) {
            isAllSelected.value = true
        } else {
            isAllSelected.value = false
        }

        updateTotalPrice()
    }
    
    func updateTotalPrice() {
        var sumPrice = selectedArray.reduce(0) { (result, object) -> NSDecimalNumber in
            let objNum = NSDecimalNumber.init(value: object.count)
            let objPrice = NSDecimalNumber.init(floatLiteral: Double(object.price))
            let perTotalMoney = objNum.multiplying(by: objPrice)
            let resultDecimal = result
            let finalResult = resultDecimal.adding(perTotalMoney)
            return finalResult
        }
        let sumPriceString = "\(sumPrice)"
        totalPrice.value = CGFloat(Double(sumPriceString) ?? 0)
        finalPrice.value = CGFloat(Double(sumPriceString) ?? 0)
        print(sumPrice)
    }
    
    class func showCartVC() {
        let vc = R.storyboard.cart.cartViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func allGoodsArray() -> [CartGoodsModel] {
        var allArray: [CartGoodsModel] = []
        for list in self.data.value {
            allArray.append(contentsOf: list.productList)
        }
        return allArray
    }
    
    func deleteAll() {
        let ids = self.selectedArray.map { (model) -> String in
            return model.cardID.string
        }
        guard ids.count > 0 else { return }
        UserHelper.shared.deleteGoods(ids: ids)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.refresh.onNext(())
                
                self.updateTotalPrice()
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
}
