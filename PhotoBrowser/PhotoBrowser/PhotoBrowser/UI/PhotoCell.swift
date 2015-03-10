////  PhotoCell.swift//  MyWeiBo////  Created by mac on 15/3/8.//  Copyright (c) 2015年 gpr. All rights reserved.//import UIKitclass PhotoCell: UICollectionViewCell {    /// 下载器    lazy var photoDownloader: PhotoDownloader! = {        let downloader = PhotoDownloader()        return downloader    }()        var photo: Photo? {        didSet {            let localImage = photo?.getLocalPhoto()            if localImage == nil { // 没下载完                progressView?.hidden = false                progressView?.progress = 0                imageView!.image = photo!.smallImage                imageView!.sizeToFit()                self.photoDownloader.stop()                self.photoDownloader.photo = photo                self.photoDownloader.start()            }            adjustImageView()        }    }    /// 显示图片    weak var imageView: PhotoView?    /// 图片滚动放大缩小    weak var scrollView: UIScrollView?    /// 显示进度的    weak var progressView: PhotoProgressView?    ///  退出的block    var backBlock: (() -> ())?    override func awakeFromNib() {        setUpChildrenView()        setUpDownLoader()    }        deinit {        self.photoDownloader.stop()    }        // MARK: 初始化子视图    func setUpDownLoader() {        weak var wself = self        photoDownloader.updateClosure = {            let wholeSize = wself?.photo!.wholeSize            let compeleteSize = wself?.photo!.completeSize            if wholeSize == 0 { return }            let progress = CGFloat(compeleteSize!) / CGFloat(wholeSize!)            wself?.progressView?.progress = progress        }                photoDownloader.finishClosure = {            wself?.progressView?.hidden = true            wself?.photo!.complete = true            wself?.adjustImageView()        }                photoDownloader.errorClosure = { (error) in            println("出错了")        }    }        func setUpImageGesture() {        imageView!.tap?.addTarget(self, action: "imageTap:")        imageView!.longPress?.addTarget(self, action: "imageLongPress:")    }        func setUpChildrenView() {        let scrollView = UIScrollView()        scrollView.delegate = self        scrollView.maximumZoomScale = 2.0        scrollView.minimumZoomScale = 0.5        self.scrollView = scrollView        scrollView.backgroundColor = UIColor.yellowColor()        self.contentView.addSubview(scrollView)                let imageView = PhotoView()        imageView.userInteractionEnabled = true        scrollView.addSubview(imageView)        self.imageView = imageView        setUpImageGesture()                let progressView = PhotoProgressView()        self.contentView.addSubview(progressView)        self.progressView = progressView        progressView.backgroundColor = UIColor(red: 123, green: 123, blue: 123, alpha: 0.5)        progressView.progress = 0    }        override func willMoveToWindow(newWindow: UIWindow?) {        super.willMoveToWindow(newWindow)        scrollView?.frame = self.bounds        progressView?.frame = self.bounds        progressView?.progress = 0.5    }        override func layoutSubviews() {        super.layoutSubviews()         adjustImageView()        if photo!.complete {            progressView?.hidden = true        } else {            progressView?.hidden = false        }    }        func adjustImageView() {        resetSctrollView()        if photo!.complete == false {            let imgCenter = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.5)            imageView!.center = imgCenter            return        } else {            let img = photo?.getLocalPhoto()            imageView?.image = img            imageView?.sizeToFit()            adjustScrollView(img!)        }    }        func adjustScrollView(img: UIImage) {        let w = self.bounds.width        let h = img.size.height / img.size.width * w        var x: CGFloat = 0        var y: CGFloat = 0                imageView?.isScale = false        if h > self.bounds.height {            scrollView?.contentSize = CGSizeMake(0, h)        } else { // 直接设置内边距            y = (self.bounds.height - h) * 0.5        }        let frame = CGRectMake(x, y, w, h)        imageView?.frame = frame        imageView?.originFrame = frame    }        func resetSctrollView() {        scrollView?.contentInset = UIEdgeInsetsZero        scrollView?.contentSize = CGSizeZero        imageView?.transform = CGAffineTransformIdentity    }    }extension PhotoCell: UIGestureRecognizerDelegate,UIScrollViewDelegate,UIAlertViewDelegate {        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {        return imageView    }        func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {        var frame = imageView!.frame        frame.origin.x = 0        frame.origin.y = 0        imageView?.frame = frame    }        // MARK: 处理手势的方法    func imageTap(tap: UITapGestureRecognizer){        let touchP = tap.locationInView(self.contentView)        UIView.animateWithDuration(0.25)  { () -> Void in            if self.imageView?.isScale == false {                let info = self.imageView!.frameForSacleWithAnchroPoint(touchP)                self.imageView!.frame = info.imageFrame                self.scrollView!.contentSize = info.imageFrame.size                self.scrollView!.contentOffset = CGPointMake(info.contentOffset.x, info.contentOffset.y)                self.imageView?.isScale = true            } else {                self.resetSctrollView()                self.imageView?.frame = self.imageView!.originFrame                self.imageView?.isScale = false            }        }    }        func imageLongPress(longPress:UILongPressGestureRecognizer) {        if ( longPress.state ==  .Began ) {            let alert = UIAlertView(title: "提示", message: "请选择保存图片&退出浏览器", delegate: self, cancelButtonTitle: "退出", otherButtonTitles: "保存图片到相册")            alert.show()        }    }        func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {        switch buttonIndex {        case 0:            if backBlock != nil {                backBlock!()            }        case 1:            UIImageWriteToSavedPhotosAlbum(photo?.getLocalPhoto(), self, "image:didFinishSavingWithError:contextInfo:", nil)        default:            break        }    }        func image(image: UIImage, didFinishSavingWithError error:NSError?, contextInfo:UnsafePointer<Void>) {        if error == nil {            println("保存成功")        } else {            println("保存失败 - \(error)")        }    }}