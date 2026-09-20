
import Foundation
import SwiftData

@Model
final class Habit {

    var name: String
    var isCompleted: Bool
    var createdAt: Date

    // Relationship with Category
    var category: HabitCategory?

    init(
        name: String,
        isCompleted: Bool = false,
        createdAt: Date = .now,
        category: HabitCategory? = nil
    ) {
        self.name = name
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.category = category
    }
}
