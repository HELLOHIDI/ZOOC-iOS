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
        target()
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
    
    func target() {
        rootView.xmarkButton.addTarget(self, action: #selector(xmarkButtonDidTap), for: .touchUpInside)
        rootView.reSelectedImageButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    
    //MARK: - Action Method
    
    @objc func xmarkButtonDidTap() {
        presentAlertViewController()
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
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
    func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController(.leaveAIPage)
        zoocAlertVC.exitButtonTapDelegate = self
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
}

extension GenAISelectImageViewController: ZoocAlertExitButtonTapGestureProtocol {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}
