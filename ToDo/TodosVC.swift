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
            storeData(todo: newTodo)
        }
    }
    
    @objc func currentTaskEdited(notification: Notification) {
        if let todo = notification.userInfo?["editedTask"] as? Todo {
            if let index = notification.userInfo?["editedTaskIndex"] as? Int{
                todosArray[index] = todo
                todosTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }
        }
    }
    
    @objc func taskDeleted(notification: Notification) {
        if let index = notification.userInfo?["DeletedTaskIndex"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
        }
    }
    
    func storeData(todo: Todo){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else {return}
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        
        if let image = todo.image {
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        
        do{
            try manageContext.save()
        }catch {
            
        }
    }
    
    func updateTodo(todo: Todo, index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
            
        }catch {
            print("========error========")
        }
    }
    
    func deleteTodo(index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            
            context.delete(todoToDelete)
            
            try context.save()
            
        }catch {
            print("========error========")
        }
    }
    
    func getTodos() -> [Todo]{
        var todos: [Todo] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodos in result{
                let title = managedTodos.value(forKey: "title") as? String
                let details = managedTodos.value(forKey: "details") as? String
                
                var todoImage: UIImage? = nil
                if let imageFromContext = managedTodos.value(forKey: "image") as? Data {
                    todoImage = UIImage(data: imageFromContext)
                }
                
                let todo = Todo(title: title ?? " ", image: todoImage, details: details ?? " ")
                todos.append(todo)
            }
        }catch {
            print("========error========")
        }
        return todos
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
