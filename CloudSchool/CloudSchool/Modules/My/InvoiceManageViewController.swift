//
//  InvoiceManageViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvoiceManageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: BaseButton!
    var viewModel: InvoiceListViewModel = InvoiceListViewModel()
    let disposeBag = DisposeBag()
    var selectedInvoice: Variable<InvoiceInfoModel?> = Variable(nil)
    var lastVc : UIViewController = UIViewController()//push过来的控制器
//    var taxPaperNum : Int = 0
//    var taxPaperArray : [InvoiceInfoModel] = [InvoiceInfoModel]()
    var taxPaperArray: [Int] = [Int]()
    var taxPaperNum : Int = 0
    public var invoiceArrayNumBlock:((Int)->())?//发票数量
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.register(R.nib.invoiceInfoTableViewCell)
        
        viewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.invoiceInfoTableViewCell.identifier, cellType: InvoiceInfoTableViewCell.self)) { _, model, cell in cell.configure(model: model)
            cell.delegate = self
            self.taxPaperArray.append(model.invoiceID)
            let filterArrays = self.taxPaperArray.filterDuplicates({$0})
            self.taxPaperNum = filterArrays.count
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(InvoiceInfoModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.selectedInvoice.value = model
            })
            .disposed(by: disposeBag)
        
        addButton.addTarget(self, action: #selector(showAddVC), for: .touchUpInside)
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 15/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
        leftBtn.adjustsImageWhenHighlighted = false
        let image = R.image.ic_back()?.withRenderingMode(.alwaysOriginal)
        leftBtn.setBackgroundImage(image, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftReturnAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        
        
    }
    
    @objc func showAddVC() {
//        let vc = R.storyboard.my.addInVoidceViewController()!
//        CurrentControllerHelper.pushViewController(viewController: vc)
        let vc = SelectInvoiceTypeViewController.init()
        vc.title = "发票填写"
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func configureUI() {
        title = viewModel.title
        tableView.backgroundColor = viewModel.backgroudColor
        view.backgroundColor = viewModel.backgroudColor
        tableView.emptyDataSetSource = self
    }
    
    @objc func leftReturnAction(){
        let vcArray = self.navigationController?.viewControllers
        let vcCount = vcArray?.count
        if vcCount! > 2 {
            self.lastVc = vcArray![vcCount! - 2]
            if self.lastVc.isKind(of: ConfirmOrderViewController.self) {
                self.invoiceArrayNumBlock!(self.taxPaperNum)
            }
        }
        self.navigationController?.popViewController()
    }

}

extension InvoiceManageViewController: InvoiceInfoTableViewCellDelegate {
    func editInvoice(model: InvoiceInfoModel) {
        viewModel.editInvoice(model: model)
    }
    
    func deleteInvoice(model: InvoiceInfoModel) {
        viewModel.deleteInvoice(model: model)
        self.taxPaperNum = self.taxPaperNum - 1
    }
    
    
}

import DZNEmptyDataSet
extension InvoiceManageViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}

