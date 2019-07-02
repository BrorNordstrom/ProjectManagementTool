//
//  CoreDataManager.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit
import CoreData

// class for managing core data
class CoreDataManager {
    
    // class for managing projects
    public class _Project {
        
        // returns all projects
        static func fetch() -> [Project] {
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // prepare fetch
            let projectFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
            
            // fetch projects
            let projects = try! managedContext.fetch(projectFetch)
            
            return projects as! [Project]
            
        }
        
        static func save(name: String, note: String, endDate: Date, priority: Int) -> Project? {
            
            // save new project
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // prepare entity
            let projectEntity = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)!
            
            // create new project object
            let project = NSManagedObject(entity: projectEntity, insertInto: managedContext)
            
            // set data for project
            project.setValue(name, forKeyPath: "name")
            project.setValue(note, forKey: "note")
            project.setValue(endDate, forKey: "endDate")
            project.setValue(priority, forKey: "priority")
            project.setValue(Date(), forKey: "startDate")

            
            // save context
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            return project as? Project
            
        }
        
        static func update(project: Project, name: String, note: String, endDate: Date, priority: Int) {
            
            // update project data on core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // set data for project
            project.setValue(name, forKeyPath: "name")
            project.setValue(note, forKey: "note")
            project.setValue(endDate, forKey: "endDate")
            project.setValue(priority, forKey: "priority")
            project.setValue(Date(), forKey: "startDate")
            
            // save context
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        
        static func delete(project: Project) {
            
            // delete project from core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // delete all tasks for project
            for task in project.tasks ?? [] {
                managedContext.delete(task as! Task)
            }
            
            // delete project
            managedContext.delete(project)
            
            // save context
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    public class _Task { // class for managing projects
        static func fetch() -> [Task] {
            
            // get tasks stored on core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // prepare fetch
            let taskFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            
            // fetch tasks
            let tasks = try! managedContext.fetch(taskFetch)
            
            return tasks as! [Task]
            
        }
        
        static func save(project: Project, name: String, note: String, endDate: Date) -> Task? {
            
            // save new task to core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // prepare entity
            let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
            
            // create task object
            let task = NSManagedObject(entity: taskEntity, insertInto: managedContext)
            
            // set data for task
            task.setValue(name, forKeyPath: "name")
            task.setValue(note, forKey: "note")
            task.setValue(endDate, forKey: "endDate")
            task.setValue(0, forKey: "progress")
            task.setValue(project, forKey: "project")
            task.setValue(Date(), forKey: "startDate")
            
            // save context
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            return task as? Task
            
        }
        
        static func update(project: Project, task: Task, name: String, note: String, endDate: Date, progress: Float) {
            
            // update task on core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // set data for task
            task.setValue(name, forKeyPath: "name")
            task.setValue(note, forKey: "note")
            task.setValue(endDate, forKey: "endDate")
            task.setValue(progress, forKey: "progress")
            task.setValue(project, forKey: "project")
            task.setValue(Date(), forKey: "startDate")
            
            // save context
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        
        static func delete(project: Project, task: Task) {
            // delete task from project and core data
            
            // get app delegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // get persistentContainer context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // remove task from project
            project.removeFromTasks(task)
            
            // delete task
            managedContext.delete(task)
            
            // save context
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
}
