//
//  GenAISelectImageViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import SnapKit
import Then

final class GenAISelectImageViewController : BaseViewController {
    
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
        
        setNotificationCenter()
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
        
        viewModel.uploadRequestCompleted.observe(on: self) { [weak self] uploadCompleted in
            guard let uploadCompleted = uploadCompleted else { return }
            if uploadCompleted {
                self?.pushToGenAICompletedVC()
            } else {
                self?.showToast("AI 모델 생성 중 문제가 발생했습니다", type: .bad)
            }
        }
        
        viewModel.isCompleted.observe(on: self) { [weak self] isCompleted in
            // 푸시알림을 통해서 분기처리하면 좋을 거 같습니다!
            guard let isCompleted = isCompleted else { return }
            if isCompleted {
                self?.showToast("AI 모델 생성이 완료되었습니다", type: .good)
            } else {
                self?.showToast("AI 모델 생성 중 문제가 발생했습니다", type: .bad)
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
        rootView.generateAIModelButton.addTarget(self, action: #selector(generateAIModelButtonDidTap), for: .touchUpInside)
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(petIdReceived(_:)),
            name: .petSelected,
            object: nil
        )
    }
    
    //MARK: - Action Method
    
    @objc func xmarkButtonDidTap() {
        presentAlertViewController()
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @objc func generateAIModelButtonDidTap() {
        viewModel.generateAIModelButtonDidTapEvent()
    }
    
    @objc func petIdReceived(_ notification: Notification) {
        viewModel.observePetIdEvent(notification: notification)
    }
}

extension GenAISelectImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 20) / 3
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
extension GenAISelectImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.petImageDatasets.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier, for: indexPath) as? GenAIPetImageCollectionViewCell else {
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
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    func pushToGenAICompletedVC() {
        let genAICompletedVC = GenAICompletedViewController()
        self.navigationController?.pushViewController(genAICompletedVC, animated: true)
    }
}

extension GenAISelectImageViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}
