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
    }
    
    //MARK: - Custom Method
    
    func delegate() {
        rootView.petImageCollectionView.delegate = self
        rootView.petImageCollectionView.dataSource = self
    }
    
    
    //MARK: - Action Method
    
}

extension GenAISelectImageViewController: UICollectionViewDelegateFlowLayout {}
extension GenAISelectImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.petImageDatasets.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier, for: indexPath) as? GenAIPetImageCollectionViewCell else { return UICollectionViewCell() }
        cell.petImageView.image = viewModel.petImageDatasets.value[indexPath.item]
        return cell
    }
    
    
}
