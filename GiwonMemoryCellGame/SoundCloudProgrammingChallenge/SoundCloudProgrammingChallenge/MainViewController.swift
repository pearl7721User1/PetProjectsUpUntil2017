//
//  ViewController.swift
//  SoundCloudProgrammingChallenge
//

import UIKit

// the total number of memory cells
let memoryCellsTotal = 16

// the second it takes to flip the memory cell
let flipAnimationDuration = 0.3

// if the memory cell pair are not matched, they stay face-up for 1.5 seconds before they face-down
let cellHoldingDuration = 1.5

// category of notifications that this app uses
enum CustomNotification: String {
    case ImageDownloadCompleted
}

// This ViewController consists of one MemoryCellViewController and one DashboardViewController. The MemoryCellViewController object manages memory cells and their operations; The DashboardViewController object manages displaying statistics that involves this game.
class MainViewController: UIViewController {

    // ImageSourceClient object takes care of this view controller's api call needs, which is to download the json data and figure out image files to download, and download them to populate memory cells.
    private lazy var imageSourceClient: ImageSourceClient = ImageSourceClient()
    
    // computed property to access this view controller's MemoryCellViewController object
    private var memoryCellViewController: MemoryCellViewController {
        guard let memoryCellViewController = childViewControllers.filter({ $0.isKind(of: MemoryCellViewController.self)})[0] as? MemoryCellViewController else { fatalError("memoryCellViewController is not available to use") }

        return memoryCellViewController
    }
    
    // computed property to access this view controller's DashboardViewController object
    private var dashboardViewController: DashboardViewController {
        guard let dashboardViewController = childViewControllers.filter({ $0.isKind(of: DashboardViewController.self)})[0] as? DashboardViewController else { fatalError("dashboardViewController is not available to use") }
        
        return dashboardViewController
    }
    
    // label to show the program status
    @IBOutlet weak var programStateLabel: UILabel!
    
    // Each enumeration case states the current state that this game is in. 'Loading' indicates preparation state for the game; 'GameStarted' indicates the game can be started; 'ErrorOccurred' indicates an error has occurred and the game can't be started.
    enum ProgramState: String {
        case Loading, GameStarted, ErrorOccurred
    }
    
    private var programState: ProgramState = .Loading {
        didSet {
            programStateLabel.text = programState.rawValue
        }
    }
    
    // configure initial settings, and prepare for game start
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        resetGame()
    }
    
    // function for initial settings, which includes opening communication between memoryCellViewController and dashboardViewController so that dashboard labels can be updated as the user gesture occurs
    private func commonInit() {
        memoryCellViewController.delegate = dashboardViewController
    }
    
    // This function is called for the control to return to the initial state of this game, of which work includes arranging memory cell images and setting the dashboard labels to zeros.
    private func resetGame() {

        // set dashboard labels to zeros
        dashboardViewController.resetDashboard()
        
        // facedown all memory cells
        memoryCellViewController.resetMemoryCells()
        
        // do not allow flipping memory cells until memory cell images are initiated or re-initiated
        memoryCellViewController.memoryCellInteractionState = .NotReady
        
        // set the game state label to 'Loading'
        programState = .Loading
        
        // fetch images to use them as memory cell images
        imageSourceClient.fetchImageSource { (error: ImageSourceModelError?) -> (Void) in
            
            // if an error has occurred during the fetching, show an alert message
            if error != nil {
                let alertViewController = UIAlertController(title: "Error occurred", message: "Can't start the game.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertViewController.addAction(action)
                
                DispatchQueue.main.async(execute: {
                    self.present(alertViewController, animated: true, completion: nil)
                    self.programState = .ErrorOccurred
                })
            }
            else {
                // if error has not occurred, allow flipping memory cells since the game has just started
                self.memoryCellViewController.memoryCellInteractionState = .Ready
                
                DispatchQueue.main.async(execute: {
                    
                    // set the game state label to 'GameStarted'
                    self.programState = .GameStarted
                })
            }
            
        }
    }
    
    // Reset button's action handler
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        resetGame()
    }
}

