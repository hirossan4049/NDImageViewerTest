//
//  ViewController.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/01/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBtn.imageView?.layer.cornerRadius = 15
        imageBtn.imageView?.clipsToBounds = true
        imageBtn.imageView?.contentMode = .scaleAspectFill
        

    }
    
    @IBAction func btn(){
        let vc = NDImagePreviewViewController()
//        vc.transitionImageView = imageBtn.frame
        vc.backImg = imageBtn.imageView
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    


}

