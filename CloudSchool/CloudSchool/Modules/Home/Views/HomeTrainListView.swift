//
//  HomeTrainListView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class HomeTrainListView: UIView {

    let dataView = BaseClassifyView<TrainListClassifyViewModel>(viewModel: TrainListClassifyViewModel())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func loadData() {
        self.dataView.viewModel.loadData()
        self.dataView.viewModel.showLoadBlock = {
            HUD.loading(text: "")
        }
        self.dataView.viewModel.hideLoadBlock = {
            HUD.hideLoading()
        }
    }
}
