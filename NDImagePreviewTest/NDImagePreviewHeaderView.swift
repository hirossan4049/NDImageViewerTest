//
//  NDImagePreviewHeaderView.swift
//  NDImagePreviewTest
//
//  Created by craptone on 2021/02/07.
//

import UIKit

class NDImagePreviewHeaderDefaultView: NDImagePreviewHeaderView {
    lazy var exitBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(self.exit),
                                     for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        exitBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(exitBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        // レイアウトの設定
        exitBtn.frame = self.frame


    }
}


class NDImagePreviewHeaderView: UIView{
    var delegate: NDImagePreviewViewController!
    
    @objc func exit(){
        delegate.closeAnimation()
    }
}
