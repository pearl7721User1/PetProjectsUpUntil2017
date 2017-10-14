//
//  ViewController.swift
//  Countries
//
//  Created by SeoGiwon on 06/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext! {
        
        let del = UIApplication.shared.delegate as! AppDelegate
        return del.persistentContainer.viewContext
    }

    lazy var countries: [Country] = {
        
        let request: NSFetchRequest<Country> = Country.fetchRequest()
        guard let results = try? self.managedContext.fetch(request) else {
            return  [Country]()
        }
        
        return results
    }()

    lazy var fetchedResultsController : NSFetchedResultsController<Country> = {
       
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()

        
        let sortContinent = NSSortDescriptor(key: #keyPath(Country.continent), ascending: true)
        let sortName = NSSortDescriptor(key: #keyPath(Country.name), ascending: true)
        fetchRequest.sortDescriptors = [sortContinent, sortName]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: self.managedContext,
                                                              sectionNameKeyPath: #keyPath(Country.continent),
                                                              cacheName: "country")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    @IBAction func btnTapped(_ sender: UIBarButtonItem) {
        
        let countryJSONs = Country.createExtraCountries()
    
        for json in countryJSONs {
            
            if let country = Country.findOrCreate(json: json) {
                country.population = json["population"] as? String
                country.capital = json["capital"] as? String
                country.continent = json["continent"] as? String
                country.name = json["name"] as? String
            }
            
        }
        
        /*
        for country in countries {
            
            print(country.describe())
            
            
            Country.insert(country: country)
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        
        guard let label1 = cell.viewWithTag(1) as? UILabel,
            let label2 = cell.viewWithTag(2) as? UILabel,
            let label3 = cell.viewWithTag(3) as? UILabel,
            let label4 = cell.viewWithTag(4) as? UILabel else {
            
                return cell
        }
        
        
        let country = fetchedResultsController.object(at: indexPath)
        
        
        label1.text = country.name
        label2.text = country.capital
        label3.text = country.continent
        label4.text = country.population

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath!)
            
            guard let label1 = cell.viewWithTag(1) as? UILabel,
                let label2 = cell.viewWithTag(2) as? UILabel,
                let label3 = cell.viewWithTag(3) as? UILabel,
                let label4 = cell.viewWithTag(4) as? UILabel else {
                    
                return
            }
            
            
            let country = fetchedResultsController.object(at: indexPath!)
            
            label1.text = country.name
            label2.text = country.capital
            label3.text = country.continent
            label4.text = country.population
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}
