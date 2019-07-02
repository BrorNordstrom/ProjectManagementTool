//
//  DetailViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 14/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import UIKit
import UserNotifications
import DLLocalNotifications
// Mark: Reference
// Laungani, D. (2018). Devesh Laungani - Welcome. [online] Utdallas. Available at: https://www.utdallas.edu/~dxl141130/ [Accessed 16 May 2019].


class DetailViewController: UIViewController {


    var viewLoadFinished = false // indicates if view is once loaded
    
    var project: Project? { // project for detail view controller
        didSet {
            // Update the view when project data is set
            configureView()
        }
    }
    
    @IBOutlet var tableView: UITableView! // task table view

    // below outlet vars are all for project details
    @IBOutlet var labelProjectName: UILabel!
    @IBOutlet var labelProjectNote: UILabel!
    @IBOutlet var pieProjectProgress: PieView!
    @IBOutlet var labelProjectProgress: UILabel!
    @IBOutlet var pieProjectDayLeft: PieView!
    @IBOutlet var labelProjectDayLeft: UILabel!
    
    
    // project details wrapper
    @IBOutlet var stackViewProjectDetails: UIStackView!
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if viewLoadFinished == false {
            // if view is not loaded, the UI vars will be nil, this means no need to work
            return
        }

        // reload table data
        self.tableView.reloadData()
        
        // pie charts must be circular
        self.pieProjectProgress.layer.cornerRadius = self.pieProjectProgress.frame.width / 2
        self.pieProjectProgress.layer.masksToBounds = true

        self.pieProjectDayLeft.layer.cornerRadius = self.pieProjectDayLeft.frame.width / 2
        self.pieProjectDayLeft.layer.masksToBounds = true

        
        // set project details
        if let project = project {
            
            // if selected project exists, we should show project details
            self.stackViewProjectDetails.isHidden = false
            
            // show project name
            self.labelProjectName.text = "Project - " + (project.name ?? "")

            // show project note
            self.labelProjectNote.text = project.note
            
            // if project has tasks, should show task infomation
            if let tasks = project.tasks, tasks.allObjects.count != 0 {
                
                // holds total task progress sum
                var progressSum: Float = 0
                
                // calculate progressSum
                for task in tasks.allObjects {
                    progressSum += (task as! Task).progress
                }
                
                // calculate project progress percentage
                let percent = progressSum / Float(tasks.allObjects.count)
                
                // set pie chart value
                self.pieProjectProgress.percent = CGFloat(percent)
                //set description label value
                self.labelProjectProgress.text = String(percent) + "% complete"
            } else {
                // if selected project has no tasks, the percent will be 0. set according data
                self.pieProjectProgress.percent = 0
                self.labelProjectProgress.text = String(0) + "% complete"

            }
            
            // check if start date and end date are not nil
            if let startDate = project.startDate,
                let endDate = project.endDate {
                
                // calculate project passed date, progress and days left
                
                let currentDate = Date()
                
                // check based on timestamp
                let length = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
                let passed = currentDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
                let leftDays = Int(((endDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970) / (3600.0 * 24)).rounded())
                
                if leftDays < 0  {
                    // if leftDays is minus value, the project end date is expired.
                    self.pieProjectDayLeft.percent = 100
                    self.labelProjectDayLeft.text = String(0) + " days left"
                } else {
                    // set project date details data
                    let percent = passed * 100.0 / length
                    self.pieProjectDayLeft.percent = CGFloat(percent)
                    self.labelProjectDayLeft.text = String(leftDays) + " days left"
                    
                }
                
            }
            
        } else {
            
            // no selected project, don't need to show project details, so, project details wrapper will be hidden
            self.stackViewProjectDetails.isHidden = true

        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // all table events will be held on self
        self.tableView.delegate = self
        // table data data will be provided from self
        self.tableView.dataSource = self

        // set view loading flag
        viewLoadFinished = true

        // set project and tasks data
        configureView()
        
        // request authorization for notification
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
    }

    
    @IBAction func onAddTask(_ sender: UIBarButtonItem) {
        
        // task add button is clicked
        
        // if there is no selected project, just ignore.
        guard self.project != nil else { return }
        
        // show task add view controller
        let vc = TaskAddViewController.getInstance() as! TaskAddViewController
        
        vc.project = project // pass project to dialog
        
        vc.preferredContentSize = CGSize(width: 400, height: 500)
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
        
        vc.delegate = self // self will receive dialog events
        
    }
    
    @IBAction func onEditTask(_ sender: UIBarButtonItem) {
        
        // task edit button is clicked
        
        // ignore if there is no project selected
        
        guard self.project != nil else { return }
        
        // ignore if there is no row selected
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        // ignore if there is no task selected
        guard let task = self.project?.tasks?.allObjects[indexPath.row] as? Task else { return }
        
        
        // show task edit view controller
        let vc = TaskEditViewController.getInstance() as! TaskEditViewController
        
        vc.project = project // pass project to dialog
        vc.task = task // pass task to dialog
        
        vc.preferredContentSize = CGSize(width: 400, height: 500)
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
        
        vc.delegate = self // self will receive dialog events
        
    }
    
    func addTask2Notification(task: Task) {
        
        // this methods do work for schedule notification for showing task information
        // I used DLNotification plugin.
        // Laungani, D. (2018). Devesh Laungani - Welcome. [online] Utdallas. Available at: https://www.utdallas.edu/~dxl141130/ [Accessed 16 May 2019].
        
        let triggerDate = task.endDate! as Date
        
        let notification = DLNotification(
            identifier: "ProjectManagementToolNotificationID" +
                String(Date().timeIntervalSince1970),
            alertTitle: task.name ?? "",
            alertBody: task.note ?? "",
            date: triggerDate,
            repeats: .none)
        
        let scheduler = DLNotificationScheduler()
        scheduler.scheduleNotification(notification: notification)
        scheduler.scheduleAllNotifications()
        
        
    }

}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return number of rows. if there is no project selected, should return 0
        return self.project?.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create cell for each task
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        
        // set task data to cell
        if let object = self.project?.tasks?.allObjects[indexPath.row],
            let project = self.project {
            
            // pass data
            cell.setCellData(project: project, task: object as! Task)
            
        }
        
        
        return cell
    }
    
    
}

extension DetailViewController: TaskAddViewControllerDelegate {
    
    // on task add dialog, save button is clicked
    
    func onSave(name: String, note: String, endDate: Date, addNotification: Bool) {
        
        // check if selected project exists
        guard let project = self.project else { return }

        // save task to coredata
        let task = CoreDataManager._Task.save(
            project: project,
            name: name,
            note: note,
            endDate: endDate)
        
        // if needs to add notification, do work for it
        if let task = task, addNotification {
            
            // call method for add to notification
            self.addTask2Notification(task: task)
            
        }
        
        // update view
        
        self.configureView()
        
        
    }
    
    
}

extension DetailViewController: TaskEditViewControllerDelegate {
    
    
    // on task edit dialog, save button is clicked
    func onSave(project: Project, task: Task, name: String, note: String, endDate: Date, progress: Float) {
        
        // update task for project on coredata
        CoreDataManager._Task.update(
            project: project,
            task: task,
            name: name,
            note: note,
            endDate: endDate,
            progress: progress)
        
        // update view
        self.configureView()
    }
    
    // on task edit dialog, delete button is clicked
    func onDelete(project: Project, task: Task) {
        
        // delete task from coredata
        CoreDataManager._Task.delete(
            project: project,
            task: task)
        
        // update view
        self.configureView()
        
    }
    
}


