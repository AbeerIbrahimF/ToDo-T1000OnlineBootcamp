//
//  TodosVC.swift
//  ToDo
//
//  Created by Abeer Alfaifi on 12/1/21.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray: [Todo] = []
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        self.todosArray = TodoStorage.getTodos()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(newTaskAdded), name: NSNotification.Name(rawValue: "NewTaskAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTaskEdited), name: NSNotification.Name(rawValue: "currentTaskEdited"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(taskDeleted), name: NSNotification.Name(rawValue: "TaskDeleted"), object: nil)
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
    }
    
    @objc func newTaskAdded(notification: Notification) {
        if let newTodo = notification.userInfo?["newTask"] as? Todo {
            todosArray.append(newTodo)
            todosTableView.reloadData()
            TodoStorage.storeData(todo: newTodo)
        }
    }
    
    @objc func currentTaskEdited(notification: Notification) {
        if let todo = notification.userInfo?["editedTask"] as? Todo {
            if let index = notification.userInfo?["editedTaskIndex"] as? Int{
                todosArray[index] = todo
                todosTableView.reloadData()
                TodoStorage.updateTodo(todo: todo, index: index)
            }
        }
    }
    
    @objc func taskDeleted(notification: Notification) {
        if let index = notification.userInfo?["DeletedTaskIndex"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
            TodoStorage.deleteTodo(index: index)
        }
    }
}

extension TodosVC : UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitleLabel.text = todosArray[indexPath.row].title
        
        if todosArray[indexPath.row].image != nil {
            cell.todoImageView.image = todosArray[indexPath.row].image
        } else {
            cell.todoImageView.image = UIImage(named: "noPic")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todosArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? TodoDetailsVC
        
        if let viewController = vc {
            viewController.todo = todo
            viewController.index = indexPath.row
            present(viewController, animated: true, completion: nil)
        }
    }
}
