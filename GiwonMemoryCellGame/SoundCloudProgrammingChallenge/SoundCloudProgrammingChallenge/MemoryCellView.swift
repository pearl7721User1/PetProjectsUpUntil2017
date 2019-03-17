//
//  MemoryCellView.swift
//  SoundCloudProgrammingChallenge
//

import UIKit

protocol MemoryCellViewProtocol {
    
    // if tap gesture occurs, it reports to the object that implements MemoryCellViewProtocol
    func didCellFlipped(from cell:MemoryCellView)
    
    // asks the implementor if it should allow tap gesture
    func shouldAllowCellFlip() -> Bool
}

// This class represents a memory cell that constitutes the memory cell game.
class MemoryCellView: UIView {

    // The MemoryCellViewController object implements MemoryCellViewProtocol so that this memory cell can communicate with it. When a user gesture kicks in, it reports to the MemoryCellViewController object for necessary works.
    var delegate: MemoryCellViewProtocol?
    
    // face-down memory cell view
    private let faceDownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    // face-up memory cell view
    private let imageView = UIImageView()
    
    // memory cell's hidden image
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // the state that memory cell is in
    enum CellState {
        case FaceUp, FaceDown, Hold
    }
    
    // as soon as the memory cell state is set, it animates to reflect the state
    var memoryCellState: CellState = .FaceDown {
        didSet {
            animateMemoryCell()
        }
    }
    
    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    
    private func commonInit() {
        // add facedown view and faceup view to the view hierarchy
        self.addSubview(imageView)
        self.addSubview(faceDownView)
        
        // add this view's tap gesture recognizer
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        self.addGestureRecognizer(gr)
        
    }
    
    override func layoutSubviews() {
        
        imageView.frame = self.bounds
        faceDownView.frame = self.bounds
    }
    
    func tapRecognizer(_ gr: UITapGestureRecognizer) {
        
        // This view must ask the MemoryCellViewController object that implements MemoryCellViewProtocol before it allows flipping. Also, the Disabled state prevents this view's interaction with the user.
        if delegate?.shouldAllowCellFlip() ?? true && memoryCellState != .Hold {
            
            flip()
            delegate?.didCellFlipped(from: self)
        }
    }
    
    // toggle memory cell state between face-up and face-down
    func flip() {
        
        switch memoryCellState {
        case .FaceUp: memoryCellState = .FaceDown
        case .FaceDown: memoryCellState = .FaceUp
        default:
            break
        }
       
    }
    
    // hold the memory cell so that the state doesn't react to user gesture
    func hold() {
        memoryCellState = .Hold
    }
    
    // undo holding memory cell
    func undoHold() {
        resetCellState()
    }
    
    // force the memory cell state to face-down
    func resetCellState() {
        memoryCellState = .FaceDown
    }
    
    // animate memory cell according to the state that it is in
    private func animateMemoryCell() {

        if memoryCellState == .FaceDown {
            UIView.transition(from: imageView, to: faceDownView, duration: flipAnimationDuration, options: .transitionFlipFromLeft, completion: nil)
        } else {
            UIView.transition(from: faceDownView, to: imageView, duration: flipAnimationDuration, options: .transitionFlipFromLeft, completion: nil)
        }

    }
    
    // match is made if the image that each object owns are the same
    static func == (lhs: MemoryCellView, rhs: MemoryCellView) -> Bool {
        
        return (lhs.image == rhs.image)
    }
}

