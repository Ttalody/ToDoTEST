//
//  TaskModel+CoreDataProperties.swift
//  ToDo
//
//  Created by Artur on 20.07.23.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var isDone: Bool

}

extension TaskModel : Identifiable {

}
