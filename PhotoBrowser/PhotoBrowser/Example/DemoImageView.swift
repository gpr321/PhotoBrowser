//
//  DemoImageView.swift
//  PhotoBrowser
//
//  Created by mac on 15/3/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

protocol DemoImageViewDelegate: NSObjectProtocol {
    func demoImageViewDidCick(imgView: DemoImageView, index: Int)
}

class DemoImageView: UIImageView {

   var index = 0
    weak var delegate: DemoImageViewDelegate?
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if delegate != nil {
            delegate?.demoImageViewDidCick(self, index: index)
        }
    }
}
