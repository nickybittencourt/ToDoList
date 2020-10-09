//
//  ViewController.swift
//  TodoList
//
//  Created by Nicholas Bittencourt  on 2020-10-08.
//

import UIKit

class ViewController: UIViewController {
    
    var toDos = [
    
        ToDo(title: "Make vanilla pudding."),
        ToDo(title: "Put pudding in a mayo jar"),
        ToDo(title: "Eat it in a public place."),
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    @IBSegueAction func toDoViewController(_ coder: NSCoder) -> ToDoViewController? {
        
        let vc =  ToDoViewController(coder: coder)
        
        if let indexpath = tableView.indexPathForSelectedRow {
            
            let toDo = toDos[indexpath.row]
            vc?.toDo = toDo
        }
        
        vc?.delegate = self
        vc?.presentationController?.delegate = self
        return vc
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
            
            let toDo = self.toDos[indexPath.row].completeToggled()
            self.toDos[indexPath.row] = toDo
            
            let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
            cell.set(checked: toDo.isComplete)
            
            complete(true)
            
            print("Complete")
        }
    
    return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        
        cell.delegate = self
        
        let toDo = toDos[indexPath.row]
        
        cell.set(title: toDo.title, checked: toDo.isComplete)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let toDo = toDos.remove(at: sourceIndexPath.row)
        toDos.insert(toDo, at: destinationIndexPath.row
        )
    }
    
}

extension ViewController: CheckTableViewCellDelegate {
    
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let toDo = toDos[indexPath.row]
        let newToDo = ToDo(title: toDo.title, isComplete: toDo.isComplete)
        
        toDos[indexPath.row] = newToDo
    }
}

extension ViewController: ToDoViewControllerDelegate {
    func toDoviewController(_ vc: ToDoViewController, didSaveToDo toDo: ToDo) {
     
        dismiss(animated: true) {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                self.toDos[indexPath.row] = toDo
                self.tableView.reloadRows(at: [indexPath], with: .none)
                
            } else {
                
                self.toDos.append(toDo)
                self.tableView.insertRows(at: [IndexPath(row: self.toDos.count-1, section: 0)], with: .automatic)
            }
        }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
