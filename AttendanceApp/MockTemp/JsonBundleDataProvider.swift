//
//  Mock.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IJsonBundleDataProvider {
    func jsonData(filename: String, inBundle bundle: Bundle) -> Data
}

class JsonBundleDataProvider: IJsonBundleDataProvider {
    func jsonData(filename: String, inBundle bundle: Bundle) -> Data {
        let path = bundle.path(forResource: filename, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        return data
    }
}
