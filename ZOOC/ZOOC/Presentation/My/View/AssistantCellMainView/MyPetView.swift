//
//  PetCollectionView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

//MARK: - MyRegisterPetButtonTappedDelegate

protocol MyRegisterPetButtonTappedDelegate: AnyObject {
    func petCellTapped(pet: PetResult)
    func myRegisterPetButtonTapped(isSelected: Bool)
}

final class MyPetView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: MyRegisterPetButtonTappedDelegate?
    
    private let disposeBag = DisposeBag()
    private var dataSource:  RxCollectionViewSectionedReloadDataSource<SectionData<PetResult>>?
    var sectionSubject = BehaviorRelay(value: [SectionData<PetResult>]())
    
    private var myPetMemberData: [PetResult] = [] {
        didSet {
            var updateSection: [SectionData<PetResult>] = []
            updateSection.append(SectionData<PetResult>(items: myPetMemberData))
            sectionSubject.accept(updateSection)
        }
    }
    
    //MARK: - UI Components
    
    private var petLabel = UILabel()
    public var petCountLabel = UILabel()
    public lazy var petCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        register()
        
        configureCollectionViewDataSource()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionData<PetResult>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyPetCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as? MyPetCollectionViewCell else { return UICollectionViewCell() }
                cell.dataBind(item)
                return cell
            }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
                guard kind == UICollectionView.elementKindSectionFooter,
                      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyPetCollectionFooterView.reuseCellIdentifier, for: indexPath) as? MyPetCollectionFooterView else { return UICollectionReusableView() }
                footer.delegate = self
                return footer
            })
    }
    
    
    
    //MARK: - Custom Method
    
    private func configureCollectionView() {
        guard let dataSource else { return }
        sectionSubject
            .bind(to: petCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func register() {
        petCollectionView.register(
            MyPetCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPetCollectionViewCell.cellIdentifier)
        
        petCollectionView.register(
            MyPetCollectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MyPetCollectionFooterView.reuseCellIdentifier)
    }
    
    
    private func style() {
        self.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 12)
        }
        
        petLabel.do {
            $0.text = "반려동물"
            $0.textColor = .zoocDarkGray1
            $0.font = .zoocSubhead1
        }
        
        petCountLabel.do {
            $0.textColor = .zoocGray2
            $0.font = .zoocCaption
            $0.textAlignment = .center
        }
        
        petCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layout.footerReferenceSize = CGSize(width: 70, height: 40)
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = layout
            $0.delegate = self
        }
    }
    
    private func hierarchy() {
        addSubviews(petLabel, petCountLabel, petCollectionView)
    }
    
    private func layout() {
        petLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(26)
        }
        
        petCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(self.petLabel.snp.trailing).offset(4)
        }
        
        petCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.petLabel.snp.bottom).offset(17)
            $0.leading.equalTo(self.petLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(26)
        }
    }
    
    public func updateUI(_ myPetMemberData : [PetResult]) {
        petCountLabel.text = "\(myPetMemberData.count)/4"
        self.myPetMemberData = myPetMemberData
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyPetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = MyPetCollectionViewCell()
        cell.dataBind(myPetMemberData[indexPath.item])
        return cell.sizeFittingWith(cellHeight: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.petCellTapped(pet: myPetMemberData[indexPath.item])
    }
}


//MARK: - RegisterPetButtonTappedDelegate

extension MyPetView: RegisterPetButtonTappedDelegate {
    func registerPetButtonTapped(isSelected: Bool) {
        delegate?.myRegisterPetButtonTapped(isSelected: isSelected)
    }
}
