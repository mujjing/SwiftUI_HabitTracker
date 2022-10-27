//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by 전지훈 on 2022/10/23.
//

import Foundation
import CoreData

class HabitViewModel: ObservableObject {
    
    //MARK: New Habit Properties
    @Published var addNewHabits: Bool = false
    
    @Published var title: String = ""
    @Published var habitColors: String = "Card1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    //MARK: Reminder Time Picker
    @Published var showTimePicker: Bool = false
    
    //MARK: Adding Habit to Database
    func addHabit(context: NSManagedObjectContext) -> Bool {
        return false
    }
    
    //MARK: Erasing Content
    func resetData() {
        title = ""
        habitColors = "Card1"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
    }
    
    //MARK: Done Status
    func doneStatus() -> Bool {
        let remainderStatus = isRemainderOn ? remainderText == "" : false
        
        if title == "" || weekDays.isEmpty || remainderStatus {
            return false
        }
        return true
    }
}
