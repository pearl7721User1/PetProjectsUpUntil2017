//
//  DownloadingView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/23/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol DownloadProgressProtocol: class {
    
    func didFinish(at view:DownloadingView)
}

class DownloadingView: UIView {

    weak var delegate: DownloadProgressProtocol?
    lazy var mainColor: UIColor = {
        return self.tintColor
    }()
    
    var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    lazy var downloadSimulator: FakeDownloadSimulator = {
        let simulator = FakeDownloadSimulator()
        simulator.delegate = self
        
        return simulator
    }()
    
    convenience init() {
        
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.init(frame:rect)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let innerRect = rect.insetBy(dx: 1, dy: 1)
        let innerRect2 = rect.insetBy(dx: 3, dy: 3)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            // set background to clear color
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            // draw rect circle
            context.setStrokeColor(mainColor.cgColor)
            context.strokeEllipse(in: innerRect)
            
            // draw rectangle
            context.setFillColor(mainColor.cgColor)
            context.fill(rect.insetBy(dx: 13, dy: 13))
            
            // draw inner rect circle
            draw(innerRect2, progress: self.progress, context: context)
        }
    }
    
    func draw(_ rect: CGRect, progress pr: CGFloat, context ctx: CGContext) {
        
        ctx.setStrokeColor(mainColor.cgColor)
        ctx.setLineWidth(4.0)
        
        let startAngle = CGFloat(CGFloat.pi/2)*3
        let endAngle = startAngle + CGFloat(CGFloat.pi/2)*4 * pr
        
        ctx.addArc(center: CGPoint(x:rect.midX, y:rect.midY), radius: rect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.strokePath()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        newSuperview == nil ? downloadSimulator.cancel() : downloadSimulator.download()
  
    }

}

extension DownloadingView: FakeDownloadSimulatorProtocol {
    
    func simulator(_ simulator: FakeDownloadSimulator, didWriteData writtenAtMoment: Int, totalWritten totalAtMoment: Int, totalExpectedToWrite totalExptected: Int) {
        
        progress = CGFloat(totalAtMoment) / CGFloat(totalExptected)

    }
    
    func didFinishDownload(at simulator: FakeDownloadSimulator) {
        
        delegate?.didFinish(at: self)
    }
    
}
