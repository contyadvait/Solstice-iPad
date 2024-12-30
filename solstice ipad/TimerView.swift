import SwiftUI

struct TimerView: View {
    @Binding var todos: [Todo]
    @Binding var name: String
    @Binding var settings: SettingData
    @State var minutes: Int = 25
    @State var seconds: Int = 0
    @State var timer: Timer?
    @State var isRunning: Bool = false
    @State var currentTimerMode: TimerMode = .normal
    @State var cycles: Int = 0
    @State var displayedTodo: Todo = Todo(task: "", priority: 4)
    @State var showWelcomeBack: Bool = true
    @State var showButton: Bool = false
    @State var timerHover: Timer?
    @State var editTasks: Bool = false
    @State var showSettings: Bool = false
    
    var body: some View {
        ZStack {
            // Background Image
            Image(settings.background)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
            
            // Centered Content
            VStack {
                Spacer()
                if showWelcomeBack {
                    Text("Welcome _back_, \(name).")
                        .transition(.opacity)
                        .font(.custom("Crimson Pro", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            refreshDisplayedTodo()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showWelcomeBack = false
                                }
                            }
                        }
                } else {
                    Text(currentTimerMode.displayText)
                        .font(.custom("Crimson Pro", size: 24))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
                
                Text("\(minutes):\(String(format: "%02d", seconds))")
                    .font(.custom("Crimson Pro", size: 120))
                    .foregroundColor(.white)
                
                VStack {
                    Text("_Working on:_ \(displayedTodo.task)")
                        .font(.custom("Crimson Pro", size: 24))
                        .foregroundColor(.white)
                        .onTapGesture {
                            editTasks.toggle()
                        }
                        .popover(isPresented: $editTasks, arrowEdge: .trailing) {
                            TasksView(todos: $todos)
                        }
                }
                
                if showButton {
                    HStack(spacing: 20) {
                        Button {
                            if !isRunning {
                                startTimer()
                            } else {
                                stopTimer()
                            }
                        } label: {
                            HStack {
                                Image(systemName: isRunning ? "pause" : "play")
                                    .foregroundColor(.white)
                                Text(isRunning ? "Pause" : "Resume")
                                    .foregroundColor(.white)
                                    .font(.custom("Crimson Pro", size: 20))
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.6))
                                    .blendMode(.overlay)
                                    .shadow(radius: 3)
                            }
                        }
                        .buttonStyle(.borderless)
                        
                        Button {
                            showSettings = true
                        } label: {
                            VStack {
                                Image(systemName: "gear")
                                    .foregroundColor(.white)
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.6))
                                    .blendMode(.overlay)
                                    .shadow(radius: 3)
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    .transition(.opacity)
                }
                Spacer()
            }
            .padding()
            .frame(width: 450, height: 300)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.7))
                    .blendMode(.overlay)
                    .shadow(radius: 5)
                    .onHover { hovering in
                        if hovering {
                            withAnimation {
                                showButton = true
                            }
                            timerHover?.invalidate()
                        } else {
                            timerHover = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                                withAnimation {
                                    showButton = false
                                }
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(data: $settings)
                .frame(maxWidth: 600, maxHeight: 400)
        }
        .onTapGesture {
            withAnimation {
                showButton.toggle()
            }
        }
    }
    
    func refreshDisplayedTodo() {
        for todo in todos {
            if !todo.completed {
                displayedTodo = todo
                break
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if seconds == 0 {
                seconds = 59
                minutes = minutes - 1
            } else if minutes == 0 && seconds == 0 {
                cycles = cycles + 1
                if currentTimerMode == .normal && cycles != settings.cyclesBeforeLongBreak {
                    currentTimerMode = .shortBreak
                    minutes = settings.shortBreakDuration[0]
                    seconds = settings.shortBreakDuration[1]
                } else if currentTimerMode == .shortBreak || currentTimerMode == .longBreak {
                    minutes = settings.pomodoroDuration[0]
                    seconds = settings.pomodoroDuration[1]
                } else if cycles == settings.cyclesBeforeLongBreak {
                    cycles = 0
                    minutes = settings.longBreakDuration[0]
                    seconds = settings.longBreakDuration[1]
                }
                stopTimer()
            } else {
                seconds = seconds - 1
            }
        }
        isRunning = true
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(todos: .constant([Todo(task: "Something", priority: 1)]),
                  name: .constant("Advait"),
                  settings: .constant(SettingData()))
        .previewDevice("iPad Pro (12.9-inch)")
    }
}
