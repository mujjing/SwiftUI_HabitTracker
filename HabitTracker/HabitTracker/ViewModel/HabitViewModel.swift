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
}
