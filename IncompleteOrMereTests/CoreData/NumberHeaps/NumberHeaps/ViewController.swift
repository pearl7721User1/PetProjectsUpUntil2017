//
//  ViewController.swift
//  NumberHeaps
//
//  Created by SeoGiwon on 06/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var managedContext: NSManagedObjectContext! {
        
        let del = UIApplication.shared.delegate as! AppDelegate
        return del.persistentContainer.viewContext
    }
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var okayLabel: UILabel!
    
    lazy var heys: [Hey] = {
        
        let fetchRequest: NSFetchRequest<Hey> = Hey.fetchRequest()
        
        if let result = try? self.managedContext.fetch(fetchRequest) {
            return result
        } else {
            return [Hey]()
        }
    }()
        
    
    func fetch() -> [Hey] {
        let fetchRequest: NSFetchRequest<Hey> = Hey.fetchRequest()
        
        if let result = try? self.managedContext.fetch(fetchRequest) {
            return result
        } else {
            return [Hey]()
        }
    }
    
    var okay1: Okay?
    var okay2: Okay?
    var okay3: Okay?
    var okay4: Okay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // fetch empty core data
        // fetch
        let fetchRequest: NSFetchRequest<Okay> = Okay.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "hey.title = %@", "Title2")
        
        if let result = try? self.managedContext.fetch(fetchRequest) {
            
            print(result.count)
            
        }
        
        // add random okay, heys
        let h1 = Hey(context: managedContext)
        h1.number = 1
        h1.title = "Title1"
        
        let h2 = Hey(context: managedContext)
        h2.number = 2
        h2.title = "Title2"

        okay1 = Okay(context: managedContext)
        okay1!.hey = h1
        okay1!.name = "zzz"
        
        okay2 = Okay(context: managedContext)
        okay2!.hey = h1
        okay2!.name = "bcdef"
        
        okay3 = Okay(context: managedContext)
        okay3!.hey = h1
        okay3!.name = "cccc"
        
        okay4 = Okay(context: managedContext)
        okay4!.hey = h2
        
        
        print(okay4!.entity.name)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataModelChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedContext)
        
        
        
    }
    
    func handleDataModelChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {

            if let insertedOkays = inserts.filter({$0.entity.name == "Okay" }) as? [Okay] {
                let title1Okays = insertedOkays.filter({$0.hey?.title == "Title1"})
                
//                print("title1: \(title1Okays.count)")

                print(title1Okays)
                let sorted = title1Okays.sorted(by: { $0.name! < $1.name! })

                print("========")
                print(sorted)
                
                
                let title2Okays = insertedOkays.filter({$0.hey?.title == "Title2"})
                
                print("title2: \(title2Okays.count)")
                
            }
            
            
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            
            if let updatedOkays = updates.filter({$0.entity.name == "Okay" }) as? [Okay] {
                
                
                
                
                let title1Okays = updatedOkays.filter({$0.hey?.title == "Title1"})
                
                print("title1: \(title1Okays.count)")
                
                let title2Okays = updatedOkays.filter({$0.hey?.title == "Title2"})
                
                print("title2: \(title2Okays.count)")
                
            }
            
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
            
            
        }
        
        /*
         NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
         NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
         NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
         
         NSMutableArray *objectIDs = [NSMutableArray array];
         [objectIDs addObjectsFromArray:[updatedObjects.allObjects valueForKey:@"objectID"]];
         [objectIDs addObjectsFromArray:[deletedObjects.allObjects valueForKey:@"objectID"]];
         [objectIDs addObjectsFromArray:[insertedObjects.allObjects valueForKey:@"objectID"]];
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
         NSSet *affectedEntities = [NSSet setWithArray:[objectIDs valueForKeyPath:@"entity.name"]];
         
         if([affectedEntities containsObject:@"InterestingEntity"]) {
         // get back onto the main thread and do some proper work;
         // possibly having collated the relevant object IDs here
         // first — whatever is appropriate
         }
         });
         */
    }
    
    // add hey
    @IBAction func add(_ sender: UIButton) {
        let myInstance = Hey(context: managedContext)
        heys.append(myInstance)
        updateLabel()
    }
    
    // add okay
    @IBAction func btnForOkay(_ sender: UIButton) {
        
        
 
        
        if let okays = heys.last?.okays {
            print("yes")
            
            print(okays.count)
            
        } else {
            print("no")
        }
        
        let myInstance = Okay(context: managedContext)

        heys.last?.addToOkays(myInstance)
        
//        heys.last?.mutableSetValue(forKey: "okays").add(myInstance)
        
        print(heys.last?.okays?.count)
        
        updateLabel()
        
    }
    
    func updateLabel() {
        
        countLabel.text = "\(heys.count) number:\(heys[0].number)"
        
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        
        okay1!.name = "abcdefg"
        okay2!.name = "zzzzzzz"
        
        
        print(okay1!.objectID)
        
        
        let fetchRequest: NSFetchRequest<Okay> = Okay.fetchRequest()
        
        if let result = try? self.managedContext.fetch(fetchRequest) {
            
            for okay in result {
                
                print(okay.objectID)
                
                if okay === okay1 {
                    print("identical")
                    
                    print(okay.name)
                    
                }
                
                if okay == okay1 {
                    print("equal")
                }
                
                if okay.isEqual(okay1) {
                    print("equal")
                }
            }
            
        }
        
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        
        
        
        
        var result: [Hey]?
        let fetchRequest: NSFetchRequest<Hey> = Hey.fetchRequest()
        
        do {
            result = try managedContext.fetch(fetchRequest)
            
            for hey in result! {
                managedContext.delete(hey)
            }
            
        }
        catch {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

