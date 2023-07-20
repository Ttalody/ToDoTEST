//
//  ViewController.swift
//  ToDo
//
//  Created by Artur on 13.07.23.
//

import UIKit

class ListViewController: UIViewController {
    
    var tasksArray = [TaskModel]()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTaskTextField.returnKeyType = .done
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        fetchDataFromDatabase()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Add Task"), object: nil, queue: nil) { _ in
                    self.fetchDataFromDatabase()
                }

        DispatchQueue.main.async { [weak self] in
            self?.listTableView.reloadData()
        }
        
    }
    
    
    func fetchDataFromDatabase() {
        CoreDataManager.shared.fetchItemsFromDatabase { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasksArray = tasks
                self?.listTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        if let text = newTaskTextField.text, !text.isEmpty {
            let task = Task.init(title: text)
            CoreDataManager.shared.addItem(with: task) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("Add Task"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            newTaskTextField.text = String()
        }
        
        newTaskTextField.resignFirstResponder()
    }
    
}

// MARK: - TableView Extensions

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configure(with: tasksArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksArray[indexPath.row].isDone = true
        DispatchQueue.main.async { [weak self] in
            self?.listTableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    // TODO
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            CoreDataManager.shared.deleteItem(with: tasksArray[indexPath.row]) { result in
                switch result {
                case .success(()):
                    self.listTableView.reloadData()
                    
                case .failure(let error): print(error.localizedDescription)
                }
            }
            self.tasksArray.remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
}

// MARK: - TextField Extensions

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
