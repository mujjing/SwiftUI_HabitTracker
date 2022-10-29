//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by 전지훈 on 2022/10/23.
//

import Foundation
import CoreData
import UserNotifications

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
    
    //MARK: Editing Habit
    @Published var editingHabit: Habit?
    
    //MARK: Notification Access Status
    @Published var notificationAccess: Bool = false
    
    init() {
        requestNotificationAccess()
    }
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    //MARK: Adding Habit to Database
    func addHabit(context: NSManagedObjectContext) async -> Bool {
        
        //MARK: Editing Data
        var habit: Habit!
        if let editingHabit = editingHabit {
            habit = editingHabit
            // removing all pending notifications
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editingHabit.notificationDs ?? [])
            
        } else {
            habit = Habit(context: context)
        }
        
        habit.title = title
        habit.color = habitColors
        habit.weekDays = weekDays
        habit.isRemainderOn = isRemainderOn
        habit.remainderText = remainderText
        habit.notificationDate = remainderDate
        habit.notificationDs = []
        
        if isRemainderOn {
            // MARK: Scheduling Notifications
            if let ids = try? await scheduleNotifications() {
                habit.notificationDs = ids
                if let _ = try? context.save() {
                    return true
                }
            }
        } else {
            // MARK: Adding Data
            if let _ = try? context.save() {
                return true
            }
        }
        return false
    }
    
    //MARK: Adding Notifications
    func scheduleNotifications() async throws -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "Habit 리마인더"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        // Schedule Ids
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        for weekday in weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remainderDate)
            let min = calendar.component(.minute, from: remainderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekday
            } ?? -1
            
            if day != -1 {
                var components = DateComponents()
                components.hour = hour
                components.minute = min
                components.weekday = day + 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
                
                notificationIDs.append(id)
            }
        }
        
        return notificationIDs
    }
    
    //MARK: Erasing Content
    func resetData() {
        title = ""
        habitColors = "Card1"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
        editingHabit = nil
    }
    
    //MARK: Restoring Edit Data
    func restoreEditHabit() {
        if let editingHabit = editingHabit {
            title = editingHabit.title ?? ""
            habitColors = editingHabit.color ?? "Card1"
            weekDays = editingHabit.weekDays ?? []
            isRemainderOn = editingHabit.isRemainderOn
            remainderDate = editingHabit.notificationDate ?? Date()
            remainderText = editingHabit.remainderText ?? ""
        }
    }
    
    //MARK: Deleting Habit From Database
    func deleteHabit(context: NSManagedObjectContext) -> Bool {
        if let editingHabit = editingHabit {
            if editingHabit.isRemainderOn {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editingHabit.notificationDs ?? [])
            }
            context.delete(editingHabit)
            
            // MARK: Adding Data
            if let _ = try? context.save() {
                return true
            }
        }
        return false
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
