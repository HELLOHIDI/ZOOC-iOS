//
//  ProductOptionCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import SnapKit
import Then

protocol ProductOptionCollectionViewCellDelegate: AnyObject {
    func optionDidSelected(option: OptionResult)
}

final class ProductOptionCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .zoocMainGreen : .zoocLightGray
            setBorder(borderWidth: 1, borderColor: color)
        }
    }
    
    weak var delegate: ProductOptionCollectionViewCellDelegate?
    
    //MARK: - UI Components
    
    lazy var menuItems: [UIAction] = []
    
    lazy var menu: UIMenu = UIMenu()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기종"
        label.font = .zoocBody1
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let dropDownImageView = UIImageView(image: Image.arrowDropDown)
    
    private lazy var cellButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        
        return button
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
        contentView.makeCornerRound(radius: 4)
        contentView.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
    }
    
    private func hierarchy() {
        contentView.addSubviews(titleLabel,
                                dropDownImageView,
                                cellButton)
    }
    
    private func layout() {
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        dropDownImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func dataBind(_ data: OptionCategoriesResult) {
        titleLabel.text = data.name
        menuItems = []
        data.options.forEach { option in
            let action = UIAction(title: option.name,
                                  handler: { action in
                self.delegate?.optionDidSelected(option: option)
            })
            
            menuItems.append(action)
        }
        
        let menu = UIMenu(title: "",
                      options: [],
                      children: menuItems)
        cellButton.menu = menu
    }
}
