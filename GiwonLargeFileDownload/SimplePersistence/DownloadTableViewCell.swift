//
//  DownloadTableViewCell.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 03/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit



class DownloadTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downloadProgressView: DownloadProgressView!
    @IBOutlet weak var circleIndicatorView: CircleIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(downloadItem: DownloadItem) {
        
        titleLabel.text = downloadItem.title
        downloadProgressView.configureProperty(from: downloadItem)
        
        updateCircleIndicatorView()
    }
    
    func updateCircleIndicatorView() {
        circleIndicatorView.isHidden = downloadProgressView.status == .finished ? false : true
    }
}
