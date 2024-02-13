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
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Today", tasks: [Task.init(
            taskName: "What to do today",
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Doing", tasks: [Task.init(
            taskName: "What are you currrently doing",
            taskColor: "blue",
            taskDescription: "Type Description here")]),
        
        Section(name: "Done", tasks: [Task.init(
            taskName: "What to do",
            taskColor: "blue",
            taskDescription: "Type Description here")])
    ]
}

struct Section {
    var name: String = "New Section"
    var tasks: [Task] = [
        Task(taskName: "New Task",
             taskColor: "Green",
             taskDescription: "Type Description here")]
    var id: String = UUID().uuidString
    
    init(
        name: String = "New Section" ,
        tasks: [Task] = [Task(taskName: "New Task",
                 taskColor: "Green",
                 taskDescription: "Type Description here")]) {
        self.name = name
        self.tasks = tasks
    }
}

struct Task {
    var taskName: String = "New Task"
    var taskColor: String = "Green"
    var taskDescription: String = "Description"
    var id: String = UUID().uuidString
}
