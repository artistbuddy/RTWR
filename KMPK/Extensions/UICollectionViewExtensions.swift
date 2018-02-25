import UIKit

// MARK:- BatchUpdates
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
