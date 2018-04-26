//
//  ModalViewController.swift
//  TodoListData
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 Paul Gronier. All rights reserved.
//

import UIKit

protocol SecondViewControllerDelegate: class {
    func secondViewController(_ viewController: SecondViewController, didFinishChooseCategoryFor item: Item)
}

class SecondViewController: UIViewController {

    //var itemToSend = Item(context: DataManager.shared.persistentContainer.viewContext)
    var itemToSend = Item()
    
    weak var delegate: SecondViewControllerDelegate?
    //var category = Category()

    override func viewDidLoad() {
        //Modal background
        view.backgroundColor = UIColor.white
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
//        dismiss(animated: true) {
//            print("dismissed")
//        }
        itemToSend.category = selected
        
        delegate?.secondViewController(self, didFinishChooseCategoryFor: itemToSend)
        
        self.navigationController?.popViewController(animated: true)
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
//        myVC.categoryPassed = selected
//        navigationController?.pushViewController(myVC, animated: true)
    }

}
