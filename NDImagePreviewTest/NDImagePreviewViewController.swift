//
//  NDImagePreviewViewController.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/01/22.
//
import UIKit
import AVFoundation

class NDImagePreviewViewController: UIViewController {
    public var transitionImageView: CGRect!
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var dragGesture: UIPanGestureRecognizer!
    var isZoomLock = false
    var imagePack: UIView!
    
    var backImg: UIImageView?
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "geohot")
        imageView.frame = transitionImageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .none
        imageView.isUserInteractionEnabled = true
//        imageView.frame = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)
        
        imagePack = UIView()
        imagePack.frame = view.frame
        
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(asahaPan))
//        imageView.panGesture = dragGesture
        imageView.addGestureRecognizer(dragGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        imageView.addGestureRecognizer(tapGesture)
        
        imagePack.backgroundColor = .none
//        imagePack.addSubview(imageView)
        
        
//        view.addSubview(imageView)
        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.frame = view.frame
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.contentSize = imageView.frame.size
//        scrollView.contentInset = .zero
//        scrollView.contentInset.top = -imageView.frame.origin.y
//        scrollView.contentInset.bottom = imageView.frame.origin.y + 30
        
        scrollView.addSubview(imageView)
//        self.view.addSubview(scrollView)
        self.view = scrollView
        
//        self.view.backgroundColor = .red
        scrollView.backgroundColor = .none
//        self.view.backgroundColor?.withAlphaComponent(0)
        self.scrollView.backgroundColor?.withAlphaComponent(0)

        setupGesture()


    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if let size = imageView.image?.size {
//            // imageViewのサイズがscrollView内に収まるように調整
//            let wrate = scrollView.frame.width / size.width
//            let hrate = scrollView.frame.height / size.height
//            let rate = min(wrate, hrate, 1)
//            imageView.frame.size = CGSize(width: size.width * rate, height: size.height * rate)
//
//            // contentSizeを画像サイズに設定
//            scrollView.contentSize = imageView.frame.size
//            // 初期表示のためcontentInsetを更新
//            updateScrollInset()
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backImg?.alpha = 0
        print("viewDidAppler",self.transitionImageView)
        
//        let crapview = UIView()
//        crapview.frame = transitionImageView
//        crapview.backgroundColor = .blue
//        view.addSubview(crapview)
        
        animation()
    }
    
    @objc func imageTap(sender: UITapGestureRecognizer){
        print("tapped")
    }
    
    @objc func asahaPan(sender: UIPanGestureRecognizer){
        let move:CGPoint = sender.translation(in: view)
//        if myImage.isZoomLock{
//            return
//        }
//        if imageView.contentMode == .scaleAspectFill{
//            return
//        }
        if sender.state == .ended{
//            let saX = sender.view!.center.x - view.center.x
//            let saY = sender.view!.center.y - view.center.y
            let saX = imageView!.center.x - view.center.x
            let saY = imageView!.center.y - view.center.y
            if abs(saX) > 30 || abs(saY) > 30{
//                myImage.animate( .fill, frame: imageframe, duration: 0.4)
                closeAnimation()
            }else{
                imageView.backgroundColor = .black
                imageView.center = view.center
            }
        
            return
        }
        imageView.backgroundColor = .none
        imageView.center.x += move.x
        imageView.center.y += move.y
        view.layoutIfNeeded()
        
        sender.setTranslation(CGPoint.zero, in:view)
        
    }


    func animation(){
//        let scalewidth = self.view.frame.width - transitionImageView.width
//        let scaleheight = self.view.frame.height - transitionImageView.height
        
        let scalewidth = self.scrollView.frame.width - transitionImageView.width
//        let scaleheight = self.scrollView.frame.height - transitionImageView.height
//        let scalex = self.view.frame.origin.x - transitionImageView.origin.x
//        let scaley = self.view.frame.origin.y - transitionImageView.origin.y
//        curveLinear
        
        let ratio = self.imageView.image!.size.width / self.imageView.image!.size.height
        
        let height = ratio * self.view.frame.width
//        let scaleheight = self.scrollView.frame.height - height
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowAnimatedContent], animations: {
            self.imageView.frame.size.width += scalewidth
//            self.imageView.frame.size.height += scaleheight
            self.imageView.frame.size.height = height
//            self.imageView.frame.origin.x += scalex
//            self.imageView.frame.origin.y += scaley
            self.imageView.frame.origin.x -= self.imageView.frame.origin.x
//            self.imageView.frame.origin.y -= self.imageView.frame.origin.y
            self.imageView.center.y = self.scrollView.center.y
//            self.imageView.contentMode = .scaleAspectFit
            
            self.scrollView.backgroundColor = .black


        }, completion: {_ in
            print("animated", self.imageView.frame)
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height)
            self.updateContentInset()
            
//            self.imageView.center.y = self.view.center.y
        

            
//            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            self.scrollView.contentInset = .zero
//            self.updateScrollInset()
//            self.imageView.frame = self.scrollView.frame
//            self.imageView.contentMode = .scaleAspectFit
//            self.scrollView.frame.size.height -= self.imageView.frame.origin.y
            
        })
        
        
//        UIView.animate(withDuration: 5, delay: 7) {
//            self.imageView.contentMode = .scaleAspectFit
//        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 0.1
        animation.fromValue = imageView.layer.cornerRadius
        animation.toValue = 0.0
        animation.beginTime = CACurrentMediaTime() + 0.2
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        imageView.layer.add(animation, forKey: nil)
        

    }
    
    func closeAnimation(){
        print("CLOSEanimation", self.transitionImageView)
        print("imageViewFrame", self.imageView.frame)
        self.backImg?.backgroundColor = .red
        self.imageView.backgroundColor = .blue
        self.imageView.contentMode = .scaleAspectFill
        
        let yyy = self.transitionImageView.origin.y - self.imageView.frame.origin.y
        
        print("conver!?", self.view.convert(self.view.frame, to: imageView))
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowAnimatedContent], animations: {
            self.imageView.frame = self.transitionImageView
//            self.view.frame.origin = CGPoint(x: 0, y: 0)
            
            self.scrollView.contentInset = .zero
            
//            self.backImg?.frame = self.transitionImageView
            
//            self.imageView.frame.origin.y = yyy
            
            self.scrollView.backgroundColor = .none
//            self.backImg?.alpha = 1
        }, completion: {_ in
            print("end", self.imageView.frame)
            self.backImg?.alpha = 1
            self.dismiss(animated: false, completion: nil)
        })
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 0.1
        animation.fromValue = 0
        animation.toValue = 15
        animation.beginTime = CACurrentMediaTime() + 0.2
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        imageView.layer.add(animation, forKey: nil)
        
    }
    
    private func updateScrollInset() {
        // imageViewの大きさからcontentInsetを再計算
        // なお、0を下回らないようにする
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - imageView.frame.height)/2, 0),
            left: max((scrollView.frame.width - imageView.frame.width)/2, 0),
            bottom: 0,
            right: 0
        );
    }
    


}



extension NDImagePreviewViewController {
    func setupGesture() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onDoubleTap(_:)))
        recognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        
        if scale != scrollView.zoomScale {
            let tapPoint = sender.location(in: imageView)
            let size = CGSize(width: scrollView.frame.size.width / scale,
                              height: scrollView.frame.size.height / scale)
            let origin = CGPoint(x: tapPoint.x - size.width / 2,
                                 y: tapPoint.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
        else {
            scrollView.zoom(to: scrollView.frame, animated: true)
        }
    }
}


extension NDImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    //ズームを開始すると呼ばれる
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView,
        with view: UIView?) {
        imageView.removeGestureRecognizer(dragGesture)
        isZoomLock = true
        print(#function, scrollView.zoomScale)
    }

    //ズームを終了すると呼ばれる
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView,
        with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale == 1{
            imageView.addGestureRecognizer(dragGesture)
            isZoomLock = false
        }
        print(#function)
    }

    //ズーム中に呼ばれる
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(#function)
//        updateScrollInset()
        
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    private func updateContentInset() {
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - imageView.frame.height) / 2, 0),
            left: max((scrollView.frame.width - imageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
}
