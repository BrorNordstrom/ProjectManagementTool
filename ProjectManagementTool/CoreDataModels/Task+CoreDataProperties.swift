// this file is auto-generated from XCode -> Editor menu -> Create NSManagedObject Subclass... command

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var endDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var progress: Float
    @NSManaged public var project: Project?
    @NSManaged public var startDate: NSDate?

}
