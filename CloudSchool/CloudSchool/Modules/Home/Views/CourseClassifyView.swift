//
//  CourseClassifyView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/13.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class CourseClassifyView: UIView {
    
    var scrollView: UIScrollView = UIScrollView()
    
    var indexSignal: Variable<Int> = Variable(0)
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.classify_more_arrow(), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var currentIndex: Int? {
        didSet {
            for (index, view) in self.stackViw.arrangedSubviews.enumerated() {
                if let button = view as? UIButton {
                    if index == currentIndex {
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
                        button.isSelected = true
                        var offsetX = (button.frame.midX - self.width/2)
                        offsetX = min(scrollView.contentSize.width - self.width, offsetX)
                        offsetX = max(offsetX, 0)
                        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
                    } else {
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                        button.isSelected = false
                    }
                    
                }
            }
            indexSignal.value = currentIndex ?? 0
        }
    }
    
    var stackViw: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    var data: [SeriesInfo] = [] {
        didSet {
            if self.stackViw.arrangedSubviews.count == 0 {
                for view in stackViw.arrangedSubviews {
                    view.isHidden = true
                    stackViw.removeArrangedSubview(view)
                }
                for (index, item) in data.enumerated() {
                    let button = self.getButton(title: item.seriesName)
                    button.tag = index
                    button.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
                    stackViw.addArrangedSubview(button)
                }
            }
            if currentIndex == nil {
                currentIndex = 0
            }else{
                let tempIndex = currentIndex!
                currentIndex = tempIndex
            }
//            currentIndex = 0
        }
    }
    
    @objc func buttonClick(sender: UIButton) {
        let index = sender.tag
        currentIndex = index
    }
    
    @objc func clickMore() {
        if self.data.count > currentIndex ?? 0 {
            let model = self.data[currentIndex ?? 0]
            model.openMore()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(scrollView)
        addSubview(moreButton)
        scrollView.addSubview(stackViw)
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 60)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        stackViw.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
        }
        moreButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(60)
        }
    }
    
    func getButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.titleColor, for: .normal)
        button.setTitleColor(UIColor.colorWithHex(hex: "#666666"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }

}
