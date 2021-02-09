//
//  NDImagePreviewViewController.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/01/22.
//

import UIKit
import AVFoundation

class NDImagePreviewViewController: UIViewController {
    private var transitionImageViewFrame: CGRect!

    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var dragGesture: UIPanGestureRecognizer!
    var isZoomLock = false
    var imagePack: UIView!

    var backImg: UIImageView?

    lazy var headView: UIView = {
        let view = NDImagePreviewHeaderDefaultView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 50))
        view.delegate = self
        return view
    }()
//    var headView: UIView{
//        var crapview = UIView()
//        crapview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
//        crapview.backgroundColor = .blue
////        view.addSubview(crapview)
//        return crapview
//    }

    var isHeadViewHidden: Bool = true {
        didSet {
            if isHeadViewHidden {
                self.isHeadViewHiddenFn(true)
            } else {
                self.isHeadViewHiddenFn(false)
            }
        }
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        headView = UIView()
//        headView.backgroundColor = .blue

        transitionImageViewFrame = self.backImg!.superview!.convert(self.backImg!.frame, to: nil)

        imageView = UIImageView()
//        imageView.image = UIImage(named: "geohot")
        imageView.image = backImg!.image
        imageView.frame = transitionImageViewFrame
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

        scrollView.frame = UIScreen.main.bounds

        self.view.backgroundColor = .none
        self.view.addSubview(scrollView)
//        self.view = scrollView

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
        animation()
    }

    @objc func imageTap(sender: UITapGestureRecognizer) {
//        isHeadViewHidden(false)
        isHeadViewHidden = !isHeadViewHidden
        print("tapped")
    }

    @objc func asahaPan(sender: UIPanGestureRecognizer) {
        let move: CGPoint = sender.translation(in: view)

        if sender.state == .ended {
            let imgCntr = self.imageView!.superview!.convert(self.imageView!.frame, to: nil).center
            let saX = imgCntr.x - scrollView.center.x
            let saY = imgCntr.y - scrollView.center.y

            if abs(saX) > 30 || abs(saY) > 30 {
//                myImage.animate( .fill, frame: imageframe, duration: 0.4)
                closeAnimation()
            } else {
                imageView.backgroundColor = .black
                self.scrollView.backgroundColor = .black
//                imageView.center = view.center
                self.imageView.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height)
                updateScrollInset()
            }

            return
        }
        self.scrollView.backgroundColor = .none
        isHeadViewHidden = true
        imageView.center.x += move.x
        imageView.center.y += move.y
//        scrollView.minimumZoomScale = 0.9
//        scrollView.setZoomScale(0.9, animated: false)
        view.layoutIfNeeded()

        sender.setTranslation(CGPoint.zero, in: view)

    }

    func isHeadViewHiddenFn(_ isHidden: Bool) {
        if isHidden {
            view.addSubview(headView)
            UIView.animate(withDuration: 0.1, animations: {
                self.headView.frame.origin.y = -self.headView.frame.height
            }, completion: { _ in
                self.headView.removeFromSuperview()
            })
        } else {
            headView.frame.origin.y -= headView.frame.height
            view.addSubview(headView)
            UIView.animate(withDuration: 0.1, animations: {
                self.headView.frame.origin.y = 0
            })
        }
    }


    func animation() {
//        let scalewidth = self.view.frame.width - transitionImageViewFrame.width
//        let scaleheight = self.view.frame.height - transitionImageViewFrame.height

        let scalewidth = self.scrollView.frame.width - transitionImageViewFrame.width
//        let scaleheight = self.scrollView.frame.height - transitionImageViewFrame.height
//        let scalex = self.view.frame.origin.x - transitionImageViewFrame.origin.x
//        let scaley = self.view.frame.origin.y - transitionImageViewFrame.origin.y
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


        }, completion: { _ in
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

    func closeAnimation() {
        self.backImg?.backgroundColor = .red
        self.imageView.backgroundColor = .blue
        self.imageView.contentMode = .scaleAspectFill

        scrollView.setZoomScale(1.0, animated: true)
        isHeadViewHidden = true

        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowAnimatedContent], animations: {
            self.imageView.frame = self.transitionImageViewFrame
//            self.view.frame.origin = CGPoint(x: 0, y: 0)

            self.scrollView.contentInset = .zero

//            self.backImg?.frame = self.transitionImageViewFrame

            self.scrollView.backgroundColor = .none
//            self.backImg?.alpha = 1
        }, completion: { _ in
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
                top: max((scrollView.frame.height - imageView.frame.height) / 2, 0),
                left: max((scrollView.frame.width - imageView.frame.width) / 2, 0),
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
        } else {
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
        if scrollView.zoomScale == 1 {
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


// MARK: Extension CGRect
extension CGRect {
    /** Creates a rectangle with the given center and dimensions
    - parameter center: The center of the new rectangle
    - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }

    /** the coordinates of this rectangles center */
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x; centerY = newValue.y
        }
    }

    /** the x-coordinate of this rectangles center
    - note: Acts as a settable midX
    - returns: The x-coordinate of the center
     */
    var centerX: CGFloat {
        get {
            return midX
        }
        set {
            origin.x = newValue - width * 0.5
        }
    }

    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat {
        get {
            return midY
        }
        set {
            origin.y = newValue - height * 0.5
        }
    }

    // MARK: - "with" convenience functions

    /** Same-sized rectangle with a new center
    - parameter center: The new center, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(center: CGPoint?) -> CGRect {
        return CGRect(center: center ?? self.center, size: size)
    }

    /** Same-sized rectangle with a new center-x
    - parameter centerX: The new center-x, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
    }

    /** Same-sized rectangle with a new center-y
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
    }

    /** Same-sized rectangle with a new center-x and center-y
    - parameter centerX: The new center-x, ignored if nil
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
    }
}


// MARK: UICOlor Extension
extension UIColor {

    func setAlpha(alpha a: CGFloat) -> UIColor {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: red, green: green, blue: blue, alpha: a)
    }

}
