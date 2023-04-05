//
//  EventTask.swift
//  DatePlanner
//
//  Created by 김영빈 on 2023/04/05.
//

import Foundation

struct EventTask: Identifiable, Hashable {
    var id = UUID()
    var text: String
    var isCompleted = false
    var isNew = false
}
