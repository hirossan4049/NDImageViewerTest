//
//  NDImagePreviewViewController.swift
//  NDImagePreviewTest
//
//  Created by NDSLib on 2021/01/22.
//

import UIKit
import AVFoundation

class NDImagePreviewViewController: UIViewController {
    private var transitionImageViewFrame: CGRect!

    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var dragGesture: UIPanGestureRecognizer!
    var isZoomLock = false

    var backImg: UIImageView?

    lazy var headView: UIView = {
        let view = NDImagePreviewHeaderDefaultView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 50))
        view.delegate = self
        return view
    }()


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

        transitionImageViewFrame = self.backImg!.superview!.convert(self.backImg!.frame, to: nil)

        imageView = UIImageView()
        imageView.image = backImg!.image
        imageView.frame = transitionImageViewFrame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = backImg!.layer.cornerRadius
        imageView.backgroundColor = .none
        imageView.isUserInteractionEnabled = true

        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(asahaPan))
        imageView.addGestureRecognizer(dragGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        imageView.addGestureRecognizer(tapGesture)

        scrollView = UIScrollView(frame: view.bounds)

        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)
        scrollView.frame = UIScreen.main.bounds

        self.view.backgroundColor = .none
        self.view.addSubview(scrollView)

        scrollView.backgroundColor = .none

        setupGesture()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backImg?.alpha = 0
        animation()
    }

    @objc func imageTap(sender: UITapGestureRecognizer) {
        isHeadViewHidden = !isHeadViewHidden
    }

    @objc func asahaPan(sender: UIPanGestureRecognizer) {
        let move: CGPoint = sender.translation(in: view)
        
        if sender.state == .began {
            isHeadViewHidden = true

            scrollView.minimumZoomScale = 0.85
            self.imageView.layer.cornerRadius = 100
            self.imageView.backgroundColor = .red
            UIView.animate(withDuration: 0.15, animations: {
                self.scrollView.backgroundColor = .none
                self.scrollView.setZoomScale(0.85, animated: false)
            })
            
        }else if sender.state == .ended {
            let imgCntr = self.imageView!.superview!.convert(self.imageView!.frame, to: nil).center
            let saX = imgCntr.x - scrollView.center.x
            let saY = imgCntr.y - scrollView.center.y

            if abs(saX) > 30 || abs(saY) > 30 {
                closeAnimation()
            } else {
                scrollView.minimumZoomScale = 1
                UIView.animate(withDuration: 0.15, animations: {
                    self.scrollView.backgroundColor = .black
                    self.scrollView.setZoomScale(1, animated: false)
                })
                self.imageView.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height)
                updateScrollInset()
            }

            return
        }
        
        imageView.center.x += move.x
        imageView.center.y += move.y

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
        let scalewidth = self.scrollView.frame.width - transitionImageViewFrame.width

        let height = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: self.scrollView.bounds).size.height
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowAnimatedContent], animations: {
            self.imageView.frame.size.width += scalewidth
            self.imageView.frame.size.height = height
            self.imageView.frame.origin.x -= self.imageView.frame.origin.x
            self.imageView.center.y = self.scrollView.center.y
            self.scrollView.backgroundColor = .black

        }, completion: { _ in
            print("animated", self.imageView.frame)
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height)
            self.updateContentInset()
        })

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

        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        isHeadViewHidden = true

        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowAnimatedContent], animations: {
            self.imageView.frame = self.transitionImageViewFrame
            self.scrollView.contentInset = .zero
            self.scrollView.backgroundColor = .none
        }, completion: { _ in
            print("end", self.imageView.frame)
            self.backImg?.alpha = 1
            self.dismiss(animated: false, completion: nil)
        })

        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 0.1
        animation.fromValue = 0
        animation.toValue = backImg!.layer.cornerRadius
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

// MARK: Aspect Extension
extension UIImageView {

    private var aspectFitSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }

    var aspectFitFrame: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x + (bounds.size.width - size.width) * 0.5, y: frame.origin.y + (bounds.size.height - size.height) * 0.5), size: size)
        }
    }

    var aspectFitBounds: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.size.width * 0.5 - size.width * 0.5, y: bounds.size.height * 0.5 - size.height * 0.5), size: size)
        }
    }

    private var aspectFillSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio < heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }

    var aspectFillFrame: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x - (size.width - bounds.size.width) * 0.5, y: frame.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }

    var aspectFillBounds: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.origin.x - (size.width - bounds.size.width) * 0.5, y: bounds.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }

    func imageFrame(_ contentMode: UIView.ContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return frame
        case .scaleAspectFit:
            return aspectFitFrame
        case .scaleAspectFill:
            return aspectFillFrame
        case .center:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: frame.origin, size: image.size)
        case .top:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x = frame.origin.x
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x = frame.origin.x
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        }
    }

    func imageBounds(_ contentMode: UIView.ContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return bounds
        case .scaleAspectFit:
            return aspectFitBounds
        case .scaleAspectFill:
            return aspectFillBounds
        case .center:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: CGPoint.zero, size: image.size)
        case .top:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = bounds.size.width - image.size.width
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x: CGFloat = 0
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x: CGFloat = 0
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        }
    }
}

