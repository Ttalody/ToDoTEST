//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Artur on 16.07.23.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func addItem(with model: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context =  appDelegate.persistentContainer.viewContext
        
        let task = TaskModel(context: context)
        
        task.title = model.title
        task.isDone = model.isDone
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            context.rollback()
            completion(.failure(error))
        }
    }
    
    func fetchItemsFromDatabase(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request = TaskModel.fetchRequest()
        
        do {
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteItem(with model: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
