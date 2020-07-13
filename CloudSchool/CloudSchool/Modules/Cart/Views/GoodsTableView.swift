//
//  GoodsTableView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/28.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class GoodsTableView: UITableView {
    var fromPageName: String = ""
    
    var data: [CartGoodsModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        self.delegate = self
        self.dataSource = self
        self.register(R.nib.cartTableViewCell)
        self.rowHeight = 160
        self.tableFooterView = UIView()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension GoodsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.cartTableViewCell, for: indexPath)!
        cell.canEdit = false
        cell.fromPageName = self.fromPageName
        cell.configure(model: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
