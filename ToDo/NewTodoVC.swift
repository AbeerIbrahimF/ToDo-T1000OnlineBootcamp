//
//  NewTodoVC.swift
//  ToDo
//
//  Created by Abeer Alfaifi on 12/3/21.
//

import UIKit

class NewTodoVC: UIViewController {
    
    var isCreation = true
    var editedTask: Todo?
    var editedTaskIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var vcTitleLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !isCreation {
            mainButton.setTitle("Edit", for: .normal)
            vcTitleLabel.text = "Edit Task"
            if let todo = editedTask {
                titleTextField.text = todo.title
                detailsTextView.text = todo.details
                todoImageView.image = todo.image
            }
            
        }
    }
    
    @IBAction func selectPhotoButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreation{
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTaskAdded"), object: nil, userInfo: ["newTask" : todo])
            
            let alert = UIAlertController(title: nil, message: "Your task has been added successfully", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
        }else {
            //if opened for editing
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentTaskEdited"), object: nil, userInfo: ["editedTask" : todo, "editedTaskIndex" : editedTaskIndex!])
            
            let alert = UIAlertController(title: nil, message: "Your task has been edited successfully", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
                self.dismiss(animated: true, completion: nil)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension NewTodoVC :  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        todoImageView.image = image
    }
}
