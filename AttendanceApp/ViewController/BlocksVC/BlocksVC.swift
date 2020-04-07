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
        hookupViewModelItems(to: dataSource) // display items (cells)
        hookUpTableViewDidSelect() // tableView didSelect
    }
    
    private func hookupViewModelItems(to dataSource: RxTableViewSectionedReloadDataSource<SectionOfCustomData>) {
        
        blockViewModel.getItems(date: selectedDate)
                        .bind(to: tableView.rx.items(dataSource: dataSource))
                        .disposed(by: disposeBag)
    }
    
    
//    private func hookUpTableViewDidSelect() {
//        tableView.rx.itemSelected // (**)
//            .subscribe(onNext: { [weak self] ip in guard let strongSelf = self else {return}
//
//                var rBlock: RealmBlock!
//                strongSelf.source
//                    .subscribe(onNext: { (sections) in
//
//                        print("BlockVC.hookUpTableViewDidSelect.sections.count = \(sections.count)")
//
//                        if let selectedDate = strongSelf.selectedDate {
//
//                            if let blockGroup = strongSelf.blockViewModel.sectionBlocks.first(where: { groups -> Bool in
//
//                                Calendar.current.isDate(groups.first!.starts_at,
//                                                        inSameDayAs: selectedDate)
//                            }) {
//                                rBlock = blockGroup[ip.row]
//                            } else {
//                                print("o-o, should never get here....")//; fatalError()
//                            }
//                        } else {
//                            let sectionBlocks = strongSelf.blockViewModel.sectionBlocks
//                            guard sectionBlocks.count > ip.section else {return}
//                            guard sectionBlocks[ip.section].count > ip.row else {return}
//                            rBlock = sectionBlocks[ip.section][ip.row]
//                        }
//                    }).disposed(by: strongSelf.disposeBag)
//
//                strongSelf.selBlock.onNext(rBlock!.id)
//                strongSelf.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
//
//    }
    
    private func hookUpTableViewDidSelect() {
        
        tableView.rx.itemSelected.map { (ip) -> IBlock in
            self.blockViewModel.transform(indexPath: ip)
        }.subscribe(onNext: { (block) in
            self.selBlock.onNext(block.getId())
        }).disposed(by: disposeBag)
        
        
        
//        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
//            blockViewModel.transform(indexPath: indexPath)
//        })

//                strongSelf.selBlock.onNext(rBlock!.id)
//                strongSelf.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)

    }
    
    private let disposeBag = DisposeBag()
    
}
