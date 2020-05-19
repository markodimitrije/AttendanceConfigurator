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
    var campaignSelectionRepo: ICampaignSelectionRepository!
    
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
        //campaignSelectionRepo.userSelected(campaignItem: nil) TODO marko: should be called when resources are updated but selected block is updated from saved in settings
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.refreshCampaigns()
        }

    }
    
    private func bindCampaignsViewModel() {
        viewModel.getCampaigns()
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                guard let cell = cell as? CampaignTableViewCell else {
                    return
                }
                cell.selectionStyle = .none
                cell.update(item: item)
            }
            .disposed(by: bag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ICampaignItem.self))
            .bind { [weak self] indexPath, item in
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
