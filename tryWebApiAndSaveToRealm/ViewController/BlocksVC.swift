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
import RxDataSources // ovaj ima rx Sectioned TableView

class BlocksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // INPUT
    var selectedDate: Date? // ovo ce ti neko javiti (settingsVC)
    var selectedRoomId: Int! // ovo ce ti setovati segue // moze li preko Observable ?
    
    lazy var blockViewModel = BlockViewModel(roomId: selectedRoomId)
    
    fileprivate let selBlock = PublishSubject<Block>()
    var selectedBlock: Observable<Block> { // exposed selRealmBlock
        return selBlock.asObservable()
    }
    
    var selectedInterval = BehaviorRelay.init(value: MyTimeInterval.waitToMostRecentSession)
    
    override func viewDidLoad() { super.viewDidLoad()
        bindUI()
        navigationItem.title = "SESSIONS"
    }
    
    private func bindUI() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.name
                if Calendar.current.isDateInToday(item.date) {
                    cell.backgroundColor = .green
                }
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        var source: Observable<[SectionOfCustomData]>
        
        // tableView dataSource
        if let selectedDate = selectedDate {
            
            source = blockViewModel.oSectionsHeadersAndItems.flatMap({ sections -> BehaviorRelay<[SectionOfCustomData]> in
                let section = sections.first(where: { section -> Bool in
                    return Calendar.current.isDate(section.items.first!.date, inSameDayAs: selectedDate)
                }) ?? SectionOfCustomData(header: "", items: [])
                return BehaviorRelay.init(value: [section])
            })
            
        } else {
            source = blockViewModel.oSectionsHeadersAndItems.asObservable()
        }
        
        source
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // tableView didSelect
        tableView.rx.itemSelected // (**)
            .subscribe(onNext: { [weak self] ip in guard let strongSelf = self else {return}

                var rBlock: RealmBlock!
                source
                    .subscribe(onNext: { (sections) in
                        
                        if let selectedDate = strongSelf.selectedDate {
                            
                            if let blockGroup = strongSelf.blockViewModel.sectionBlocks.first(where: { groups -> Bool in
                                
                                Calendar.current.isDate(Date.parse(groups.first!.starts_at), inSameDayAs: selectedDate)
                                
                            }) {
                                rBlock = blockGroup[ip.row]
                            } else {
                                print("o-o, should never get here...."); fatalError()
                            }
                        } else {
                            let sectionBlocks = strongSelf.blockViewModel.sectionBlocks
                            guard sectionBlocks.count > ip.section else {return}
                            guard sectionBlocks[ip.section].count > ip.row else {return}
                            rBlock = sectionBlocks[ip.section][ip.row]
                        }
                    }).disposed(by: strongSelf.disposeBag)
                
                let selectedBlock = Block(with: rBlock)
                strongSelf.selBlock.onNext(selectedBlock)
                strongSelf.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        blockViewModel.oAutoSelSessInterval
            .asObservable()
            .subscribe(onNext: { [weak self] seconds in
                guard let sSelf = self else {return}
                sSelf.selectedInterval.accept(seconds)
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
}
