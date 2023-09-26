//
//  MyFamilySectionCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//

import UIKit

import SnapKit
import Then

final class MyFamilyView: UIView {
    
    //MARK: - Properties
    
    private var myFamilyData: [UserResult] = [] {
        didSet {
            familyCollectionView.reloadData()
        }
    }
    
    //MARK: - UI Components
    
    private var familyLabel = UILabel()
    private var familyCountLabel = UILabel()
    public var inviteButton = UIButton()
    private var inviteButtonUnderLine = UIView()
    public lazy var familyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate()
        register()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        familyCollectionView.delegate = self
        familyCollectionView.dataSource = self
    }
    
    private func register() {
        familyCollectionView.register(
            MyFamilyCollectionViewCell.self,
            forCellWithReuseIdentifier: MyFamilyCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        self.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 12)
        }
        
        familyLabel.do {
            $0.text = "멤버"
            $0.textColor = .zoocDarkGray1
            $0.font = .zoocSubhead1
        }
        
        familyCountLabel.do {
            $0.textColor = .zoocGray2
            $0.font = .zoocCaption
            $0.textAlignment = .center
        }

        inviteButton.do {
            $0.setTitle("초대하기", for: .normal)
            $0.setTitleColor(.zoocGray2, for: .normal)
            $0.titleLabel!.font = .zoocCaption
        }
        
        inviteButtonUnderLine.do {
            $0.backgroundColor = .zoocGray2
        }
        
        familyCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = layout
        }
    }
    
    private func hierarchy() {
        self.addSubviews(familyLabel,
                    familyCountLabel,
                    inviteButton,
                    familyCollectionView,
                    inviteButtonUnderLine
        )
    }
    
    private func layout() {
        familyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(26)
        }
        
        familyCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(self.familyLabel.snp.trailing).offset(4)
        }
        
        inviteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(42)
            $0.height.equalTo(14)
        }
        
        inviteButtonUnderLine.snp.makeConstraints {
            $0.top.equalTo(self.inviteButton.snp.bottom).offset(2)
            $0.trailing.equalTo(self.inviteButton)
            $0.width.equalTo(41)
            $0.height.equalTo(1)
        }

        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.familyLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.familyLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    internal func updateUI(_ data: [UserResult]) {
        familyCountLabel.text = "\(data.count)/8"
        self.myFamilyData = data
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyFamilyView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
    }
}

//MARK: - UICollectionViewDataSource

extension MyFamilyView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFamilyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFamilyCollectionViewCell.cellIdentifier, for: indexPath)
                as? MyFamilyCollectionViewCell else { return UICollectionViewCell() }
        if (indexPath.first != nil) {
            cell.dataBind(data: myFamilyData[indexPath.item], index: indexPath.item)
        } else {
            cell.dataBind(data: myFamilyData[indexPath.item], index: indexPath.item)
        }
        
        return cell
    }
}
