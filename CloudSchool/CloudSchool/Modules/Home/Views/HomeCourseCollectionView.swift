//
//  HomeCourseCollectionView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/13.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class HomeCourseCollectionView: UICollectionView ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var data: [CourseModel] = [] {
        didSet {
//            data = data.sorted(by: { (value1, value2) -> Bool in
//                return value1
//            })
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseConfigure()
    }
    
    func baseConfigure() {
        self.register(R.nib.courseCollectionViewCell)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.courseCollectionViewCell, for: indexPath)!
        let model = data[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        let vc = R.storyboard.home.courseDetailViewController()!
        vc.productID = model.productID.toString()
        vc.productType = model.productType
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth-30)/2.0, height: 200)
    }
    
    
    func clickMore(section: HomeListSection) {
//        section.openMore()
    }

    

}
