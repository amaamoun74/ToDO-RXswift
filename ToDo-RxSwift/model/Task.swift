//
//  Task.swift
//  ToDo-RxSwift
//
//  Created by ahmed on 11/08/2023.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
