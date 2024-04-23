//
//  ContentView.swift
//  iOSHapticDemo
//
//  Created by MaćKo on 23/04/2024.
//

import CoreHaptics
import SwiftUI

// TODO: Change to universal app
struct ContentView: View {
    @State private var alignmentTrigger = false
    @State private var decreaseTrigger = false
    @State private var errorTrigger = false
    @State private var softImpactTrigger = false
    @State private var heavyImpactTrigger = false
    @State private var increaseTrigger = false
    @State private var levelChangeTrigger = false
    @State private var selectionTrigger = false
    @State private var startTrigger = false
    @State private var stopTrigger = false
    @State private var successTrigger = false
    @State private var warningTrigger = false

    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack {
            Spacer(minLength: 50)

            Text("Haptic effects")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("DEMO")
                .font(.title2)

            Spacer(minLength: 50)

            List {
                Section("Sensory Feedback") {
                    Section("Only plays feedback on iOS and watchOS") {
                        Button("Selection") { selectionTrigger.toggle() }
                            .sensoryFeedback(.selection, trigger: selectionTrigger)

                        Button("Success") { successTrigger.toggle() }
                            .sensoryFeedback(.success, trigger: successTrigger)

                        Button("Warning") { warningTrigger.toggle() }
                            .sensoryFeedback(.warning, trigger: warningTrigger)

                        Button("Error") { errorTrigger.toggle() }
                            .sensoryFeedback(.error, trigger: errorTrigger)

                        Button("Soft impact") { softImpactTrigger.toggle() }
                            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: softImpactTrigger)

                        Button("Heavy impact") { heavyImpactTrigger.toggle() }
                            .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: heavyImpactTrigger)
                    }

                    Section("Only plays feedback on macOS") {
                        Button("Alignment") { alignmentTrigger.toggle() }
                            .sensoryFeedback(.alignment, trigger: alignmentTrigger)

                        Button("Level change") { levelChangeTrigger.toggle() }
                            .sensoryFeedback(.levelChange, trigger: levelChangeTrigger)
                    }

                    Section("Only plays feedback on watchOS") {
                        Button("Start") { startTrigger.toggle() }
                            .sensoryFeedback(.start, trigger: startTrigger)

                        Button("Stop") { stopTrigger.toggle() }
                            .sensoryFeedback(.stop, trigger: stopTrigger)

                        Button("Increase") { increaseTrigger.toggle() }
                            .sensoryFeedback(.increase, trigger: increaseTrigger)

                        Button("Decrease") { decreaseTrigger.toggle() }
                            .sensoryFeedback(.decrease, trigger: decreaseTrigger)
                    }
                }

                Section("Core Haptics") {
                    Button("Custom sharp tap", action: complexSuccess)
                        .onAppear(perform: prepareHaptics)

                    Button("Custom several taps", action: moreComplexSuccess)
                        .onAppear(perform: prepareHaptics)
                }
            }
        }
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    func moreComplexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create increasing and decreasing taps
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

#Preview {
    ContentView()
}
