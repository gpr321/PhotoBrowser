//
//  Photo.swift
//  MyWeiBo
//
//  Created by mac on 15/3/8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class Photo: NSObject {
    ///  图片的url地址
    var urlString: String? {
        didSet {
           tempImageFile = (Photo.cachePath as NSString).stringByAppendingPathComponent(urlString!.md5)
        }
    }
    ///  要显示的图片
    var smallImage: UIImage?
    ///  用来临时存放数据,如果下载完毕该值会变为空值
    var tempImageData: NSMutableData?
    /// 下载完毕之后该文件会保存到本地缓存目录
    var tempImageFile: String?
    // 该变量用来标志下载任务是否完成
    var complete: Bool = false
    /// 当获得下载信息的时候会记录该图片的总大小
    var wholeSize: Int64 = 0
    /// 记录当前下载图片的进度
    var completeSize: Int64 = 0
    
    static let IMAGE_CACHE = "com.gpr.photoCache"
    static var cachePath: String! = {
        var cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as! String
        cachePath = cachePath.stringByAppendingPathComponent(IMAGE_CACHE)
        // 判断文件是否存在
        var isDirctionary: ObjCBool = true
        let exist = NSFileManager.defaultManager().fileExistsAtPath(cachePath, isDirectory: &isDirctionary)
        // 如果文件不存在,文件存在 && 不是文件夹就干掉重新创建
        if !exist || !isDirctionary {
            NSFileManager.defaultManager().removeItemAtPath(cachePath, error: nil)
            var error: NSError?
            NSFileManager.defaultManager().createDirectoryAtPath(cachePath, withIntermediateDirectories: false, attributes: nil, error: &error)
            if error != nil {
                println(error)
            }
        }
        return cachePath
        }()
    
    init(urlString:String, placeHolderImage: UIImage) {
        super.init()
        self.urlString = urlString
        self.smallImage = placeHolderImage
        tempImageFile = (Photo.cachePath as NSString).stringByAppendingPathComponent(urlString.md5)
    }
    
    // MARK: 当下载操作被打断的时候重置数据,来重新下载
    func reset() {
        tempImageData = NSMutableData()
        completeSize = 0
    }
    
    // 将文件数据写到文件夹
    func writeToFile () {
        tempImageData?.writeToFile(tempImageFile!, atomically: true)
        complete = true
        tempImageData = nil
    }
    
    func getLocalPhoto() -> UIImage? {
        if let img = UIImage(contentsOfFile: tempImageFile!) {
            complete = true
            return img
        } else {
            return nil
        }
    }
}
