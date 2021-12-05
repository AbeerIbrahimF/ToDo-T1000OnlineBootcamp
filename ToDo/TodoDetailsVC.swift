//
//  TodoDetailsVC.swift
//  ToDo
//
//  Created by Abeer Alfaifi on 12/2/21.
//

import UIKit

class TodoDetailsVC: UIViewController {

    var todo: Todo!
    var index: Int!
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoDetailsLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if todo.image != nil {
            todoImageView.image = todo.image
        }else {
            todoImageView.image = UIImage(named: "noPic")
        }
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTaskEdited), name: NSNotification.Name(rawValue: "currentTaskEdited"), object: nil)
        
    }

    @IBAction func deleteButtonClicked(_ sender: Any) {
        let confirmAlert = UIAlertController(title: nil, message: "Do you want to delete this task?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "yes", style: .destructive) { alert in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TaskDeleted"), object: nil, userInfo: ["DeletedTaskIndex" : self.index!])
            
            let alert = UIAlertController(title: nil, message: "your task has been deleted successfully", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        }
        confirmAlert.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "no", style: .cancel, handler: nil)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true, completion: nil)
            
    }
        
    
    @objc func currentTaskEdited(notification: Notification) {
        if let todo = notification.userInfo?["editedTask"] as? Todo {
            self.todo = todo
            setupUI()
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            vc.isCreation = false
            vc.editedTask = todo
            vc.editedTaskIndex = index
            present(vc, animated: true, completion: nil)
            
        }
    }
    
    func setupUI() {
        todoTitleLabel.text = todo.title
        todoDetailsLabel.text = todo.details
        todoImageView.image = todo.image
    }
    
}
