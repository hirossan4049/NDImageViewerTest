//
//  ViewController.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/01/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var image2Btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBtn.imageView?.layer.cornerRadius = 15
        imageBtn.imageView?.clipsToBounds = true
        imageBtn.imageView?.contentMode = .scaleAspectFill
        
        image2Btn.imageView?.layer.cornerRadius = 30
        image2Btn.imageView?.clipsToBounds = true
        image2Btn.imageView?.contentMode = .scaleAspectFill
        

    }
    
    

    @IBAction func imagetapped(_ sender: UIButton) {
        let vc = NDImagePreviewViewController()
        vc.backImg = sender.imageView
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
}

