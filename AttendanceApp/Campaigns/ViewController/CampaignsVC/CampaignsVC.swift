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
    
    var campaignsViewModel: ICampaignsViewModel!
    var logoutWorker: ILogoutWorker!
    var navBarConfigurator: INavigBarConfigurator!
    var alertInfo: AlertInfo!
    
    @IBOutlet weak var tableView: UITableView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindCampaignsViewModel()
        navBarConfigurator.configure(navigationItem: navigationItem, viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        campaignsViewModel.refreshCampaigns()
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
        
        campaignsViewModel.getCampaigns()
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.description
            }
            .disposed(by: bag)
    }
    
}
