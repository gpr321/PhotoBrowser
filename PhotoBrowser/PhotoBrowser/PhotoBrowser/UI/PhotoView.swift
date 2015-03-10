//
//  PhotoView.swift
//  MyWeiBo
//
//  Created by mac on 15/3/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class PhotoView: UIImageView {
    
    var isScale: Bool = false
    /// 用来记录之前显示的尺寸
    var originFrame = CGRectZero {
        didSet {
            let w = originFrame.width * PhotoView.maxScale
            let h = originFrame.height * PhotoView.maxScale
            maxSacleFrame = CGRectMake(originFrame.origin.x, originFrame.origin.y, w, h)
        }
    }
    /// 最大的显示尺寸
    var maxSacleFrame = CGRectZero
    var contentOffSetForSacle: CGPoint = CGPointZero
    static let maxScale: CGFloat = 2
    
    // MARK: 手势
    weak var tap: UITapGestureRecognizer?
    weak var longPress: UILongPressGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestureRecognizer()
    }
    
    override init() {
        super.init()
    }

    func setUpGestureRecognizer() {
        self.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        self.tap = tap
        
        let longPress = UILongPressGestureRecognizer()
        self.addGestureRecognizer(longPress)
        self.longPress = longPress
    }
    

    required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    // MARK: 获得放大的信息
    func frameForSacleWithAnchroPoint(p: CGPoint) -> (imageFrame: CGRect, contentOffset: CGPoint) {
        let originW = originFrame.width
        let originH = originFrame.height
        let w = originW * PhotoView.maxScale
        let h = originH * PhotoView.maxScale
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let superW = superview!.bounds.size.width
        let superH = superview!.bounds.size.height
        var offSetx: CGFloat = 0
        var offSety: CGFloat = 0
        
        let dw = w - originFrame.width
        let dh = h - originFrame.height
        
        if h < superH {
            y = (superH - h) * 0.5
        } else {
            offSety = h - superH - (originH - p.y )
        }
        
        if w > superW {
            offSetx = w - superW - (originW - p.x )
        }
        return ( CGRectMake(x, y, w, h), CGPointMake(offSetx, offSety) )
    }
    
}
