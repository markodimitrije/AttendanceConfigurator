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
import Realm
import RealmSwift
import RxRealmDataSources

class BlocksVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedRoomId: Int! // ovo ce ti setovati segue // moze li preko Observable ?
    
    let disposeBag = DisposeBag()
    
    lazy var blockViewModel = BlockViewModel(roomId: selectedRoomId)
    
    fileprivate let selRealmBlock = PublishSubject<RealmBlock>()
    var selectedRealmBlock: Observable<RealmBlock> { // exposed selRealmBlock
        return selRealmBlock.asObservable()
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        
        // tableView dataSource
        
        let dataSource = RxTableViewRealmDataSource<RealmBlock>(cellIdentifier:
        "cell", cellType: UITableViewCell.self) { cell, _, rRoom in
            cell.textLabel?.text = rRoom.starts_at + rRoom.name
        }
        
        
        blockViewModel.oBlocks
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
        
        
        // tableView didSelect
        tableView.rx.itemSelected // (**)
            .subscribe(onNext: { [weak self] ip in
                guard let strongSelf = self else {return}
                let selectedBlock = strongSelf.blockViewModel.blocks[ip.item]
                strongSelf.selRealmBlock.onNext(selectedBlock)
                strongSelf.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }

}

extension BlocksVC: UITableViewDelegate {} // bez ovog puca app, (**)
