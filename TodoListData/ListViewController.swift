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
    
    let items = ["BIERE", "Pizza", "Vinyle", "Poulet"]
    
    var items2 = [Item]()
    
  
    var filteredItems = [Item]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createItems()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListViewCellIdentifier")
        
     
    }
    
    func createItems() {
        for item in items {
            let newElement = Item(name: item)
            
            items2.append(newElement)
        }
        filteredItems = items2
    }

    //Actions
    
    @IBAction func Edit(_ sender: Any) {
        let editButton = sender as! UIBarButtonItem
        
        tableView.isEditing = !tableView.isEditing
        
    }
    
    func saveData(_ item: [Item]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try? encoder.encode(item)
        try? data?.write(to: getDocumentsDirectory())
    }
    
    func getDocumentsDirectory() -> URL {
        var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsDirectory.appendPathComponent("items.json", isDirectory: false)
        print(documentsDirectory)
        return documentsDirectory
    }
    
    
    @IBAction func addButton(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Title", message: "New Item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textField = alertController.textFields![0]
            
            let item = Item(name: textField.text!)
            self.items2.append(item)
            self.saveData(self.items2)
            self.filterContentForSearchText(self.searchBar.text!)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier", for: indexPath)
        
        var item = items2[indexPath.row % items2.count]
        
        if isFiltering() {
            item = filteredItems[indexPath.row]
        } else {
            item = items2[indexPath.row]
        }
        
        cell.textLabel?.text = item.name
        cell.accessoryType = item.checked == true ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        }
        return items2.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = (cell?.accessoryType == .checkmark) ? .none : .checkmark
        
        let item = items2[indexPath.row % items2.count]
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering() {
                let index = items2.index(where: { $0 === filteredItems[indexPath.row] } )
                filteredItems.remove(at: indexPath.row)
                items2.remove(at: index!)
            } else {
                items2.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = items2.remove(at: sourceIndexPath.row)
        
        items2.insert(sourceItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return searchBar.text == ""
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
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = self.items2.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
}











