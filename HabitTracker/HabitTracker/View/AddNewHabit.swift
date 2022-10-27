//
//  AddNewHabit.swift
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var habitViewModel: HabitViewModel
    @Environment(\.self) var env
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                TextField("Title", text: $habitViewModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { index in
                        let color = "Card\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                if color == habitViewModel.habitColors {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                }
                            })
                            .onTapGesture {
                                withAnimation {
                                    habitViewModel.habitColors = color
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Frequency")
                        .font(.callout.bold())
                    
                    let weekdays = Calendar.current.weekdaySymbols
                    
                    HStack(spacing: 10) {
                        ForEach(weekdays, id:\.self) {day in
                            let index = habitViewModel.weekDays.firstIndex {
                                value in return value == day
                            } ?? -1
                            
                            // MARK: Limiting to First 3 letters
                            Text(day.prefix(3))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(index != -1 ? Color(habitViewModel.habitColors) :  Color("TFBG").opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if index != -1 {
                                            habitViewModel.weekDays.remove(at: index)
                                        } else {
                                            habitViewModel.weekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 15)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Reminder")
                            .fontWeight(.semibold)
                        
                        Text("Just Notification")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Toggle(isOn: $habitViewModel.isRemainderOn) {}
                        .labelsHidden()
                }
                
                HStack(spacing: 12) {
                    Label {
                        Text(habitViewModel.remainderDate.formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .onTapGesture {
                        withAnimation {
                            habitViewModel.showTimePicker.toggle()
                        }
                    }
                    
                    TextField("Reminder Text", text: $habitViewModel.remainderText)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                .frame(height: habitViewModel.isRemainderOn ? nil : 0)
                .opacity(habitViewModel.isRemainderOn ? 1 : 0)
            }
            .animation(.easeOut, value: habitViewModel.isRemainderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            if await habitViewModel.addHabit(context: env.managedObjectContext) {
                                env.dismiss()
                            }
                        }
                    } label: {
                        Text("Done")
                    }
                    .tint(.white)
                    .disabled(!habitViewModel.doneStatus())
                    .opacity(habitViewModel.doneStatus() ? 1 : 0.6)
                }
            }
        }
        .overlay {
            if habitViewModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                habitViewModel.showTimePicker.toggle()
                            }
                        }
                    
                    DatePicker.init("", selection: $habitViewModel.remainderDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TFBG"))
                        }
                }
            }
        }
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.dark)
    }
}
