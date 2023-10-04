//
//  ProductImageCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/04.
//

import UIKit

import SnapKit

final class ProductImageCollectionViewCell: UICollectionViewCell {
  
  //MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
  
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        
    }
    
    private func hierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func dataBind(_ image: String?) {
        imageView.kfSetImage(url: image)
    }
}
