//
//  RemoteClassListViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/27.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class RemoteClassListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI(){
        self.view.backgroundColor = .white
        
    }
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return tableView
    }()
}

extension RemoteClassListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        return cell
    }
}
