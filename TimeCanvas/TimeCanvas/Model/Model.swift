//
//  Model.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

protocol KanbanDataProtocol {
    var workSpaceName: String { get }
    var sections: [Section] { get }
}

struct KanbanWorkSpaceModel: KanbanDataProtocol {
    
    var workSpaceName: String = "Main Space"
    var sections: [Section] = [
        
        Section(name: "To Do", taskNum: 1, tasks: [Task.init(
            taskName: "What to do",
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Today", taskNum: 1, tasks: [Task.init(
            taskName: "What to do today",
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Doing", taskNum: 1, tasks: [Task.init(
            taskName: "What are you currrently doing",
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Done", taskNum: 1, tasks: [Task.init(
            taskName: "What to do",
            taskColor: "blue",
            taskDescription: "Type Description here")])
    ]
}

struct Section {
    var name: String
    var taskNum: Int
    var tasks: [Task]
}

struct Task {
    var taskName: String
    var taskColor: String
    var taskDescription: String
}
