//
//  Segmentio+Extension.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import Segmentio

extension Segmentio {
    var defaultOption: SegmentioOptions {
        let position = SegmentioPosition.dynamic
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 0.5, height: 2, color: UIColor.mainBlueColor)
        let separatorOptions = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0, color: UIColor.green)
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: UIColor.clear)
        let state = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: UIColor(hex: "333333")
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: UIColor.mainBlueColor
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        let options = SegmentioOptions(backgroundColor: UIColor.white, segmentPosition: position, scrollEnabled: true, indicatorOptions: indicatorOptions, horizontalSeparatorOptions: separatorOptions, verticalSeparatorOptions: verticalSeparatorOptions, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: state, animationDuration: 0.35)
        return options
    }
    
    var courseDetailOption: SegmentioOptions {
        let position = SegmentioPosition.dynamic
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 0.5, height: 2, color: UIColor.clear)
        let separatorOptions = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0, color: UIColor.green)
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: UIColor.clear)
        let state = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 18),
                titleTextColor: UIColor(hex: "333333")
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 18),
                titleTextColor: UIColor.black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.systemFont(ofSize: 18),
                titleTextColor: .black
            )
        )
        let options = SegmentioOptions(backgroundColor: UIColor.white, segmentPosition: position, scrollEnabled: true, indicatorOptions: indicatorOptions, horizontalSeparatorOptions: separatorOptions, verticalSeparatorOptions: verticalSeparatorOptions, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: state, animationDuration: 0.35)
        return options
    }
}
