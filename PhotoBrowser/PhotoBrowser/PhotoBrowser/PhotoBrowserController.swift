//
//  PhotoBrowserController.swift
//  MyWeiBo
//
//  Created by mac on 15/3/8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class PhotoBrowserController: UIViewController {
    
    class func photoBrowserController( photos: [Photo], selectedIndex: Int ) -> PhotoBrowserController {
        let storyBoard = UIStoryboard(name: "PhotoBrowserController", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController() as! PhotoBrowserController
        vc.photos = photos
        vc.selectedIndex = selectedIndex
        return vc
    }

    @IBOutlet weak var photosCollectionView: UICollectionView!
    var currDownloader: PhotoDownloader?
    
    private var photos: [Photo]? 
    
    private var downloaders: [PhotoDownloader]?
    
    var selectedIndex: Int = 0
    
    @IBOutlet weak var photoViewLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        // 设置布局属性
        photoViewLayout.itemSize = self.view.bounds.size
        photoViewLayout.minimumLineSpacing = 0
        // 记得测试
        photoViewLayout.scrollDirection = .Horizontal
        self.photosCollectionView.pagingEnabled = true
        self.photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.photosCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: selectedIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        println(selectedIndex)
    }
}

extension PhotoBrowserController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = photos![indexPath.item]
        cell.photo = photo
        if cell.backBlock == nil {
            weak var weakself = self
            cell.backBlock = {
                weakself?.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        return cell
    }
    
}
