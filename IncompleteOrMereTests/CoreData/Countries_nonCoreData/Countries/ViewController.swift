//
//  ViewController.swift
//  Countries
//
//  Created by SeoGiwon on 06/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let countries = Country.read()
    lazy var searchController: UISearchController = {
       
        let controller = UISearchController(searchResultsController: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        //searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        
        guard let label1 = cell.viewWithTag(1) as? UILabel,
            let label2 = cell.viewWithTag(2) as? UILabel,
            let label3 = cell.viewWithTag(3) as? UILabel,
            let label4 = cell.viewWithTag(4) as? UILabel else {
            
                return cell
        }
        
        label1.text = countries[indexPath.row].name
        label2.text = countries[indexPath.row].capital
        label3.text = countries[indexPath.row].continent
        label4.text = countries[indexPath.row].population

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}
