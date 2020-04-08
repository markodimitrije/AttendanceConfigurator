//
//  BlocksVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources // ovaj ima rx Sectioned TableView

class BlocksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // INPUT
    var selectedDate: Date? // ovo ce ti neko javiti (settingsVC)
    var selectedRoomId: Int! // TODO marko: better through dataSource injected through init
    
    lazy var blockViewModel = BlockViewModelFactory.make(roomId: selectedRoomId)
    
    fileprivate let selBlock = PublishSubject<Int>()
    var selectedBlock: Observable<Int> { // exposed selRealmBlock
        return selBlock.asObservable()
    }
    
    private var source: Observable<[SectionOfCustomData]>!
    
    override func viewDidLoad() { super.viewDidLoad()
        bindUI()
        navigationItem.title = "SESSIONS"
    }
    
    private func bindUI() {
        
        let dataSource = BlocksDataSourceFactory.make()
        bindViewModelItems(to: dataSource) // display items (cells)
        listenTableViewDidSelect() // tableView didSelect
    }
    
    private func bindViewModelItems(to dataSource: RxTableViewSectionedReloadDataSource<SectionOfCustomData>) {
        
        blockViewModel.getItems(date: selectedDate)
                        .bind(to: tableView.rx.items(dataSource: dataSource))
                        .disposed(by: disposeBag)
    }
    
    private func listenTableViewDidSelect() {
        
        tableView.rx.itemSelected.map { (ip) -> IBlock in
            self.blockViewModel.transform(indexPath: ip)
        }.subscribe(onNext: { (block) in
            self.selBlock.onNext(block.getId())
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

    }
    
    private let disposeBag = DisposeBag()
    
}
