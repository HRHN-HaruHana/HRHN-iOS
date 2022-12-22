//
//  CoreDataManager.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//  ref: https://velog.io/@leeesangheee/Core-Data-%EC%82%AC%EC%9A%A9%ED%95%B4-CRUD-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func insertChallenge(_ challenge: Challenge) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: "Challenge", in: context) else { return }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(challenge.id, forKey: "id")
        managedObject.setValue(challenge.date, forKey: "date")
        managedObject.setValue(challenge.emoji.rawValue, forKey: "emoji")
        managedObject.setValue(challenge.content, forKey: "content")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchChallenges() -> [ChallengeMO] {
        
        guard let context = self.context else { return [] }
        
        let fetchRequest = NSFetchRequest<ChallengeMO>(entityName: "Challenge")
        let sort = NSSortDescriptor(key: #keyPath(ChallengeMO.date), ascending: false) // by latest
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func getChallenges() -> [Challenge] {
        var challenges: [Challenge] = []
        let fetchResults = fetchChallenges()
        for result in fetchResults {
            let challenge = Challenge(id: result.id,
                                      date: result.date,
                                      content: result.content,
                                      emoji: Emoji(rawValue:
                                                    result.emoji)!)
            challenges.append(challenge)
        }
        return challenges
    }
    
    func updateChallenge(_ challenge: Challenge) {
        let fetchResults = fetchChallenges()
        for result in fetchResults {
            if isSameDay(date1: result.date, date2: challenge.date) {
                result.emoji = challenge.emoji.rawValue
                result.content = challenge.content
            }
        }
        appDelegate?.saveContext()
    }
    
    
    func getChallengeOf(_ date: Date) -> [Challenge] {
        var challenges: [Challenge] = []
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            let resultsByDate = fetchResults.filter({ isSameDay(date1: date, date2: $0.date)})
            for result in resultsByDate {
                let challenge = Challenge(id: result.id,
                                          date: result.date,
                                          content: result.content,
                                          emoji: Emoji(rawValue:
                                                        result.emoji)!)
                challenges.append(challenge)
            }
            return challenges
        } else {
            return []
        }
    }
    
    func deleteChallenge(_ date: Date) {
        guard let context = self.context else { return }
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            let challenge = fetchResults.filter({ isSameDay(date1: date, date2: $0.date) })[0]
            context.delete(challenge)
            appDelegate?.saveContext()
        } else {
            // TODO: - 에러처리
            print("삭제할 데이터가 없습니다.")
        }
    }
    
    func deleteAllChallenges() {
        guard let context = self.context else { return }
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            for result in fetchResults {
                context.delete(result)
            }
            appDelegate?.saveContext()
        } else {
            // TODO: - 에러처리
            print("삭제할 데이터가 없습니다.")
        }
    }
    
}

extension CoreDataManager {
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}
