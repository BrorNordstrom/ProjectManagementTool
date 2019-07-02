//
//  MasterViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 14/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//

import UIKit
import CoreData
import EventKit // provides access to calendar

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil // child view controller
    var projects = [Project]() // all projects


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        // get detailViewController
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // load table from Coredata
        self.projects = CoreDataManager._Project.fetch()
        tableView.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    
    @IBAction func onAddProject(_ sender: UIBarButtonItem) {
    
        // project add button clicked
        
        // open project add dialog
        
        let vc = ProjectAddViewController.getInstance() as! ProjectAddViewController
        vc.preferredContentSize = CGSize(width: 400, height: 550)
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
        
        vc.delegate = self // self will receive dialog events
        
        
    }
    
    @IBAction func onEditProject(_ sender: UIBarButtonItem) {
        
        // project edit button clicked
        
        // get selected index. otherwise do nothing
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        // get selected project
        let project = self.projects[indexPath.row]
        
        // open project edit dialog
        let vc = ProjectEditViewController.getInstance() as! ProjectEditViewController
        
        vc.project = project
        
        vc.preferredContentSize = CGSize(width: 400, height: 500)
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
        
        vc.delegate = self // self will receive dialog events
        
        
    }
    
    @IBAction func onAdd2Calendar(_ sender: Any) {
        
        // add to calendar button clicked
        
        // get selected index. otherwise do nothing
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        // get selected project
        let project = self.projects[indexPath.row]
        
        // call method to add project to calendar app
        self.addProject2Calendar(project: project)
        
        
    }
    
    func addProject2Calendar(project: Project, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        // add specific project to calendar
        
        // use eventstore
        
        let eventStore = EKEventStore()
        
        // request access first.
        // this needs Privacy - Calendars Usage Description in info.plist file
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                
                // create event for project
                
                let event = EKEvent(eventStore: eventStore)
                event.title = project.name
                event.startDate = project.startDate! as Date
                event.endDate = project.endDate! as Date
                event.notes = project.note
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = projects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.project = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        // this table needs only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows -> will be same as project count
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create cell for project
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterTableViewCell", for: indexPath) as! MasterTableViewCell

        // pass project data to cell
        cell.setCellData(project: projects[indexPath.row])

        return cell
    }


}


extension MasterViewController: ProjectAddViewControllerDelegate {
    
    // on project add dialog, save button is clicked
    func onSave(name: String, note: String, endDate: Date, priority: Int, add2Calendar: Bool) {
        
        // save project to coredata
        let project = CoreDataManager._Project.save(
            name: name,
            note: note,
            endDate: endDate,
            priority: priority)
        
        
        if let project = project, add2Calendar {
            // if project is need to be added to calendar app, should call according method
            self.addProject2Calendar(project: project)
        }
        
        // fetch projects and reload table
        self.projects = CoreDataManager._Project.fetch()
        tableView.reloadData()
        
    }
    
}

extension MasterViewController: ProjectEditViewControllerDelegate {
    
    // on project edit dialog, save button is clicked
    func onSave(project: Project, name: String, note: String, endDate: Date, priority: Int) {
        
        // update selected project on coredata
        CoreDataManager._Project.update(
            project: project,
            name: name,
            note: note,
            endDate: endDate,
            priority: priority)
        
        // fetch projects and reload table
        self.projects = CoreDataManager._Project.fetch()
        tableView.reloadData()
    }
    
    // on project edit dialog, delete project is clicked
    func onDelete(project: Project) {
        
        // delete selected project from coredata
        CoreDataManager._Project.delete(project: project)
        
        // fetch projects and reload table
        self.projects = CoreDataManager._Project.fetch()
        tableView.reloadData()
        
    }
    
}
