//
//  Toast.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/07.
//

import UIKit

import SnapKit

final class Toast: UIView {
    
    enum ToastType {
        case good
        case normal
        case bad
        
        var backgroundColor: UIColor {
            switch self {
            case .good:
                return .zoocMainGreen.withAlphaComponent(0.8)
            case .normal:
                return .zoocDarkGray1.withAlphaComponent(0.8)
            case .bad:
                return .zoocRed.withAlphaComponent(0.8)
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .good:
                return .zoocMainGreen
            case .normal:
                return .zoocDarkGray1
            case .bad:
                return .zoocRed
            }
        }
        
        var image: UIImage {
            switch self {
            case .good:
                return Image.checkToast
            case .normal:
                return Image.checkToast
            case .bad:
                return Image.xToast
            }
        }
    }
    
    func show(message: String,
              type: ToastType,
              view: UIView,
              safeAreaBottomInset: CGFloat = UIApplication.shared.firstWindow?.safeAreaInsets.bottom ?? 0,
              bottomInset: CGFloat) {
        
        let toastImageView = UIImageView(image: type.image)
        let toastLabel = UILabel()
        
        
        
        self.backgroundColor = type.backgroundColor
        self.alpha = 1
        self.setBorder(borderWidth: 1, borderColor: type.borderColor)
        self.isUserInteractionEnabled = false
        
        toastImageView.contentMode = .scaleAspectFit
        
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .zoocFont(font: .semiBold, size: 14)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        
        let hStackView = UIStackView(arrangedSubviews: [toastImageView,toastLabel])
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.alignment = .center
        hStackView.distribution = .fill
        
        toastImageView.isHidden = type == .normal
    
        
        view.addSubview(self)
        self.addSubviews(hStackView)
        
        
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomInset + bottomInset)
        }
        
        hStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        toastImageView.snp.makeConstraints {
            $0.size.equalTo(14)
            
        }
        
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: {_ in
                self.removeFromSuperview()
            })
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCornerRound(ratio: 2)
    }
    
    
}
