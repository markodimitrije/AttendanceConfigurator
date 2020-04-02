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
    
    fileprivate let selBlock = PublishSubject<Int>()
    var selectedBlock: Observable<Int> { // exposed selRealmBlock
        return selBlock.asObservable()
    }
    
    var selectedInterval = BehaviorRelay.init(value: MyTimeInterval.waitToMostRecentSession)
    
    private var source: Observable<[SectionOfCustomData]>!
    
    override func viewDidLoad() { super.viewDidLoad()
        bindUI()
        navigationItem.title = "SESSIONS"
    }
    
    private func bindUI() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = item.date.toString(format: Date.defaultFormatString)
//                if Calendar.current.isDateInToday(item.date) {
//                    cell.backgroundColor = .green
//                }
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        loadTableViewDataSourceUponSelectedDate() // one or many sections...
        
        hookupTableViewItems(to: dataSource) // display items (cells)
        
        hookUpTableViewDidSelect() // tableView didSelect
        
        blockViewModel.oAutoSelSessInterval
            .asObservable()
            .subscribe(onNext: { [weak self] seconds in
                guard let sSelf = self else {return}
                sSelf.selectedInterval.accept(seconds)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func hookupTableViewItems(to dataSource: RxTableViewSectionedReloadDataSource<SectionOfCustomData>) {
        source
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func loadTableViewDataSourceUponSelectedDate() { // tableView dataSource
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
    }
    
    private func hookUpTableViewDidSelect() {
        tableView.rx.itemSelected // (**)
            .subscribe(onNext: { [weak self] ip in guard let strongSelf = self else {return}
                
                var rBlock: RealmBlock!
                strongSelf.source
                    .subscribe(onNext: { (sections) in
                        
                        print("BlockVC.hookUpTableViewDidSelect.sections.count = \(sections.count)")
                        
                        if let selectedDate = strongSelf.selectedDate {
                            
                            if let blockGroup = strongSelf.blockViewModel.sectionBlocks.first(where: { groups -> Bool in
                                
                                Calendar.current.isDate(Date.parse(groups.first!.starts_at), inSameDayAs: selectedDate)
                                
                            }) {
                                rBlock = blockGroup[ip.row]
                            } else {
                                print("o-o, should never get here....")//; fatalError()
                            }
                        } else {
                            let sectionBlocks = strongSelf.blockViewModel.sectionBlocks
                            guard sectionBlocks.count > ip.section else {return}
                            guard sectionBlocks[ip.section].count > ip.row else {return}
                            rBlock = sectionBlocks[ip.section][ip.row]
                        }
                    }).disposed(by: strongSelf.disposeBag)

                strongSelf.selBlock.onNext(rBlock!.id)
                strongSelf.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private let disposeBag = DisposeBag()
    
}
