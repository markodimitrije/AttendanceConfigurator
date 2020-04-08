//
//  RoomsDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxDataSources

class RoomsDataSourceFactory {
    
    static func make() -> RxTableViewSectionedReloadDataSource<RoomSectionOfCustomData> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<RoomSectionOfCustomData>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.name
                return cell
        })
        
//        dataSource.titleForHeaderInSection = { dataSource, index in
//            return dataSource.sectionModels[index].header
//        }
        return dataSource
    }
}
