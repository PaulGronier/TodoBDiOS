//
//  ViewController.swift
//  TodoListData
//
//  Created by Paul Gronier on 30/03/2018.
//  Copyright © 2018 Paul Gronier. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataManager = DataManager.shared
//    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListViewCellIdentifier")
     
    }
    
    //Actions
    
    @IBAction func Edit(_ sender: Any) {
        let editButton = sender as! UIBarButtonItem
        
        tableView.isEditing = !tableView.isEditing
        self.dataManager.triage()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Title", message: "New Item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textField = alertController.textFields![0]
            
            let item = Item(context: DataManager.shared.persistentContainer.viewContext)
            item.name = textField.text!
            item.checked = false
            self.dataManager.saveData()
            self.dataManager.fetchedRequest.predicate = nil
            self.dataManager.loadData()
            self.tableView.reloadData()


        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func organizeButton(_ sender: Any) {
        dataManager.triage()
        dataManager.loadData()
        tableView.reloadData()
    }
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier", for: indexPath)
        
        let item = self.dataManager.cachedItems[indexPath.row]
      
        cell.textLabel?.text = item.name
        cell.accessoryType = item.checked == true ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataManager.cachedItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = (cell?.accessoryType == .checkmark) ? .none : .checkmark
        
        let item = self.dataManager.cachedItems[indexPath.row]
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let item = self.dataManager.cachedItems[indexPath.row]
            self.dataManager.removeItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = self.dataManager.cachedItems[sourceIndexPath.row % self.dataManager.cachedItems.count]
        self.dataManager.removeItem(at: sourceIndexPath.row)
        self.dataManager.insertItem(item: sourceItem, at: destinationIndexPath.row)
        self.dataManager.saveData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return searchBar.text == ""
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return DataManager.shared.cachedItems.count > 1
    }
    
}

extension ListViewController: UISearchBarDelegate  {
    // MARK: - UISearchResultsUpdating Delegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        if !searchBarIsEmpty() {
            dataManager.fetchedRequest.predicate = NSPredicate(format: "name contains[cd] %@", searchText)
        } else {
            dataManager.fetchedRequest.predicate = nil
        }
        dataManager.loadData()
        tableView.reloadData()
    }
}











