//
//  DownloadTableViewCell.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 03/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit



class EpisodeCell: UITableViewCell {
    
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downloadProgressView: EpisodeDownloadProgressView!
    @IBOutlet weak var radioIndicatorView: RadioIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(episode: Episode) {
        
        titleLabel.text = episode.title
        downloadProgressView.configureProperty(from: episode)
        
        updateRadioIndicatorView()
    }
    
    func updateRadioIndicatorView() {
        radioIndicatorView.isHidden = downloadProgressView.status == .finished ? false : true
    }
}
