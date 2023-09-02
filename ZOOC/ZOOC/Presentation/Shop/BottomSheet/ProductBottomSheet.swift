//
//  ProductBottomSheet.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

protocol ProductBottomSheetDelegate: AnyObject {
    func cartButtonDidTap(selectedOptions: [ProductSelectedOption])
    func orderButtonDidTap(selectedOptions: [ProductSelectedOption])
}

final class ProductBottomSheet: UIViewController, ScrollableViewController {
    
    //MARK: - Properties

    private var option: [String] = ["색상"]

    private var selectedOptionsData: [ProductSelectedOption] = [] {
        didSet {
            collectionView.reloadData()
            var totalPrice = 0
            selectedOptionsData.forEach { selectedOption in
                totalPrice += selectedOption.totalPrice
            }
            priceValueLabel.text = totalPrice.priceText
            
        }
    }
    
    weak var delegate: ProductBottomSheetDelegate?
    
    //MARK: - UI Components
    
    private let collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = SelfSizingCollectionView(maxHeight: UIScreen.main.bounds.height * 0.6,
                                                      layout: layout)
        collectionView.allowsSelection = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.indicatorStyle = .black
        return collectionView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocLightGray
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 금액"
        label.font = .zoocSubhead1
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.text = 0.priceText
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle("장바구니", for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .normal)
        button.setBorder(borderWidth: 1, borderColor: .zoocMainGreen)
        button.makeCornerRound(radius: 6)
        button.titleLabel?.font = .zoocSubhead1
        button.backgroundColor = .zoocWhite1
        button.addTarget(self,
                         action: #selector(cartButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.zoocWhite1, for: .normal)
        button.setBorder(borderWidth: 1, borderColor: .zoocMainGreen)
        button.titleLabel?.font = .zoocSubhead1
        button.backgroundColor = .zoocMainGreen
        button.makeCornerRound(radius: 6)
        button.addTarget(self,
                         action: #selector(orderButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    var scrollView: UIScrollView {
        collectionView
    }
    
    //MARK: - Life Cycle

        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        register()
        setDelegate()
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        collectionView.register(ProductOptionCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductOptionCollectionViewCell.cellIdentifier)
        
        collectionView.register(ProductSelectedOptionCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductSelectedOptionCollectionViewCell.cellIdentifier)
    }
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func style() {
    
    }
    
    private func hierarchy() {
        view.addSubviews(collectionView,
                         lineView,
                         priceLabel,
                         priceValueLabel,
                         hStackView)
        
        hStackView.addArrangedSubViews(cartButton,
                                       orderButton)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(lineView)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.top).offset(-15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(cartButton.snp.top).offset(-25)
            $0.leading.equalToSuperview().inset(20)
        }
        
        priceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(47)
        }
    }
    
    @objc
    private func cartButtonDidTap() {
        dismiss(animated: false)
        delegate?.cartButtonDidTap(selectedOptions: selectedOptionsData)
    }
    
    @objc
    private func orderButtonDidTap() {
        dismiss(animated: false)
        delegate?.orderButtonDidTap(selectedOptions: selectedOptionsData)
    }
}


//MARK: - UICollectionViewDataSource

extension ProductBottomSheet: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return option.count
        case 1:
            return selectedOptionsData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductOptionCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! ProductOptionCollectionViewCell
            cell.dataBind(optionType: "색상", options: [ProductOption(id: 1, option: "빨강", price: 10000),
                                                      ProductOption(id: 2, option: "파랑", price: 10000),
                                                      ProductOption(id: 3, option: "노랑", price: 10000)])
            cell.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSelectedOptionCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! ProductSelectedOptionCollectionViewCell
            cell.dataBind(indexPath: indexPath,
                          selectedOption: selectedOptionsData[indexPath.row])
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegate


//MARK: - UICollectionViewDelegateFlowLayout

extension ProductBottomSheet: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width - 40, height: 40)
        case 1:
            return CGSize(width: width - 40, height: 100)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        case 1:
            return 10
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension ProductBottomSheet: ProductOptionCollectionViewCellDelegate {
    func optionDidSelected(option: ProductOption) {
        let willSelectedOption = option.transform()
        var canAppend = true
        selectedOptionsData.forEach { selectedOption in
            guard selectedOption.id != willSelectedOption.id else
            {
                canAppend = false
                return
                
            }
        }
        
        if canAppend {
            selectedOptionsData.append(willSelectedOption)
        } else {
            presentBottomAlert("이미 추가된 옵션입니다.")
        }
        
    }
    
    
}

extension ProductBottomSheet: ProductSelectedOptionCollectionViewCellDelegate {
    func adjustAmountButtonDidTap(row: Int, isPlus: Bool) {
        do {
            if isPlus {
                try selectedOptionsData[row].increase()
            } else {
                try selectedOptionsData[row].decrease()
            }
            
            collectionView.reloadData()
        } catch  {
            guard let error =  error as? AmountError else { return }
            presentBottomAlert(error.message)
        }
    }
    
    func xButtonDidTap(row: Int) {
        selectedOptionsData.remove(at: row)
        collectionView.reloadData()
    }
    
    
}
