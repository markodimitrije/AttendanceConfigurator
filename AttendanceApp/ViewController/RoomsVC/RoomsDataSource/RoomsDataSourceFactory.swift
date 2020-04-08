//
//  RoomsDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxDataSources

class RoomsDataSourceFactory {
    
    static func make() -> RxTableViewSectionedReloadDataSource<RoomsSectionOfCustomData> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<RoomsSectionOfCustomData>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.name
                return cell
        })
        
        return dataSource
    }
}
