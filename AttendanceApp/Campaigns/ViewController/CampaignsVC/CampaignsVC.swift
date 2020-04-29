//
//  CampaignsVC.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CampaignsVC: UIViewController, Storyboarded {
    
    var viewModel: ICampaignsViewModel!
    var navBarConfigurator: INavigBarConfigurator!
    var logoutHandler: ILogoutHandler!
    var campaignSelectionRepo: ICampaignSelectionRepository = CampaignSelectionRepositoryFactory.make()
    
    @IBOutlet weak var tableView: UITableView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutBtn = LogoutButtonFactory().make(target: self.logoutHandler)
        navBarConfigurator.configure(navigationItem: navigationItem, btn: logoutBtn)
        self.bindCampaignsViewModel()
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        campaignSelectionRepo.userSelected(campaignItem: nil)
        viewModel.refreshCampaigns()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func bindCampaignsViewModel() {
        viewModel.getCampaigns()
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                guard let cell = cell as? CampaignTableViewCell else {
                    return
                }
                cell.update(item: item)
            }
            .disposed(by: bag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ICampaignItem.self))
            .bind { [weak self] indexPath, item in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.campaignSelectionRepo.userSelected(campaignItem: item)
                let nextVC = ScannerViewControllerFactory.make()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: bag)
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib.init(nibName: "CampaignTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    deinit {
        print("CampaignsVC.deinit")
    }
    
}
