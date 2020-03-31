//
//  Unziper.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class Unziper: NSObject, IUnziper {
    var conferenceId: Int
    init(conferenceId: Int) {
        self.conferenceId = conferenceId
    }
 
    func saveDataAsFile(data: Data) -> Observable<Bool> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else { fatalError("Only works on live instance") }
            do {
                let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = "\(strongSelf.conferenceId).zip"
                let filePath = directoryURLs[0].appendingPathComponent(fileName)
                try data.write(to: filePath)
                observer.onNext(true)
            } catch {
                observer.onNext(false)
            }
            return Disposables.create()
        })
    }
 
    func unzipData(success: Bool) -> Observable<Data> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else { fatalError("Only works on live instance") }
         
            do {
                let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = "\(strongSelf.conferenceId).zip"
                let filePath = directoryURLs[0].appendingPathComponent(fileName)
                let unzipDirectory = try Zip.quickUnzipFile(filePath)
                let unzippedFilePath = unzipDirectory.appendingPathComponent("\(strongSelf.conferenceId).json")
             //let string = try String(contentsOf: unzippedFilePath)
                guard let data = try? Data.init(contentsOf: unzippedFilePath) else {
                    fatalError("cant get data from zip")
                }
             
                try FileManager.default.removeItem(at: filePath)
                try FileManager.default.removeItem(at: unzippedFilePath)
                try FileManager.default.removeItem(at: unzipDirectory)
                observer.onNext(data)
            } catch let err {
                observer.onError(err)
            }
            return Disposables.create()
        })
    }
}
