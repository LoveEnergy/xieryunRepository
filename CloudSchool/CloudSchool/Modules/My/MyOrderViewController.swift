//
//  MyOrderViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import Segmentio
import RxSwift

class MyOrderViewController: UIViewController, NetServiceDelegate {
    
    public var showMessageBlock:((Int, String, Int, CGFloat, String)->())?//是否成功的code、返回message、orderID
    public var showHUDBlock:(()->())?
    
    @IBOutlet weak var orderSegmentView: Segmentio!
    
    @IBOutlet weak var scrollView: NestedListView!
    var data: Variable<[String]> = Variable(["", "", "", ""])
    let disposeBag: DisposeBag = DisposeBag()
    
    var currentIndex: Int = 0 {
        didSet {
            self.orderSegmentView.selectedSegmentioIndex = currentIndex
            self.scrollView.scrollToPage(currentIndex)
            self.scrollView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func configureUI() {
        title = "订单列表"
        scrollView.nestDelegate = self
        scrollView.totalPage = 4
        scrollView.scrollToPage(0)
        scrollView.changedPage = { index in
            self.currentIndex = index
        }

        self.view.backgroundColor = UIColor.backgroundColor
        orderSegmentView.setup(content: [SegmentioItem(title: "全部订单", image: nil),
                                         SegmentioItem(title: "待支付", image: nil),
                                         SegmentioItem(title: "已支付", image: nil),
                                         SegmentioItem(title: "已失效", image: nil),
                                         ], style: SegmentioStyle.onlyLabel, options: orderSegmentView.defaultOption)
        orderSegmentView.selectedSegmentioIndex = 0
        orderSegmentView.valueDidChange = { (seg, index) in
            self.currentIndex = index
        }
        
        self.showMessageBlock = {(code, message, order, submitPrice, productName) in
            HUD.hideLoading()
            if code == 200 {
//                OrderManager.shared.refreshSignal.onNext(())
                let vc = PaySuccessViewController.init()
                vc.orderID = "\(order)"
                vc.productType = 1
                vc.objectType = 0
                vc.submitPrice = submitPrice
                vc.productName = productName
                CurrentControllerHelper.pushViewController(viewController: vc)
            }else if code == 0{
                
            }else{
                HUD.showText(text: message)
            }
        }
        self.showHUDBlock = {
            HUD.loading(text: "")
        }
    }
}

extension MyOrderViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        
        let tableView = OrderListTableView.init(frame: CGRect.zero, style: .plain)
        tableView.applePayBlock = {(code, message, orderID, submitPrice, productName) in
            self.showMessageBlock!(code, message, orderID, submitPrice, productName)
        }
        tableView.showHUDViewBlock = {
            self.showHUDBlock!()
        }
        tableView.addRefreshHeader {
            tableView.loadData()
        }
        tableView.addRefreshFooter {
            tableView.loadMore()
        }
        tableView.reloadBlock = {
            tableView.endRefresh()
        }
        
        switch page {
        case 0:
            tableView.type = .all
        case 1:
            tableView.type = .unpay
        case 2:
            tableView.type = .payed
        case 3:
            tableView.type = .canceled
        default:
            break
        }
        tableView.collectionViewBlock = {[weak self](orderID, orderStatus)in
            guard let `self` = self else { return }
            let vc = R.storyboard.my.orderDetailViewController()!
            vc.orderID = orderID
            vc.orderStatus = orderStatus
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        return tableView
    }
}
