//
//  SearchViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var hotTagsView: TTGTextTagCollectionView!
    @IBOutlet weak var historyTagsView: TTGTextTagCollectionView!
    override var hideNavigationBar: Bool { return true }
    override var backgroundColor: UIColor { return .white }
    
    @IBOutlet weak var hotView: UIView!
    @IBOutlet weak var historyView: UIView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reload()
        loadData()
        
        clearButton.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
    }

    func configureUI() {
        let configure = TTGTextTagConfig()
        configure.backgroundColor = UIColor.rgb(r: 31, g: 162, b: 248, a: 0.1)
        configure.selectedTextColor = UIColor.titleColor
        configure.selectedBackgroundColor = UIColor.rgb(r: 31, g: 162, b: 248, a: 0.1)
        configure.borderWidth = 0.5
        configure.textColor = UIColor(hex: "555555")
        configure.borderColor = UIColor.mainBlueColor
        configure.selectedBorderColor = UIColor.mainBlueColor
        configure.shadowColor = UIColor.clear
        configure.textFont = UIFont.systemFont(ofSize: 14)
        configure.extraSpace = CGSize(width: 24, height: 10)
        hotTagsView.defaultConfig = configure
        hotTagsView.backgroundColor = UIColor.clear
        historyTagsView.defaultConfig = configure
    
        
        hotTagsView.delegate = self
        hotTagsView.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        historyTagsView.delegate = self
        historyTagsView.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        
    }
    
    @objc func clearClick() {
        SearchHelper.clear()
        reload()
    }
    
    func reload() {
        historyTagsView.removeAllTags()
        let histories = SearchHelper.histories()
        if histories.count <= 0 {
            historyView.isHidden = true
        } else {
            historyView.isHidden = false
        }
        historyTagsView.addTags(histories)
    }
    
    func loadData() {
        HUD.loading(text: "")
        RequestHelper.shared.hotSearch()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.hotTagsView.removeAllTags()
                self.hotTagsView.addTags(list)
            })
        .disposed(by: disposeBag)
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        self.searchTextField.text = tagText
        self.startSearch(text: tagText)
    }
    
    func startSearch(text: String) {
        SearchHelper.addWord(text)
        let vc = BaseListViewController<SearchListViewModel>.init(viewModel: SearchListViewModel(name: text))
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = searchTextField.text?.emptyToNil() {
            self.startSearch(text: text)
        }
        reload()
        textField.resignFirstResponder()
        return true
    }
}
