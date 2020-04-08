//
//  BlocksDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxDataSources

class BlocksDataSourceFactory {
    
    static func make() -> RxTableViewSectionedReloadDataSource<BlocksSectionOfCustomData> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<BlocksSectionOfCustomData>(
            configureCell: { _, tableView, indexPath, item in
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
        return dataSource
    }
}
