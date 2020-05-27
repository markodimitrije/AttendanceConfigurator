//
//  DatesViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatesViewmodel: NSObject, UITableViewDelegate {
    
    private let blockRepo: IBlockImmutableRepository
    private weak var delegate: DatesViewController?
    
    // OUTPUT
    private (set) var selectedDate = PublishSubject<Date?>.init()
    
    var dates = [Date]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.tableView.reloadData()
            }
        }
    }
    
    init(delegate: DatesViewController?, blockRepo: IBlockImmutableRepository) {
        self.blockRepo = blockRepo
        self.delegate = delegate
        super.init()
        loadDates()
    }
    
    private func loadDates() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            print("Thread = \(Thread.current)")
            guard let sSelf = self else {return}
            sSelf.dates = sSelf.blockRepo.getAvailableDates(roomId: nil)
        }
        print("Thread = \(Thread.current)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateSelected = dates[indexPath.row]
        selectedDate.onNext(dateSelected)
    }
    
}
