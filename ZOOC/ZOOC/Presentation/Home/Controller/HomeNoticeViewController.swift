//
//  HomeAlarmViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/13.
//

//
//  OnboardingInviteCompletedFamilyViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/10.
//

import UIKit

import SnapKit
import Then

final class HomeNoticeViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let rootView = HomeNoticeView()
    
    private var homeNoticeData: [HomeNoticeResult] = []
    
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        HomeAPI.shared.getNotice() { result in
            guard let result = self.validateResult(result) as? [HomeNoticeResult] else { return }
            self.homeNoticeData = result
            self.showNoticeView(count: self.homeNoticeData.count)
            self.rootView.noticeTableView.reloadData()
        }
    }
    
    //MARK: - Custom Method
    
    func register() {
        rootView.noticeTableView.delegate = self
        rootView.noticeTableView.dataSource = self
        rootView.noticeTableView.register(HomeNoticeTableViewCell.self, forCellReuseIdentifier: HomeNoticeTableViewCell.cellIdentifier)
        
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDelegate

extension HomeNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

//MARK: - UITableViewDataSource

extension HomeNoticeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeNoticeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeNoticeTableViewCell.cellIdentifier, for: indexPath)
                as? HomeNoticeTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.dataBind(data: homeNoticeData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let archiveModel = ArchiveModel(recordID: homeNoticeData[indexPath.row].recordID,
                                        petID: homeNoticeData[indexPath.row].petIDs[0])
        let archiveVC = ArchiveViewController(archiveModel, scrollDown: false)
        archiveVC.modalPresentationStyle = .fullScreen
        present(archiveVC, animated: true)
    }
}

extension HomeNoticeViewController {
    func showNoticeView(count: Int) {
        if count == 0 {
            rootView.defaultView.isHidden = false
        }
    }
}






