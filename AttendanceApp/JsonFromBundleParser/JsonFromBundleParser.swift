//
//  ParseJsonFromBundle.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

class JsonFromBundleParser {
    static func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                fatalError("can't find json file in Bundle !")
            }
        }
        return json
    }
}

// JsonFromBundleParser.readJSONFromFile(fileName: cities)
// JsonFromBundleParser.readJSONFromFile(fileName: citiesUpdated)
