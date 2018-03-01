import UIKit

struct BatchUpdates {
    let deleted: [Int]
    let inserted: [Int]
    let moved: [(Int, Int)]
    let reloaded: [Int]
    
    init(deleted: [Int], inserted: [Int], moved: [(Int, Int)], reloaded: [Int] = []) {
        self.deleted = deleted
        self.inserted = inserted
        self.moved = moved
        self.reloaded = reloaded
    }
    
    static func compare<T: Equatable>(oldValues: [T], newValues: [T]) -> BatchUpdates {
        var deleted = [Int]()
        var moved = [(Int, Int)]()
        
        var remainingNewValues = newValues
            .enumerated()
            .map { (element: $0.element, offset: $0.offset, alreadyFound: false) }
        
        outer: for oldValue in oldValues.enumerated() {
            for newValue in remainingNewValues {
                if oldValue.element == newValue.element && !newValue.alreadyFound {
                    if oldValue.offset != newValue.offset {
                        moved.append((oldValue.offset, newValue.offset))
                    }
                    
                    remainingNewValues[newValue.offset].alreadyFound = true
                    
                    continue outer
                }
            }
            
            deleted.append(oldValue.offset)
        }
        
        let inserted = remainingNewValues
            .filter { !$0.alreadyFound }
            .map { $0.offset }
        
        return BatchUpdates(deleted: deleted, inserted: inserted, moved: moved)
    }

}

extension UICollectionView {
    func reloadData(with batchUpdates: BatchUpdates) {
        performBatchUpdates({
            self.insertItems(at: batchUpdates.inserted.map {
                IndexPath(row: $0, section: 0) })
            self.deleteItems(at: batchUpdates.deleted.map {
                IndexPath(row: $0, section: 0) })
            self.reloadItems(at: batchUpdates.reloaded.map {
                IndexPath(row: $0, section: 0) })
            
            for movedRows in batchUpdates.moved {
                self.moveItem(
                    at: IndexPath(row: movedRows.0, section: 0),
                    to: IndexPath(row: movedRows.1, section: 0)
                )
            }
        })
    }
}
