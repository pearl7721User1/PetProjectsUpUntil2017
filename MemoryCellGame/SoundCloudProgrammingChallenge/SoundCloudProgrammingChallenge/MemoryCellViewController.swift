//
//  MemoryCellViewController.swift
//  SoundCloudProgrammingChallenge
//

import UIKit

// a protocol to communicate with the DashboardViewController object
protocol DashboardUpdateProtocol {
    
    func didTry(from memoryCellViewController: MemoryCellViewController, hit isHit: Bool)
}

// This View Controller manages memory cells and their operations.
class MemoryCellViewController: UIViewController {
    
    // memory cells that this view controller manages
    @IBOutlet var memoryCells: [MemoryCellView]!
    
    // to update the dashboard's trial, hit count
    var delegate: DashboardUpdateProtocol?
    
    // to prevent the user's interaction with memory cells for some cases
    enum MemoryCellInteractionState {
        case Ready, NotReady
    }
    
    var memoryCellInteractionState: MemoryCellInteractionState = .NotReady
    
    
    // to hold the reference to the memory cell pair for equivalence matching
    var memoryCellPair = [MemoryCellView]() {
        didSet {
            
            if (memoryCellPair.count >= 2) {
                
                // If a pair is made, see if they match. If they match, make them stay face-up, and report to the dashboard
                if memoryCellPair[0] == memoryCellPair[1] {
                    delegate?.didTry(from: self, hit: true)
                    self.memoryCellPair.removeAll()
                }
                else {
                    // if they don't match, give it a moment and face them down, and report to the dashboard
                    delegate?.didTry(from: self, hit: false)
                    
                    // do not allow flipping memory cells while the pair stays face up for a while
                    memoryCellInteractionState = .NotReady
                    
                    let deadlineTime = DispatchTime.now() + .milliseconds(Int(cellHoldingDuration * 1000))
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        
                        // face down the pair
                        self.memoryCellPair[0].undoHold()
                        self.memoryCellPair[1].undoHold()
                        
                        // remove the reference of the pair
                        self.memoryCellPair.removeAll()
                        
                        // user gesture back on
                        self.memoryCellInteractionState = .Ready
                        
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This View Controller observes notification that comes from the ImageSourceClient object that has been implemented inside the MainViewController object. The notification message delivers images and it populates memory cells.
        let notification: CustomNotification = .ImageDownloadCompleted
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceiver(_:)), name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
        
        // makes this view controller as the delegate(that conforms to MemoryCellViewProtocol) to each memory cell
        for memoryCell in memoryCells {
            memoryCell.delegate = self
        }
    }

    // notification handler for 'ImageDownloadCompleted' message
    func notificationReceiver(_ notification: Notification) {
        
        // This notification delivers images for memory cells. Each image is distributed to memory cell by referring to the array 'Indexes'. As a result, memory cells have eight pairs of images.
        guard let infoDict = notification.userInfo as? [String: Any],
            let indexes = infoDict["Indexes"] as? [Int],
            let artWorks = infoDict["ArtWorks"] as? [UIImage]
        else { fatalError("Something went wrong with 'ImageDownloadCompleted' notification delivery") }
        
        // ensure that the size of each array is what it's intended to be so that there are eight pair of images
        assert(indexes.count == memoryCells.count && indexes.count / 2 == artWorks.count)

        // distribute the image to each memory cell
        for i in 0...indexes.count-1 {
            
            let imgIdx = indexes[i]
            memoryCells[i].image = artWorks[imgIdx]
        }
    }
    
    // function to carry out 'Reset' command
    func resetMemoryCells() {
        
        // face down all memory cells
        for memoryCell in memoryCells {
            memoryCell.resetCellState()
        }
    }
}

// This View Controller conforms to MemoryCellViewProtocol.
extension MemoryCellViewController: MemoryCellViewProtocol {
    
    // called when memory cell is faced up by the user's tap gesture
    func didCellFlipped(from cell:MemoryCellView) {
        
        // make the memory cell hold the position
        cell.hold()
        
        // create a pair of memory cells
        memoryCellPair.append(cell)
    }
    
    // to prevent the user's interaction with memory cells for some cases
    func shouldAllowCellFlip() -> Bool {
        
        return self.memoryCellInteractionState == .Ready
    }
}
