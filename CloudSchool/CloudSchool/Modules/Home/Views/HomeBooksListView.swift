//
//  HomeBooksListView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class HomeBooksListView: UIView {
    
    let dataView = BaseClassifyView<BookListClassifyViewModel>(viewModel: BookListClassifyViewModel())
    
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

