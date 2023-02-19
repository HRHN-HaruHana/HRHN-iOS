//
//  StorageViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit

final class StorageViewModel {
    var storedItem: Observable<[StoredItem]> = Observable([])
    
    private var coreDataManager = CoreDataManager.shared
    
    init(){}
    
    func fetchStoredItems() {
        let items = self.coreDataManager.getStoredItems()
        self.storedItem = Observable(items)
    }
    
    func deleteStorageItem(item: StoredItem) {
        self.coreDataManager.deleteStoredItem(item)
        self.fetchStoredItems()
    }
    
    // TODO: 테스트용 - 설정버튼
    func addStorageItem() {
        self.coreDataManager.insertStoredItem(StoredItem(id: UUID(), content: "1234"))
        self.fetchStoredItems()
    }
}

