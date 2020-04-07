//
//  BlocksFromJsonFileLoader.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
@testable import AttendanceApp

class BlocksFromJsonFileLoader {
    static func make(filename: String) -> [IBlock] {
        let bundle = Bundle(for: self)
        let jsonData = JsonBundleDataProvider().jsonData(filename: filename, inBundle: bundle)
        let decoder = BlockDecoderFactory.make()//JSONDecoder()
        let blocksObject = try! decoder.decode(Blocks.self, from: jsonData)
        return blocksObject.data
    }
}
