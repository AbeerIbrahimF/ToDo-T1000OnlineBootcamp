//
//  TodoStorage.swift
//  ToDo
//
//  Created by Abeer Alfaifi on 12/6/21.
//

import Foundation
import UIKit
import CoreData

class TodoStorage {
    
    static func storeData(todo: Todo){
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
    
    static func updateTodo(todo: Todo, index: Int){
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
    
    static func deleteTodo(index: Int){
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
    
    static func getTodos() -> [Todo]{
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
