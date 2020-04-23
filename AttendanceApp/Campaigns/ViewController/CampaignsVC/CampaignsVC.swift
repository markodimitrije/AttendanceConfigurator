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
    var logoutWorker: ILogoutWorker!
    var navBarConfigurator: INavigBarConfigurator!
    var alertInfo: AlertInfo!
    
    @IBOutlet weak var tableView: UITableView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindCampaignsViewModel()
        navBarConfigurator.configure(navigationItem: navigationItem, viewController: self)
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshCampaigns()
    }
    
    @objc func logoutTap() {
        
        alert(alertInfo: self.alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { (tag) in
                switch tag {
                case 0: self.onLogoutConfirmed();
                case 1: print("dismisses alert")
                default: break
                }
            }).disposed(by: bag)
    }
    
    private func onLogoutConfirmed() {
        logoutWorker.logoutConfirmed()
        navigationController?.popViewController(animated: true)
    }
    
    private func bindCampaignsViewModel() {
        viewModel.getCampaigns()//.debounce(1, scheduler: MainScheduler.instance)
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
                print("open scanning screen for campaignId = \(item.id)") // TODO marko
                let nextVC = ScannerViewControllerFactory.make()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: bag)
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib.init(nibName: "CampaignTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
}
