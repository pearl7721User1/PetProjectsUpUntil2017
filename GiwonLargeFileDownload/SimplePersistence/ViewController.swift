//
//  ViewController.swift
//  SimplePersistence
//
//  Created by SeoGiwon on 05/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var downloadItems: [DownloadItem] {
        return DownloadController.shared.downloadItems
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // listens to the notification for download task completion
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceiver(_:)), name: NSNotification.Name(rawValue: DownloadCompleteNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: DownloadCompleteNotificationName), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func notificationReceiver(_ notification: Notification) {
        // if a download task is complete, this function is called, making a circle indicator appears on the left of the cell
        
        for cell in tableView.visibleCells {
            let theCell = cell as! DownloadTableViewCell
            
            if let notificationSender = notification.object as? DownloadProgressView {
                if theCell.downloadProgressView === notificationSender {
                    
                    DispatchQueue.main.async {
                        theCell.updateCircleIndicatorView()
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableViewCell", for: indexPath) as! DownloadTableViewCell
        
        // binding the cell of the index to the download task model of the same index
         cell.configureCell(downloadItem: downloadItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadItems.count
    }
}

extension ViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // when the cell is selected when the corresponding download task has been completed, push a new view controller to show the image in full resolution
        let imgViewController = ImageViewController()
        
        DownloadController.shared.downloadedImage(index: indexPath.row, completion:{ (img: UIImage?) in
            
            imgViewController.img = img
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(imgViewController, animated: true)
            }
            
        })
        

        
    }
}

