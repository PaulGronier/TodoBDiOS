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
    
    var categoryPassed = String()
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListViewCellIdentifier")
    }
    
    //Actions
    
    @IBAction func Edit(_ sender: Any) {
        let editButton = sender as! UIBarButtonItem
        tableView.isEditing = !tableView.isEditing
    }
    
    
    @IBAction func addButton(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Title", message: "New Item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textField = alertController.textFields![0]
            if textField.text != "" {
                let item = Item(context: DataManager.shared.persistentContainer.viewContext)
                item.name = textField.text!
                item.checked = false

                
                let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                
                destinationViewController.delegate = self
                destinationViewController.itemToSend = item
                //destinationViewController?.prepare(for: UIStoryboardSegue, sender: item)
                
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
                
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        print(categoryPassed)
    }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "segueCategorie" {
            let nextScene =  segue.destination as! SecondViewController
            
            // Pass the selected object to the new view controller.
            nextScene.itemToSend = sender as! Item
        }
    }
 */
    
}




extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier", for: indexPath)
        
        var item = self.dataManager.cachedItems[indexPath.row % self.dataManager.cachedItems.count]

        if isFiltering() {
            item = self.dataManager.filteredItems[indexPath.row]
        } else {
            item = self.dataManager.cachedItems[indexPath.row]
        }
        
      
        cell.textLabel?.text = item.name
        cell.accessoryType = item.checked == true ? .checkmark : .none
        
        // cell.contentView.backgroundColor = UIColor(hexString: cellColors[indexPath.row % cellColors.count])
        
        if(item.category == "first"){
            cell.textLabel?.textColor = .red
        }else if(item.category == "second"){
            cell.textLabel?.textColor = .orange
        }else if(item.category == "third"){
           // cell.contentView.backgroundColor = .orange
            cell.textLabel?.textColor = .purple
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.dataManager.filteredItems.count
        }
        return self.dataManager.cachedItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = (cell?.accessoryType == .checkmark) ? .none : .checkmark
        
        let item = self.dataManager.cachedItems[indexPath.row % self.dataManager.cachedItems.count]
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //print(item.category!)
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering() {
                let index = self.dataManager.cachedItems.index(where: { $0 === self.dataManager.filteredItems[indexPath.row] } )
                self.dataManager.filteredItems.remove(at: index!)
                self.dataManager.removeItem(at: index!)
            } else {
                self.dataManager.removeItem(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = self.dataManager.cachedItems[sourceIndexPath.row % self.dataManager.cachedItems.count]
         self.dataManager.removeItem(at: sourceIndexPath.row)
        self.dataManager.insertItem(item: sourceItem, at: destinationIndexPath.row)
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
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.dataManager.filteredItems = self.dataManager.cachedItems.filter({( item : Item) -> Bool in
            return item.name!.lowercased().contains(searchText.lowercased())
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

extension ListViewController: SecondViewControllerDelegate {
    
    func secondViewController(_ viewController: SecondViewController, didFinishChooseCategoryFor item: Item) {
        self.dataManager.cachedItems.append(item)
        self.dataManager.saveData()
        tableView.reloadData()

    }
    
}











