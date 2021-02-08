//
//  NDImagePreviewHeaderView.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/02/07.
//

import UIKit

//@IBDesignable
class NDImagePreviewHeaderDefaultView: NDImagePreviewHeaderView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(exitBtn)
        self.frame = frame
        loadNib()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBAction func exitBtn(){
        self.exit()
    }
    
    func loadNib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NDImagePreviewHeaderDefaultView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = frame
        self.addSubview(view)
    }
    
    override func layoutSubviews() {



    }
    
}


class NDImagePreviewHeaderView: UIView{
    var delegate: NDImagePreviewViewController!
    
    @objc func exit(){
        delegate.closeAnimation()
    }
}
