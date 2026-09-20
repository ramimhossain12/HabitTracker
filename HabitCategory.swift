//
//  HabitCategory.swift
//  HabitTracker
//
//  Created by Ramim Hossain on 20/09/2026.
//


import Foundation
import SwiftData

@Model
final class HabitCategory {

    var name: String

    @Relationship(
        deleteRule: .nullify,
        inverse: \Habit.category
    )
    var habits: [Habit] = []

    init(name: String) {
        self.name = name
    }
}
