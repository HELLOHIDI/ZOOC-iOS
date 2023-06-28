//
//  uivc.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

final class HomeViewController : BaseViewController {
    
    //MARK: - Properties
    
    private var missionData: [RecordMissionResult] = [] {
        didSet {
            rootView.missionLabel.text = missionData[0].missionContent
        }
    }
    
    private var petData: [HomePetResult] = [] {
        didSet{
            rootView.petCollectionView.reloadData()
        }
    }
    
    private var archiveData: [HomeArchiveResult] = [] {
        didSet {
            rootView.archiveListCollectionView.reloadData()
            rootView.archiveGridCollectionView.reloadData() 
        }
    }
    
    //MARK: - UI Components
    
    private let guideVC = HomeGuideViewController()
    private let rootView = HomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        gesture()
        
        requestMissionAPI()
        requestTotalPetAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultsManager.validateGuideVCInHome() {
            //let guideVC = HomeGuideViewController()
            guideVC.modalPresentationStyle = .overCurrentContext
            present(guideVC, animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guideVC.dismiss(animated: false)
    }
    
    //MARK: - Custom Method
    
    private func register() {
        rootView.petCollectionView.delegate = self
        rootView.petCollectionView.dataSource = self
        
        rootView.archiveListCollectionView.delegate = self
        rootView.archiveListCollectionView.dataSource = self
        rootView.archiveGridCollectionView.delegate = self
        rootView.archiveGridCollectionView.dataSource = self
        
        rootView.petCollectionView.register(HomePetCollectionViewCell.self,
                                            forCellWithReuseIdentifier:HomePetCollectionViewCell.cellIdentifier)
        
        rootView.archiveListCollectionView.register(HomeArchiveListCollectionViewCell.self,
                                                    forCellWithReuseIdentifier: HomeArchiveListCollectionViewCell.cellIdentifier)
        
        rootView.archiveGridCollectionView.register(HomeArchiveGridCollectionViewCell.self,
                                                    forCellWithReuseIdentifier: HomeArchiveGridCollectionViewCell.cellIdentifier)
    }
    
    private func gesture() {
        rootView.noticeButton.addTarget(self,
                                        action: #selector(noticeButtonDidTap),
                                        for: .touchUpInside)
        rootView.listButton.addTarget(self,
                                      action: #selector(listButtonDidTap),
                                      for: .touchUpInside)
        
        rootView.gridButton.addTarget(self,
                                      action: #selector(galleryButtonDidTap),
                                      for: .touchUpInside)
        
        rootView.missionView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                        action: #selector(missionViewDidTap)))
        
        rootView.archiveBottomView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                        action: #selector(bottomViewDidTap)))
    }
    
    public func updateUI() {
        requestTotalPetAPI()
    }
    
    private func pushToDetailViewController(recordID: Int) {
        guard let index = rootView.petCollectionView.indexPathsForSelectedItems?[0].item else {
            fatalError("선택된 펫이 없습니다.")
        }
        let petID = petData[index].id
        
        let detailVC = ArchiveViewController()
        detailVC.dataBind(recordID: recordID, petID: petID)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
    
    private func pushToHomeAlarmViewController() {
        let noticeVC = HomeNoticeViewController()
        noticeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    private func deselectAllOfListArchiveCollectionViewCell(completion: (() -> Void)?) {
        rootView.archiveListCollectionView.indexPathsForSelectedItems?.forEach {
                rootView.archiveListCollectionView.deselectItem(at: $0, animated: false)
        }
        
        rootView.archiveListCollectionView.performBatchUpdates(nil) { _ in
            completion?()
        }
    }
    
    func selectPetCollectionView(petID: Int) {
        var index = 0
        for pet in self.petData{
            if pet.id == petID{ break }
            index += 1
        }
        
        guard index < self.petData.count else {
            print("\(#function)의 가드문")

            return
                  
                  }
        
        self.rootView.petCollectionView.selectItem(at:IndexPath(item: index, section: 0),
                                              animated: false,
                                              scrollPosition: .centeredHorizontally)
        self.view.layoutIfNeeded()
        self.rootView.petCollectionView.performBatchUpdates(nil)
        self.requestTotalArchiveAPI(petID: self.petData[index].id)

    }
    
    private func configIndicatorBarWidth(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) {
            let allWidth = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let showingWidth = scrollView.bounds.width
            if allWidth >= showingWidth {
                self.rootView.archiveIndicatorView.isHidden = false
                self.rootView.archiveIndicatorView.widthRatio = showingWidth / allWidth
            } else {
                self.rootView.archiveIndicatorView.isHidden = true
                self.rootView.archiveIndicatorView.widthRatio = 0
            }
             
            self.rootView.archiveIndicatorView.layoutIfNeeded()
        }
    }
    
    //MARK: - Network
    
    private func requestMissionAPI() {
        HomeAPI.shared.getMission(familyID: User.shared.familyID) { result in
            
            guard let result = self.validateResult(result) as? [RecordMissionResult] else { return }
            self.missionData = result
        }
    }
    
    private func requestTotalPetAPI() {
        HomeAPI.shared.getTotalPet(familyID: User.shared.familyID) { result in
            
            guard let result = self.validateResult(result) as? [HomePetResult] else { return }
            
            self.petData = result
            guard let id = self.petData.first?.id else { return }
            self.selectPetCollectionView(petID: id)
        }
    }
    
    private func requestTotalArchiveAPI(petID: Int) {
        HomeAPI.shared.getTotalArchive(petID: String(petID)) { result in
            
            guard let result = self.validateResult(result) as? [HomeArchiveResult] else { return }
            
            self.archiveData = result
            self.view.layoutIfNeeded()
            self.configIndicatorBarWidth(self.rootView.archiveListCollectionView)
        }
    }
    
    
    //MARK: - Action Method
    
    @objc
    private func missionViewDidTap() {
        let missionVC = RecordMissionViewController(recordMissionViewModel: RecordMissionViewModel(), missionList: missionData)
        let missionNVC = UINavigationController(rootViewController: missionVC)
        missionNVC.modalPresentationStyle = .fullScreen
        missionNVC.setNavigationBarHidden(true, animated: true)
        present(missionNVC, animated: true)
    }
    
    @objc
    private func noticeButtonDidTap() {
        pushToHomeAlarmViewController()
    }
    
    @objc
    private func listButtonDidTap() {
        rootView.archiveListCollectionView.isHidden = false
        rootView.archiveGridCollectionView.isHidden = true
        rootView.archiveBottomView.isHidden = false
        rootView.listButton.isSelected = true
        rootView.gridButton.isSelected = false

    }
    
    @objc
    private func galleryButtonDidTap() {
        rootView.archiveListCollectionView.isHidden = true
        rootView.archiveGridCollectionView.isHidden = false
        rootView.archiveBottomView.isHidden = true
        
        rootView.listButton.isSelected = false
        rootView.gridButton.isSelected = true
    }
    
    @objc
    private func bottomViewDidTap() {
        deselectAllOfListArchiveCollectionViewCell(completion: nil)
    }
}

//MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == rootView.petCollectionView {
            return petData.count
        }
        
        if collectionView == rootView.archiveListCollectionView {
            return archiveData.count
        }
        
        if collectionView == rootView.archiveGridCollectionView {
            return archiveData.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == rootView.petCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePetCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as?  HomePetCollectionViewCell else { return UICollectionViewCell() }
            
            cell.dataBind(data: petData[indexPath.item])
            return cell
        }
        
        if collectionView == rootView.archiveListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeArchiveListCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as?  HomeArchiveListCollectionViewCell else { return UICollectionViewCell() }
            
            cell.dataBind(data: archiveData[indexPath.item])
            return cell
        }
        
        if collectionView == rootView.archiveGridCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeArchiveGridCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as?  HomeArchiveGridCollectionViewCell else { return UICollectionViewCell() }
            
            cell.dataBind(data: archiveData[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

//MARK: - UICollectionViewDelegate

extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        if collectionView == rootView.archiveListCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HomeArchiveListCollectionViewCell else { return false }
            
            switch cell.viewType {
            case .folded:
                return true
            case .expanded:
                let id = archiveData[indexPath.item].record.id
                pushToDetailViewController(recordID: id)
                return false
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == rootView.petCollectionView {
            collectionView.performBatchUpdates(nil)
            deselectAllOfListArchiveCollectionViewCell {
                self.requestTotalArchiveAPI(petID: self.petData[indexPath.item].id )
            }
        }
        
        if collectionView == rootView.archiveListCollectionView {
            collectionView.performBatchUpdates(nil)
        }
        
        if collectionView == rootView.archiveGridCollectionView {
            let id = archiveData[indexPath.item].record.id
            pushToDetailViewController(recordID: id)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath)
    {
        if collectionView == rootView.petCollectionView {
            collectionView.performBatchUpdates(nil)
        }
        
        if collectionView == rootView.archiveListCollectionView {
            collectionView.performBatchUpdates(nil)
        }
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == rootView.petCollectionView {
            
            switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
                print("🙏🙏선택된 펫 알약 컬렉션뷰셀의 size")
                guard let cell = collectionView.cellForItem(at: indexPath) as? HomePetCollectionViewCell else { return .zero}
                cell.dataBind(data: petData[indexPath.item])
                return  cell.sizeFittingWith(cellHeight: 40)
            default:
                print("🙏🙏디펄트에 들어옴")
                return CGSize(width: 40, height: 40)
            }
        }
        
        if collectionView == rootView.archiveListCollectionView {
            var height = collectionView.frame.height
            let spacing: CGFloat = 10
            height = height - spacing * 2
            
            switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
                return CGSize(width: 195, height: height)
            default:
                return CGSize(width: 60, height: height)
            }
        }
        
        if collectionView == rootView.archiveGridCollectionView {
            
            var width = collectionView.frame.width
            let spacing: CGFloat = 10
            width = width - (spacing * 2)
            width = width / 3
            let height = width
            return CGSize(width: width, height: height)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == rootView.petCollectionView {
            return 4
        }
        
        if collectionView == rootView.archiveListCollectionView {
            return 11
        }
        if collectionView == rootView.archiveGridCollectionView {
            return 10
        }
        
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if collectionView == rootView.petCollectionView {
            return .zero
        }
        
        if collectionView == rootView.archiveListCollectionView{
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        if collectionView == rootView.archiveGridCollectionView{
            return .zero
        }
        
        return .zero
        
    }
}

//MARK: - ScrollViewDelegate

extension HomeViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rootView.archiveListCollectionView{
            pagination(scrollView)
            
            let scroll = scrollView.contentOffset.x + scrollView.contentInset.left
            let width = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let scrollRatio = scroll / width
            
            self.rootView.archiveIndicatorView.leftOffsetRatio = scrollRatio
            
            
        }
    }
    
    func pagination(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.y
        let collectionViewContentSizeX = rootView.archiveListCollectionView.contentSize.height
        let paginationX = collectionViewContentSizeX * 0.5
        
        if contentOffsetX > collectionViewContentSizeX - paginationX {
            requestTotalPetAPI()
        }
    }
}

