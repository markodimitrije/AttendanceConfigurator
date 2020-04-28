//
//  Mock.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlocksFromJsonFileLoader {
    static func make(filename: String) -> [IBlock] {
        let bundle = Bundle(for: self)
        let jsonData = JsonBundleDataProvider().jsonData(filename: filename, inBundle: bundle)
        let decoder = BlockDecoderFactory.make()//JSONDecoder()
        let blocksObject = try! decoder.decode(Blocks.self, from: jsonData)
        return blocksObject.data
    }
}

class RoomsFromJsonFileLoader {
    static func make(filename: String) -> [IRoom] {
        let bundle = Bundle(for: self)
        let jsonData = JsonBundleDataProvider().jsonData(filename: filename, inBundle: bundle)
        let roomsObject = try! JSONDecoder().decode(Rooms.self, from: jsonData)
        return roomsObject.data
    }
}

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
