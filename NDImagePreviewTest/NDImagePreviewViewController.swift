//
//  NDImagePreviewViewController.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/01/22.
//

import UIKit

class NDImagePreviewViewController: UIViewController {
    public var transitionImageView: CGRect!
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "image1")
        imageView.frame = transitionImageView
        imageView.contentMode = .scaleAspectFit
        
//        view.addSubview(imageView)
        scrollView = UIScrollView()
        scrollView.frame = view.frame
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        
        scrollView.addSubview(imageView)
        self.view.addSubview(scrollView)

        setupGesture()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animation()
    }


    func animation(){
        let scalewidth = self.view.frame.width - transitionImageView.width
        let scaleheight = self.view.frame.height - transitionImageView.height
        let scalex = self.view.frame.origin.x - transitionImageView.origin.x
        let scaley = self.view.frame.origin.y - transitionImageView.origin.y

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.imageView.frame.size.width += scalewidth
            self.imageView.frame.size.height += scaleheight
//            self.imageView.frame.origin.x += scalex
//            self.imageView.frame.origin.y += scaley
            self.imageView.frame.origin.x -= self.imageView.frame.origin.x
            self.imageView.frame.origin.y -= self.imageView.frame.origin.y
            
        }, completion: nil)
    }
    


}

extension NDImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
