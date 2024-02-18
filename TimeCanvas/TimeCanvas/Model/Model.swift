//
//  Model.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

protocol KanbanDataProtocol {
    var workSpaceName: String { get set }
    var sections: [Section] { get set }
}

struct KanbanWorkSpaceModel: KanbanDataProtocol {
    
    var workSpaceName: String = "Main Space"
    var sections: [Section] = [
        
        Section(name: "To Do", tasks: [Task.init(
            taskName: "What to do",
            taskColor: UIColor.customUltraLightGray.toHexString(),
            taskDescription: "Type Description here",
            isUtility: true)]),
        
        Section(name: "Today", tasks: [Task.init(
            taskName: "What to do today",
            taskColor: UIColor.customUltraLightGray.toHexString(),
            taskDescription: "Type Description here",
            isUtility: true)]),
        
        Section(name: "Doing", tasks: [Task.init(
            taskName: "What are you currrently doing",
            taskColor: UIColor.customUltraLightGray.toHexString(),
            taskDescription: "Type Description here",
            isUtility: true)]),
        
        Section(name: "Done", tasks: [Task.init(
            taskName: "What to do",
            taskColor: UIColor.customUltraLightGray.toHexString(),
            taskDescription: "Type Description here",
            isUtility: true)]),
    ]
}

struct Section {
    var name: String = "New Section"
    var tasks: [Task] = [
        Task(taskName: "New Task", taskColor: UIColor.customUltraLightGray.toHexString(),
             taskDescription: "Type Description here",
            isUtility: true)]
    var id: String = UUID().uuidString
}

struct Task {
    var taskName: String = "New Task"
    var taskColor: String = UIColor.customLightGray.toHexString()
    var taskDescription: String = "Description"
    var isUtility: Bool = false
    var id: String = UUID().uuidString
}
