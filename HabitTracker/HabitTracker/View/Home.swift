//
//  Home.swift
//

import SwiftUI

struct Home: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeOut) var habits: FetchedResults<Habit>
    @StateObject var habitViewModel: HabitViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Habits")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            
            //MAKING ADD BUTTON CENTER WHEN HABITS EMPTY
            ScrollView(habits.isEmpty ? .init() : .vertical ,showsIndicators: false) {
                VStack(spacing: 15) {
                    // Add Habit Button
                    Button {
                        habitViewModel.addNewHabits.toggle()
                    } label: {
                        Label {
                            Text("New Habit")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .padding(.vertical)
            }
        }
        .frame(height: .infinity, alignment: .top)
        .padding()
        .sheet(isPresented: $habitViewModel.addNewHabits) {
            //MARK: Erasing All Exisiting Content
            
        } content: {
            AddNewHabit()
                .environmentObject(habitViewModel)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() 
    }
}
