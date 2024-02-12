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
    var tasks: [Task] { get }
}

struct KanbanWorkSpaceModel: KanbanDataProtocol {
    
    var workSpaceName: String = "Main Space"
    var sections: [Section] = [
        Section(name: "To Do", taskNum: 1),
        Section(name: "Today", taskNum: 1),
        Section(name: "Doing", taskNum: 1),
        Section(name: "Done", taskNum: 1)
    ]
    
    var tasks: [Task] = [
        Task.init(section: "To Do", taskName: "What to do", taskColor: "blue", taskDescription: "Type Description here"),
        Task.init(section: "Today", taskName: "What you gonna do today", taskColor: "orange", taskDescription: "Type Description here"),
        Task.init(section: "Doing", taskName: "What are you doint right now", taskColor: "red", taskDescription: "Type Description here"),
        Task.init(section: "Done", taskName: "What have you done today", taskColor: "green", taskDescription: "Type Description here"),
    ]
}

struct Section {
    var name: String
    var taskNum: Int
}

struct Task {
    var section: String
    var taskName: String
    var taskColor: String
    var taskDescription: String
}
