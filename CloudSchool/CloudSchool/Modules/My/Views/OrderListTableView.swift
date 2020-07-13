//
//  OrderListTableView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/14.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

enum OrderType {
    case all
    case unpay
    case payed
    case canceled
    
    var value: String {
        switch self {
        case .all:
            return ""
        case .unpay:
            return "1"
        case .payed:
            return "2"
        case .canceled:
            return "4"
        }
    }
    
}

enum OrderStatus: Int, CustomStringConvertible {
    case unpay = 1
    case payed = 2
    case finished = 3
    case canceled = 4
    
    var description: String {
        switch self {
        case .unpay:
            return "待支付"
        case .payed:
            return "已支付"
        case .finished:
            return "已完成"
        case .canceled:
            return "已取消"
        }
    }
    
    var color: UIColor {
        switch self {
            
        case .unpay:
            return UIColor.mainRedColor
        default:
            return UIColor.subTitleColor
        }
    }
}

class OrderListTableView: UITableView {
    var pageNo: Int = 1
    var reloadBlock: (() -> Void)?
    public var applePayBlock:((Int, String, Int, CGFloat, String)->())?//是否成功的code、返回message、orderID、submitPrice、productName
    public var showHUDViewBlock:(()->())?
    public var collectionViewBlock : ((Int, Int) -> ())?//跳页
    var data: Variable<[OrderModel]> = Variable([])
    var tempArray: [OrderModel] = [OrderModel]()
    let disposeBag: DisposeBag = DisposeBag()
    var type: OrderType = OrderType.all {
        didSet {
            self.loadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseConfigure()
    }
    
    func baseConfigure() {
//        loadData()
        self.emptyDataSetSource = self
        
        self.backgroundColor = UIColor.backgroundColor
        self.register(R.nib.orderTableViewCell)
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = UIColor.backgroundColor
        data.asObservable()
            .bind(to: self.rx.items(cellIdentifier: R.nib.orderTableViewCell.identifier, cellType: OrderTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
                cell.leapPageBlock = {[weak self](orderID, orderStatus)in
                    guard let `self` = self else { return }
                    self.collectionViewBlock?(orderID, orderStatus)
                }
                cell.showHUDViewBlock = {
                    self.showHUDViewBlock!()
                }
                cell.applePayBlock = {(code, message, orderID, submitPrice, productName) in
                    self.applePayBlock!(code, message, orderID, submitPrice, productName)
                }
            }.disposed(by: disposeBag)
        
        self.rx.modelSelected(OrderModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                let vc = R.storyboard.my.orderDetailViewController()!
                vc.orderID = model.orderID
                vc.orderStatus = model.status
                CurrentControllerHelper.pushViewController(viewController: vc)
            })
            .disposed(by: disposeBag)
        
        OrderManager.shared.refreshSignal
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.loadData()
            })
        .disposed(by: disposeBag)
    }
    
    func loadData() {
        self.pageNo = 1
        UserHelper.shared.getOrderList(status: self.type.value, pageNo: 1, pageSize: 10)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
                self.tempArray = list.data?.rows ?? []
                self.reloadBlock?()
                }, onError: { (error) in
                    HUD.showText(text: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore(){
        self.pageNo = self.pageNo + 1
        UserHelper.shared.getOrderList(status: self.type.value, pageNo: self.pageNo, pageSize: 10)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
//            self.data.value = list.data?.rows ?? [] + self.data.value
            self.tempArray = self.tempArray + list.data!.rows
            self.data.value = self.tempArray
            self.reloadBlock?()
            }, onError: { (error) in
                HUD.showText(text: error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
}

extension OrderListTableView: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}
