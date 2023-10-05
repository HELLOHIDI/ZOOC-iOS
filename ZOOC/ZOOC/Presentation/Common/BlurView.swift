//
//  BlurView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/06.
//

import UIKit

class BlurView: UIView {
    
    let blurEffect = UIBlurEffect(style: .light)
    lazy var blurView = UIVisualEffectView(effect: blurEffect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        self.alpha = 0
        //self.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        blurView.alpha = 0
        addSubview(blurView)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    func startBlur() {
        self.alpha = 1

        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 0.8
        }
    }
    
    func endBlur() {
        UIView.animate(withDuration: 0.1, animations:  {
            self.alpha = 0
            self.blurView.alpha = 0
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endBlur()
    }
}
