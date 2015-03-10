//
//  PhotoDownloader.swift
//  MyWeiBo
//
//  Created by mac on 15/3/8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class PhotoDownloader: NSObject {
    var timeOut: NSTimeInterval = 15
    var connection: NSURLConnection?
    var isStart: Bool = false
    var photo: Photo?
    // 开始的回调
    var startClosure: (() -> ())?
    // 更新进度的回调
    var updateClosure: (() -> ())?
    // 结束的回调
    var finishClosure: (() -> ())?
    // 错误的回调
    var errorClosure: ((error: NSError) -> ())?
    
    override init() {
        super.init()
    }
    
    init( photo: Photo ) {
        self.photo = photo
    }

    func start() {
        if isStart {
            self.stop()
        }
        photo?.reset()
        let request = NSURLRequest(URL: NSURL(string: photo!.urlString!)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeOut)
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        dispatch_async(dispatch_get_global_queue(0, 0)){
            self.connection!.start()
            CFRunLoopRun()
            self.isStart = true
        }
    }
    
    func stop() {
        if connection == nil { return }
        connection!.cancel()
        connection = nil
        CFRunLoopStop(CFRunLoopGetCurrent())
        isStart = false
    }
}

// MARK: NSURLConnectionDataDelegate
extension PhotoDownloader: NSURLConnectionDataDelegate {
    // MARK: 下载失败
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        photo?.wholeSize = response.expectedContentLength
        if startClosure != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.startClosure!()
            }
        }
    }
    
    // MARK: 接收到数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        photo?.tempImageData?.appendData(data)
        photo?.completeSize += data.length
        if updateClosure != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.updateClosure!()
            }
        }
    }
    
    // MARK: 下载完毕
    func connectionDidFinishLoading(connection: NSURLConnection) {
        photo?.writeToFile()
        if finishClosure != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.finishClosure!()
            }
        }
    }
    
    // MARK: 接收到错误
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("下载出错了--\(error)")
        if errorClosure != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.errorClosure!(error: error)
            }
        }
    }
    
   
}
