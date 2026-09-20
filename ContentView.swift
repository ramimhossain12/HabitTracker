
import SwiftUI
import SwiftData

struct ContentView: View {

    // MARK: - SwiftData

    @Environment(\.modelContext)
    private var modelContext

    @Query(sort: \Habit.createdAt, order: .reverse)
    private var habits: [Habit]

    // MARK: - App Settings

    @AppStorage("isDarkMode")
    private var isDarkMode = false

    // MARK: - Search & Filter

    @State private var searchText = ""
    @State private var selectedFilter: HabitFilter = .all

    // MARK: - Sheet State

    @State private var showingAddSheet = false
    @State private var habitToEdit: Habit?

    // MARK: - Error State

    @State private var showingError = false
    @State private var errorMessage = ""

    // MARK: - Filter Enum

    enum HabitFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"

        var id: String { rawValue }
    }

    // MARK: - Filtered Habits

    private var filteredHabits: [Habit] {

        habits.filter { habit in

            let matchesSearch =
                searchText.isEmpty ||
                habit.name.localizedCaseInsensitiveContains(
                    searchText
                )

            let matchesFilter: Bool

            switch selectedFilter {

            case .all:
                matchesFilter = true

            case .active:
                matchesFilter = !habit.isCompleted

            case .completed:
                matchesFilter = habit.isCompleted
            }

            return matchesSearch && matchesFilter
        }
    }

    // MARK: - Progress

    private var completedCount: Int {
        habits.filter { $0.isCompleted }.count
    }

    private var progress: Double {
        guard !habits.isEmpty else { return 0 }

        return Double(completedCount) / Double(habits.count)
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            VStack(spacing: 16) {

                // Progress Card

                VStack(alignment: .leading, spacing: 10) {

                    HStack {
                        Text("Today's Progress")
                            .font(.headline)

                        Spacer()

                        Text("\(completedCount)/\(habits.count)")
                            .font(.headline)
                            .foregroundStyle(.green)
                    }

                    ProgressView(value: progress)
                        .tint(.green)

                    Text(
                        habits.isEmpty
                            ? "Start by adding your first habit!"
                            : "\(Int(progress * 100))% completed"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

                // Search

                HStack {

                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField(
                        "Search habits...",
                        text: $searchText
                    )

                    if !searchText.isEmpty {

                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
                .background(
                    Color(.secondarySystemBackground)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

                // Filter

                Picker("Filter", selection: $selectedFilter) {

                    ForEach(HabitFilter.allCases) { filter in
                        Text(filter.rawValue)
                            .tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                // Habit List

                if filteredHabits.isEmpty {

                    ContentUnavailableView {

                        Label(
                            searchText.isEmpty
                                ? "No Habits Found"
                                : "No Matching Habits",
                            systemImage: "checklist"
                        )

                    } description: {

                        Text(
                            searchText.isEmpty
                                ? "Add a habit to get started."
                                : "Try another search or filter."
                        )

                    } actions: {

                        if habits.isEmpty {

                            Button("Add Your First Habit") {
                                showingAddSheet = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    Spacer()

                } else {

                    List {

                        ForEach(filteredHabits) { habit in

                            HabitRow(
                                habit: habit,
                                onToggle: {
                                    toggleHabit(habit)
                                },
                                onEdit: {
                                    habitToEdit = habit
                                }
                            )
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .padding(.horizontal)
            .navigationTitle("My Habits")
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Toggle(
                        "Dark Mode",
                        isOn: $isDarkMode
                    )
                    .labelsHidden()
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }

            // Add Sheet

            .sheet(isPresented: $showingAddSheet) {

                HabitEditorView { name in
                    addHabit(name: name)
                }
            }

            // Edit Sheet

            .sheet(item: $habitToEdit) { habit in

                HabitEditorView(
                    initialName: habit.name
                ) { newName in

                    updateHabit(
                        habit,
                        newName: newName
                    )
                }
            }

            // Error Alert

            .alert(
                "Something Went Wrong",
                isPresented: $showingError
            ) {

                Button("OK", role: .cancel) { }

            } message: {

                Text(errorMessage)
            }
        }
        .preferredColorScheme(
            isDarkMode ? .dark : .light
        )
    }

    // MARK: - Create

    private func addHabit(name: String) {

        let habit = Habit(name: name)

        modelContext.insert(habit)

        saveChanges()
    }

    // MARK: - Update

    private func updateHabit(
        _ habit: Habit,
        newName: String
    ) {

        habit.name = newName

        saveChanges()
    }

    // MARK: - Toggle Completion

    private func toggleHabit(_ habit: Habit) {

        habit.isCompleted.toggle()

        saveChanges()
    }

    // MARK: - Delete

    private func deleteHabits(
        at offsets: IndexSet
    ) {

        for index in offsets {

            let habit = filteredHabits[index]

            modelContext.delete(habit)
        }

        saveChanges()
    }

    // MARK: - Save & Error Handling

    private func saveChanges() {

        do {

            try modelContext.save()

        } catch {

            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

// MARK: - Habit Row

struct HabitRow: View {

    let habit: Habit
    let onToggle: () -> Void
    let onEdit: () -> Void

    var body: some View {

        HStack(spacing: 12) {

            Button(action: onToggle) {

                Image(
                    systemName: habit.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    habit.isCompleted
                        ? .green
                        : .secondary
                )
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 5) {

                Text(habit.name)
                    .strikethrough(habit.isCompleted)
                    .foregroundStyle(
                        habit.isCompleted
                            ? .secondary
                            : .primary
                    )

                Text(
                    habit.createdAt,
                    format: .dateTime.month().day().year()
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onEdit) {

                Image(systemName: "pencil")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Edit \(habit.name)")
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Add & Edit Screen

struct HabitEditorView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var name: String

    let onSave: (String) -> Void

    init(
        initialName: String = "",
        onSave: @escaping (String) -> Void
    ) {

        _name = State(initialValue: initialName)
        self.onSave = onSave
    }

    private var trimmedName: String {

        name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Habit Details") {

                    TextField(
                        "Habit name",
                        text: $name
                    )
                }
            }
            .navigationTitle(
                name.isEmpty ? "New Habit" : "Edit Habit"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Save") {

                        onSave(trimmedName)
                        dismiss()

                    }
                    .disabled(trimmedName.isEmpty)
                }
            }
        }
    }
}

#Preview {

    ContentView()
        .modelContainer(
            for: [Habit.self, HabitCategory.self],
            inMemory: true
        )
}
