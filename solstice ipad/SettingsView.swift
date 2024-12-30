//
//  SettingsView.swift
//  Solstice
//
//  Created by Milind Contractor on 29/12/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var data: SettingData
    @State var description: String = "Loading..."
    @Environment(\.dismiss) var dismiss
    
    var credits: some View {
        VStack {
            HStack {
                Text("_About Solstice_")
                    .font(.custom("Playfair Display", size: 20))
                Spacer()
            }
            HStack {
                Image("solstice", bundle: Bundle.main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                VStack {
                    HStack {
                        Text("Solstice")
                            .font(.custom("Playfair Display", size: 36))
                            .italic()
                        Spacer()
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text("_Phoenix_ v1.0")
                                .font(.custom("Playfair Display", size: 18))
                            Spacer()
                        }
                        HStack {
                            Text("Made with ❤️ by Advait")
                                .font(.custom("Crimson Pro", size: 18))
                            Spacer()
                        }
                    }
                }
            }
            
        }
    }
    
    var body: some View {
        ScrollView {
            // Wallpaper
            Group {
                HStack {
                    Text("_Settings_")
                        .font(.custom("Playfair Display", size: 36))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 24))
                    }
                }
                VStack {
                    HStack {
                        Text("Background")
                            .font(.custom("Crimson Pro", size: 18))
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(wallpapers, id: \.id) { wallpaper in
                                Button {
                                    withAnimation {
                                        data.background = wallpaper.wallpaperName
                                        for wallpaper in wallpapers {
                                            if wallpaper.wallpaperName == data.background {
                                                description = wallpaper.description
                                            }
                                        }
                                    }
                                } label: {
                                    if data.background == wallpaper.wallpaperName {
                                        Image(wallpaper.wallpaperName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 90)
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                                    .stroke(.blue, lineWidth: 2)
                                            )
                                    } else {
                                        Image(wallpaper.wallpaperName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 90)
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    }
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("_\(data.background)_")
                            .font(.custom("Playfair Display", size: 20))
                        Spacer()
                    }
                    
                    HStack {
                        Text(description)
                            .font(.custom("Crimson Pro", size: 18))
                            .onAppear {
                                for wallpaper in wallpapers {
                                    if wallpaper.wallpaperName == data.background {
                                        description = wallpaper.description
                                    }
                                }
                            }
                        Spacer()
                    }
                }
                .transition(.opacity)
            }
            Divider()
            // Other Settings
            VStack {
                HStack {
                    Text("_Timer Durations_")
                        .font(.custom("Playfair Display", size: 20))
                    Spacer()
                }
                HStack {
                    Text("Pomodoro Timer Duration")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("25", value: $data.pomodoroDuration[0], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Text(":")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("00", value: $data.pomodoroDuration[1], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Spacer()
                }
                HStack {
                    Text("Short Break Duration")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("5", value: $data.shortBreakDuration[0], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Text(":")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("00", value: $data.shortBreakDuration[1], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Spacer()
                }
                HStack {
                    Text("Long Break Duration")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("10", value: $data.longBreakDuration[0], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Text(":")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("00", value: $data.longBreakDuration[1], format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 40)
                    Spacer()
                }
                HStack {
                    Text("Cycles before Long Break")
                        .font(.custom("Crimson Pro", size: 18))
                    TextField("4", value: $data.cyclesBeforeLongBreak, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .font(.custom("Crimson Pro", size: 18))
                        .frame(width: 100)
                    Spacer()
                }
            }
            Divider()
            // Credits
            credits
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}
