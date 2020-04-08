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
import RxDataSources

class RoomsVC: UIViewController {    

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let roomViewModel = RoomViewModel()
    
    fileprivate let _selectedRoom = PublishSubject<Int?>()
    var selRoomDriver: SharedSequence<DriverSharingStrategy, Int?> {
        return _selectedRoom.asDriver(onErrorJustReturn: nil)
    }

    override func viewDidLoad() { super.viewDidLoad()
        populateTableView()
    }

    private func populateTableView() {

        let dataSource = RoomsDataSourceFactory.make()
        roomViewModel.obsRooms!
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension RoomsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = roomViewModel.getRoom(forSelectedTableIndex: indexPath.item)
        _selectedRoom.onNext(selectedRoom.getId())
    }
}
