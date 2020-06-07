//
//  ViewController.swift
//  Memo
//
//  Created by Michelle Lau on 2020/06/06.
//  Copyright © 2020 Michelle Lau. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memos: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        getMemos()
    }

    // WHEN THE BUTTON IS PRESSED, PRESENT THE ALERT
    @IBAction func addMemoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a Memo", message: "Write the memo below.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let addMemoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let memoText = alert.textFields?[0].text ?? ""
            self.addMemo(memoText)
            print("added \(memoText) successfully")
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Memo description e.g. buy milk"
        }
        alert.addAction(dismissAction)
        alert.addAction(addMemoAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // PERSIST THE MEMO IN THE ENTITY
    func addMemo(_ text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        // TELL IT WHICH ENTITY
        let memoEntity = NSEntityDescription.entity(forEntityName: "Memo", in: managedContext)!
        let memo = NSManagedObject(entity: memoEntity, insertInto: managedContext)
        // TELL IT WHICH ATTRIBUTE
        memo.setValue(text, forKey: "memoDescription")
        
        do {
            // PERSIST THE DATA HERE
            try managedContext.save()
            getMemos()
            tableView.reloadData()
        } catch let error as NSError {
            print("Couldn't save memo \(error) \(error.userInfo)")
        }
    }
    
    // FETCH THE MEMOS FROM THE ENTITY
    func getMemos() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchMemos = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        
        do {
            // FETCHING FROM THE ENTITY AND PUTTING IT IN THE ARRAY
            memos = try managedContext.fetch(fetchMemos)
            tableView.reloadData()
        } catch let error as NSError {
            print("Couldn't save memo \(error) \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let memo = memos[indexPath.row]
        let memoDescription = memo.value(forKey: "memoDescription") as? String ?? ""
        cell.textLabel?.text = memoDescription
        return cell
    }
    
    
}
