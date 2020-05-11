//
//  DelegatesAttendanceValidation.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

// MARK:- Fetch (querry) data

extension DelegatesAttendanceValidation: IDelegatesAttendanceValidation {
    func isScannedDelegate(withBarcode code: String, blockId: Int) -> Bool {
        
        if isClosedBlock(blockId: blockId) == false { // free block
            return true
        } else {
            return delegateHasAccessToBlock(code: code, blockId: blockId)
        }
    }
}

class DelegatesAttendanceValidation {
    private let blockRepo: IBlockImmutableRepository
    private let delegateRepo: IDelegatesImmutableRepository
    init(blockRepo: IBlockImmutableRepository, delegateRepo: IDelegatesImmutableRepository) {
        self.blockRepo = blockRepo
        self.delegateRepo = delegateRepo
    }
    
    private func isClosedBlock(blockId: Int) -> Bool {
        
        guard let block = blockRepo.getBlock(id: blockId) else {
            return false
        }
        return block.getClosed()
    }
    
    private func delegateHasAccessToBlock(code: String, blockId: Int) -> Bool {
        delegateRepo.delegateHasAccessToBlock(code: code, blockId: blockId)
    }
    
}
