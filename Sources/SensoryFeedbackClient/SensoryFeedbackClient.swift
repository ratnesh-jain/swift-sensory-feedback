//
//  File.swift
//  swift-sensory-feedback
//
//  Created by Ratnesh Jain on 01/02/25.
//

import Foundation
import Dependencies
import DependenciesMacros
import UIKit

@DependencyClient
public struct SensoryFeedbackClient: Sendable {
    public var notify: @Sendable (_ type: UINotificationFeedbackGenerator.FeedbackType) -> Void
    public var impact: @Sendable (_ style: UIImpactFeedbackGenerator.FeedbackStyle, _ intesity: CGFloat) -> Void
    public var selection: @Sendable () -> Void
}

extension SensoryFeedbackClient: DependencyKey {
    @MainActor private static let notificationFeedback: UINotificationFeedbackGenerator = {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()
    
    @MainActor private static let selectionFeedback: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        return generator
    }()
    
    public static let liveValue: SensoryFeedbackClient = .init { feedbackType in
        Task { @MainActor in
            notificationFeedback.notificationOccurred(feedbackType)
        }
    } impact: { feedbackStyle, intensity in
        Task { @MainActor in
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        }
    } selection: {
        Task { @MainActor in
            selectionFeedback.selectionChanged()
        }
    }
}

extension DependencyValues {
    public var sensoryFeedback: SensoryFeedbackClient {
        get { self[SensoryFeedbackClient.self] }
        set { self[SensoryFeedbackClient.self] = newValue }
    }
}
