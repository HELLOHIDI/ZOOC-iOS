//
//  settingMenuTableView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/02.
//

import UIKit

import SnapKit
import Then

final class SettingMenuTableView: UICollectionViewCell {
    
    //MARK: - UI Components
    
    public lazy var settingMenuTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        self.backgroundColor = .zoocBackgroundGreen
    }
    
    
    private func setLayout() {
        addSubview(settingMenuTableView)
        
        settingMenuTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func register() {
        settingMenuTableView.register(SettingMenuTableViewCell.self, forCellReuseIdentifier: SettingMenuTableViewCell.cellIdentifier)
    }
}

//MARK: - UITableViewDelegate

extension SettingMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
}

//MARK: - UITableViewDataSource

extension SettingMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingMenuModel.settingMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuTableViewCell.cellIdentifier, for: indexPath)
                as? SettingMenuTableViewCell else { return UITableViewCell() }
        cell.dataBind(model: SettingMenuModel.settingMenuData[indexPath.row])
        return cell
    }
}