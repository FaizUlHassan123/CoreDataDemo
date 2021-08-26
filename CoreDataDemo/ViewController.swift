//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Faiz Ul Hassan on 12/3/20.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {

//    var people:[String] = []
    var people = [NSManagedObject]()


    @IBOutlet weak var add: UIButton!

    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.retriveData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        retriveData()
    }
    
    
    @IBAction func additem(_ sender: Any) {
        let alert = UIAlertController(title: "New name", message: "Add new name", preferredStyle: .alert)
        let add = UIAlertAction(title: "OK", style: .default) { [self] (action) in
           let name = alert.textFields?.first
            self.saveName(name: name!.text!)
            table_view.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textf) in
            
        }
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func saveName(name: String) {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Person",
                                                 in:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = people[indexPath.row].value(forKey: "name") as? String
        
        return cell!
    }
    
    @objc func retriveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try manageContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as? String
                print("name  \(String(describing: name))")
                people.append(data)

            }
            self.table_view.reloadData()
            
        } catch {
            
            print("Failed")
        }
        
    }
    
}

