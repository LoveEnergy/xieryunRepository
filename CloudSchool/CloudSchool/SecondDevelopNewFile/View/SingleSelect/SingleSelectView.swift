//
//  SingleSelectView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/14.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SingleSelectView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    var selectString: String?
    var array: [String] = [String]()
    var selectRow: Int = 0
    var industryPositionArray: [IndustryPositionDetailModel] = [IndustryPositionDetailModel]()
    var jobPositionArray: [JobPositionDetailModel] = [JobPositionDetailModel]()
    public var singleSelectViewDismissBlock:(()->())?//消失
    public var selectStringBlock:((String)->())?
    public var selectIndustryPositionBlock:((IndustryPositionDetailModel)->())?
    public var selectJobPositionBlock:((JobPositionDetailModel)->())?
    lazy var whiteBGView : UIView = {
        var whiteBGView = UIView.init()
        whiteBGView.backgroundColor = .white
        return whiteBGView
    }()
    lazy var sureBtn : UIButton = {
        var sureBtn = UIButton.init()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_15
        sureBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        sureBtn.setBackgroundColor(.clear, forState: .normal)
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.masksToBounds = true
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    lazy var cancelBtn : UIButton = {
        var cancelBtn = UIButton.init()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = DEF_FontSize_15
        cancelBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        cancelBtn.setBackgroundColor(.clear, forState: .normal)
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.masksToBounds = true
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelBtn
    }()
    lazy var pickerView: UIPickerView = {
        var pickerView = UIPickerView.init()
        pickerView.backgroundColor = .clear;
        pickerView.showsSelectionIndicator = true;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    func setUpUI(){
        let btn = UIButton.init(frame: self.bounds)
        self.addSubview(btn)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        
        self.whiteBGView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 190/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 190/WIDTH_6_SCALE)
        self.addSubview(self.whiteBGView)

        let topLineView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.5/WIDTH_6_SCALE))
        topLineView.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
        whiteBGView.addSubview(topLineView)

        self.sureBtn.frame = CGRect(x: 20/WIDTH_6_SCALE, y: 0, width: 56/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        whiteBGView.addSubview(self.sureBtn)

        self.cancelBtn.frame = CGRect(x: SCREEN_WIDTH - 20/WIDTH_6_SCALE - 56/WIDTH_6_SCALE, y: 0, width: 56/WIDTH_6_SCALE, height: self.sureBtn.height)
        whiteBGView.addSubview(self.cancelBtn)

        let bottomLineView = UIView.init(frame: CGRect(x: 0, y: cancelBtn.bottom, width: SCREEN_WIDTH, height: 0.5/WIDTH_6_SCALE))
        bottomLineView.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
        whiteBGView.addSubview(bottomLineView)

        self.pickerView.frame = CGRect(x: 0, y: 40/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 150/WIDTH_6_SCALE)
        whiteBGView.addSubview(pickerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.array.count
        if self.array.count > 0 {
            return self.array.count
        }
        if self.industryPositionArray.count > 0 {
            return self.industryPositionArray.count
        }
        if self.jobPositionArray.count > 0 {
            return self.jobPositionArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45/WIDTH_6_SCALE
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectRow = row
        if self.array.count > 0{
            self.selectString = self.array[row]
        }
        if self.industryPositionArray.count > 0 {
            self.selectString = self.industryPositionArray[row].industryName
        }
        if self.jobPositionArray.count > 0 {
            self.selectString = self.jobPositionArray[row].jobName
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for singleLine in pickerView.subviews {
            if singleLine.frame.size.height < 1{
                singleLine.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
            }
        }
        let genderLabel = UILabel.init()
        genderLabel.font = DEF_FontSize_16
        genderLabel.textAlignment = .center
        genderLabel.textColor = .black
        if self.array.count > 0 {
            genderLabel.text = self.array[row];
        }
        if self.industryPositionArray.count > 0 {
            genderLabel.text = self.industryPositionArray[row].industryName;
        }
        if self.jobPositionArray.count > 0 {
            genderLabel.text = self.jobPositionArray[row].jobName;
        }
        return genderLabel;
    }
}
extension SingleSelectView{
    @objc func cancelBtnClick(btn:UIButton){
        self.dismissView()
    }
    func showView(array: [String]){
        self.selectString = array[0]
        self.array = array
        self.pickerView.reloadAllComponents()
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    func dismissView(){
        self.singleSelectViewDismissBlock?()
        array.removeAll()
        industryPositionArray.removeAll()
        jobPositionArray.removeAll()
    }
    
    func showView(industryPositionArray: [IndustryPositionDetailModel]){
        self.selectString = industryPositionArray[0].industryName
        self.industryPositionArray = industryPositionArray
        self.pickerView.reloadAllComponents()
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func showView(jobPositionArray: [JobPositionDetailModel]){
        self.selectString = jobPositionArray[0].jobName
        self.jobPositionArray = jobPositionArray
        self.pickerView.reloadAllComponents()
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    @objc func sureBtnClick(){
        if self.array.count > 0 {
            self.selectStringBlock?(self.selectString!)
        }
        if self.industryPositionArray.count > 0 {
            self.selectIndustryPositionBlock?(self.industryPositionArray[self.selectRow])
        }
        if self.jobPositionArray.count > 0{
            self.selectJobPositionBlock?(self.jobPositionArray[self.selectRow])
        }
    }
}
