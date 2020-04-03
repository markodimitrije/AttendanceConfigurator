//
//  ViewController.swift
//  tryObservableWebApiAndRealm
//
//  Created by Marko Dimitrijevic on 19/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealmDataSources

class RoomsVC: UIViewController {    

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let roomViewModel = RoomViewModel()
    
    fileprivate let selRealmRoom = PublishSubject<Int?>()
    
    var selRoomDriver: SharedSequence<DriverSharingStrategy, Int?> {
        return selRealmRoom.asDriver(onErrorJustReturn: nil)
    }

    override func viewDidLoad() { super.viewDidLoad()
        populateTableView()
    }

    private func populateTableView() {
        // bind dataSource
        let dataSource = RxTableViewRealmDataSource<RealmRoom>(cellIdentifier:
        "cell", cellType: UITableViewCell.self) { cell, _, rRoom in
            cell.textLabel?.text = rRoom.name
        }
        
        roomViewModel.oRooms
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension RoomsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRoom = roomViewModel.getRoom(forSelectedTableIndex: indexPath.item)
        
        selRealmRoom.onNext(selectedRoom.getId())
    }
}
