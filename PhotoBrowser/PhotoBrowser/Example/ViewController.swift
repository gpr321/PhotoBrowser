//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by mac on 15/3/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DemoImageViewDelegate{

    var photos = [Photo]()
    
    @IBOutlet var imageViews: [DemoImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("imageInfo.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path!)
        var index = 0
        for dict in array!
        {
            let item = (dict as! [String: String])
            let url = item["bigImageURL"]
            let path  = NSBundle.mainBundle().pathForResource(item["placeHoderImg"]!, ofType: nil)
            let img = UIImage(contentsOfFile: path!)
            let photo = Photo(urlString: url!, placeHolderImage: img!)
            photos.append(photo)
            let imgV = imageViews[index]
            imgV.image = img
            imgV.userInteractionEnabled = true
            imgV.index = index
            imgV.delegate = self
            index++
        }
        
        println(NSTemporaryDirectory())
    }

    func demoImageViewDidCick(imgView: DemoImageView, index: Int) {
        let vc = PhotoBrowserController.photoBrowserController(photos, selectedIndex: index)
        self.presentViewController(vc, animated: false, completion: nil)
    }
}

