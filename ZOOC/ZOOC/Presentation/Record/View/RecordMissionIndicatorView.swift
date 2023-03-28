//
//  RecordMissionIndicatorView.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

final class RecordMissionIndicatorView : UIView{
    
    //MARK: - Properties
    
    private var leftInsetConstraint: Constraint?
    
    var leftOffsetRatio: Double? {
      didSet {
        guard let leftOffsetRatio = self.leftOffsetRatio else { return }
        self.leftInsetConstraint?.update(inset: leftOffsetRatio * self.bounds.width)
      }
    }
    
    var widthRatio: Double? {
      didSet {
        guard let widthRatio = self.widthRatio else { return }
        self.indicatorTintView.snp.remakeConstraints {
          $0.top.bottom.equalToSuperview()
          $0.width.equalToSuperview().multipliedBy(widthRatio)
          $0.left.greaterThanOrEqualToSuperview()
          $0.right.lessThanOrEqualToSuperview()
          self.leftInsetConstraint = $0.left.equalToSuperview().priority(900).constraint
        }
      }
    }

    
    //MARK: - UI Components
    
    private let indicatorView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .zoocLightGreen
    }
    
    private let indicatorTintView = UIView().then {
        $0.backgroundColor = .zoocDarkGreen
    }
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        self.addSubview(indicatorView)
        indicatorView.addSubview(indicatorTintView)
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorTintView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1/6)
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
            leftInsetConstraint = $0.left.equalToSuperview().priority(900).constraint
        }
    }
    
    //MARK: - Action Method
    
}
