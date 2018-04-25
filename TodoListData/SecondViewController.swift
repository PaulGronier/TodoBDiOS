//
//  ModalViewController.swift
//  TodoListData
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 Paul Gronier. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var itemToSend = Item(context: DataManager.shared.persistentContainer.viewContext)
    var category = Category()

    override func viewDidLoad() {
        //Modal background
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cat1(_ sender: Any) {
//        print("Catégorie 1")
        returnToListViewController(selected: "first")
    }

    @IBAction func cat2(_ sender: Any) {
//        print("Catégorie 2")
        returnToListViewController(selected: "second")
    }

    @IBAction func cat3(_ sender: Any) {
//        print("Catégorie 3")
        returnToListViewController(selected: "third")
    }

    func returnToListViewController(selected : String) {
        itemToSend.category?.name = selected
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        myVC.categoryPassed = selected
        navigationController?.pushViewController(myVC, animated: true)
    }

}
