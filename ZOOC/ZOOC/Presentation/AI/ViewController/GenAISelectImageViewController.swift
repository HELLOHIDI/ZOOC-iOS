//
//  GenAISelectImageViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import SnapKit
import Then

final class GenAISelectImageViewController : BaseViewController{
    
    //MARK: - Properties
    
    let viewModel: GenAISelectImageViewModel
    
    //MARK: - UI Components
    
    let rootView = GenAISelectImageView()
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAISelectImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppearEvent()
        
    }
    
    //MARK: - Custom Method
    
    func bind() {
        viewModel.showEnabled.observe(on: self) { [weak self] canShow in
            if canShow {
                self?.rootView.activityIndicatorView.stopAnimating()
                self?.rootView.petImageCollectionView.reloadData()
            } else {
                self?.rootView.activityIndicatorView.startAnimating()
            }
        }
    }
    func delegate() {
        rootView.petImageCollectionView.delegate = self
        rootView.petImageCollectionView.dataSource = self
    }
    
    
    //MARK: - Action Method
    
}

extension GenAISelectImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 20) / 3
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(#function)
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print(#function)
        return 10
    }
}
extension GenAISelectImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return viewModel.petImageDatasets.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier, for: indexPath) as? GenAIPetImageCollectionViewCell else {
            print("tlqkf")
            return UICollectionViewCell()
        }
        if viewModel.petImageDatasets.value.count > 0 {
            cell.petImageView.image = viewModel.petImageDatasets.value[indexPath.item]
        }
        return cell
    }
}

extension GenAISelectImageViewController {
    func updateUI() {
        let numberOfRows = CGFloat(viewModel.selectedImageDatasets.value.count / 3)
        let totalHeight = numberOfRows * 99 + (numberOfRows - 1) * 10 // 10은 minimumLineSpacing
        print("전체 높이 \(totalHeight)")
        rootView.petImageCollectionView.snp.remakeConstraints {
            $0.top.equalTo(rootView.subTitleLabel.snp.bottom).offset(84)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(totalHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
