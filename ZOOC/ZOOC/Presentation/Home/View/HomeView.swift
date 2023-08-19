//
//  HomeView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/21.
//

import UIKit

import SnapKit
import Then

final class HomeView : UIView{
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    public let homeScrollView = UIScrollView()
    public let homeContentView = UIView()
    public let emptyView = UIImageView()
    
    public let aiView = UIView()
    public let aiLogoImageView = UIImageView()
    public let aiLabel = UILabel()
    public let noticeButton = UIButton()
    public let shopButton = UIButton()
    
    public let petCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    public let listButton = UIButton()
    public let gridButton = UIButton()
    
    public let archiveListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    public let archiveGridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    public let archiveBottomView = UIView()
    public let archiveIndicatorView = HomeArchiveIndicatorView()
    
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
}

//MARK: - Custom Method

extension HomeView {
    
    private func style() {
        homeScrollView.do {
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        emptyView.do {
            $0.image = Image.graphics12
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }
        
        aiView.do {
            $0.backgroundColor = .clear
            $0.makeCornerRound(radius: 12)
        }
        
        aiLogoImageView.do {
            $0.image = Image.aiLogo
        }
        
        aiLabel.do {
            $0.text = "우리집 강아지 AI 굿즈 만들기"
            $0.font = .zoocBody1
            $0.textColor = .zoocGray3
            $0.asColor(targetString: "AI", color: .zoocMainGreen)
        }
        
        noticeButton.do {
            $0.setImage(Image.ring, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        shopButton.do {
            $0.setImage(Image.shop, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        petCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
        
        listButton.do {
            $0.isSelected = true
            $0.setImage(Image.list, for: .normal)
            $0.setImage(Image.listFill, for: .selected)
        }
        
        gridButton.do {
            $0.setImage(Image.grid, for: .normal)
            $0.setImage(Image.gridFill, for: .selected)
        }
        
        archiveListCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
        
        archiveGridCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            $0.collectionViewLayout = layout
            $0.isHidden = true
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
        
        
    }
    
    
    private func hierarchy() {
        self.addSubview(homeScrollView)
        homeScrollView.addSubview(homeContentView)
        homeContentView.addSubviews(aiView,
                                    noticeButton,
                                    shopButton,
                                    petCollectionView,
                                    listButton,
                                    gridButton,
                                    archiveBottomView,
                                    archiveListCollectionView,
                                    archiveGridCollectionView,
                                    emptyView)
        
        
        aiView.addSubviews(aiLogoImageView,
                                aiLabel)
        
        
        archiveBottomView.addSubview(archiveIndicatorView)
    }
    
    private func layout() {
        
        //MARK: rootView
        
        homeScrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(4)
        }
        
        homeContentView.snp.makeConstraints {
            $0.edges.equalTo(homeScrollView.contentLayoutGuide)
            $0.width.equalTo(homeScrollView.frameLayoutGuide)
            $0.height.equalTo(homeScrollView)
        }
        
        aiView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(112)
            $0.height.equalTo(42)
        }
        
        listButton.snp.makeConstraints {
            $0.centerY.equalTo(petCollectionView)
            $0.trailing.equalTo(gridButton.snp.leading)
            $0.height.width.equalTo(36)
        }
        
        gridButton.snp.makeConstraints {
            $0.centerY.equalTo(petCollectionView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(36)
        }
        
        petCollectionView.snp.makeConstraints {
            $0.top.equalTo(aiView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(listButton.snp.leading)
            $0.height.equalTo(40)
        }
        
        archiveListCollectionView.snp.makeConstraints {
            $0.top.equalTo(petCollectionView.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(archiveBottomView.snp.top)
        }
        
        archiveGridCollectionView.snp.makeConstraints {
            $0.top.equalTo(archiveListCollectionView)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(archiveListCollectionView).inset(65)
        }
        
        archiveBottomView.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        //MARK: missionView
        
        aiLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        aiLabel.snp.makeConstraints {
            $0.leading.equalTo(aiLogoImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        noticeButton.snp.makeConstraints {
            $0.leading.equalTo(self.aiView.snp.trailing).offset(19)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.size.equalTo(36)
        }
        
        shopButton.snp.makeConstraints {
            $0.leading.equalTo(self.noticeButton.snp.trailing)
            $0.top.equalTo(self.noticeButton)
            $0.size.equalTo(36)
        }
        
        //MARK: archiveBottomView
        
        archiveIndicatorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(72)
            $0.height.equalTo(4)
        }
    }

}
