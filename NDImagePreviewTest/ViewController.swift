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
    }
    
    @IBAction func btn(){
        let vc = NDImagePreviewViewController()
        vc.transitionImageView = imageBtn.frame
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    


}

