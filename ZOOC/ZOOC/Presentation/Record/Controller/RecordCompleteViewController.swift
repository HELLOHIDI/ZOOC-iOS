//
//  RecordComplete.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/01/10.
//

import UIKit

import SnapKit

final class RecordCompleteViewController : BaseViewController {
    
    //MARK: - Properties
    
    var firstPetID: Int?
    
    //MARK: - UI Components
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.zoocSubGreen.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 14
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "등록 완료!"
        label.textColor = .zoocDarkGray1
        label.font = .zoocSubhead2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가족들에게 게시글 알림을 보냈어요!"
        label.textColor = .zoocGray1
        label.font = .zoocBody2
        return label
    }()
    
    private let notifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.graphics7
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var goArchiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("아카이브 보러 가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.backgroundColor = .zoocMainGreen
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(goArchiveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    //MARK: - Custom Method
    
    private func setLayout(){
        view.addSubview(cardView)
        
        cardView.addSubviews(titleLabel,
                             subtitleLabel,
                             notifyImageView,
                             goArchiveButton)
            
        //MARK: - MakeConstraints
        
        cardView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.84)
            $0.height.equalToSuperview().multipliedBy(0.56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.cardView.snp.top).offset(54)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        notifyImageView.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        goArchiveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.86)
            $0.height.equalToSuperview().multipliedBy(0.11)
        }
    }
    
    func dataBind(data: [Int]){
        firstPetID = data.first
    }
    
    //MARK: - Action Method
    
    @objc
    private func goArchiveButtonDidTap() {
        
        guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController
        else {
            print("가드문에 막힘 tabVC가 없는듯")
            return }

        guard let petID = firstPetID else {
            print("가드문에 막힘 petID가 없는듯")
            return }
        
        print("가드문 통과")
        tabVC.homeViewController.selectPetCollectionView(petID: petID)
        tabVC.homeViewController.requestMissionAPI()
        self.navigationController?.previousViewController?.navigationController?.previousViewController?.dismiss(animated: true)
    }
}
