//
//  LinksInteractionHandler.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 28/07/2023.
//

import UIKit

struct RichTextLink: Equatable {
    let url: URL
    let range: NSRange
}

/// Conforming ``CGRect`` to ``Hashable`` may lead to conflicts and overall doesn't seem right. So we opt for a hashable wrapper instead
private struct RectHashWrapper: Hashable {

    let rect: CGRect

    private let precomputedHash: Int

    init(rect: CGRect) {
        self.rect = rect

        var hasher = Hasher()
        hasher.combine(rect.origin.x)
        hasher.combine(rect.origin.y)
        hasher.combine(rect.width)
        hasher.combine(rect.height)
        precomputedHash = hasher.finalize()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(precomputedHash)
    }
}

final class LinksInteractionHandler: NSObject {

    // MARK: - Types

    enum State: Equatable {
        case idle
        case linkTouched(link: RichTextLink)
        case linkTapped(link: RichTextLink)
        case linkLongPressed(link: RichTextLink)
    }

    // MARK: - Public Properties
    
    var isLongPressTrackingEnabled = false
    var linkLongPressDuration: TimeInterval = 0.5

    // MARK: - Private Properties
    
    private lazy var touchGesture: UILongPressGestureRecognizer = {
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchRecognized))
        touchGesture.minimumPressDuration = 0
        touchGesture.delegate = self
        return touchGesture
    }()
    
    private weak var textLabel: RichTextLabel?
    
    private var state = State.idle {
        didSet {
            guard oldValue != state else { return }
            
            if case .idle = state {
                currentlySelectedLink = nil
            }
            stateObserver?(state)
        }
    }
    private var stateObserver: ((_ state: State) -> Void)?
    
    private var links: [RichTextLink] = []
    private var linksByRect: [RectHashWrapper: RichTextLink] = [:]

    private var currentlySelectedLink: RichTextLink? {
        didSet {
            if currentlySelectedLink == nil {
                longPressTrigger?.cancel()
            }
        }
    }
    private var longPressTrigger: DispatchWorkItem?

    // MARK: - Public Methods

    func attach(to textLabel: RichTextLabel, stateObserver: @escaping ((_ state: State) -> Void)) {
        self.textLabel = textLabel
        self.stateObserver = stateObserver

        textLabel.addGestureRecognizer(touchGesture)
    }

    func updateLinks(for attributedText: NSAttributedString?) {
        links.removeAll()
        linksByRect.removeAll()

        guard let attributedText else {
            return
        }

        attributedText.enumerateAttribute(.link, in: attributedText.range) { value, range, _ in
            guard let url = value as? URL else { return }
            links.append(RichTextLink(url: url, range: range))
        }
    }

    func textLabelDidLayout() {
        linksByRect.removeAll()
    }

    // MARK: - Private Properties

    @objc private func touchRecognized(_ sender: UILongPressGestureRecognizer) {
        guard let textLabel else {
            return
        }

        switch sender.state {
        case .began:
            touchBegan(in: sender.location(in: textLabel))
        case .changed:
            touchChanged(in: sender.location(in: textLabel))
        case .ended:
            touchEnded(in: sender.location(in: textLabel))
        case .cancelled, .failed:
            touchCanceledOrFailed()
        default:
            break
        }
    }

    private func touchBegan(in location: CGPoint) {
        currentlySelectedLink = link(at: location)
        guard let currentlySelectedLink else {
            return
        }

        state = .linkTouched(link: currentlySelectedLink)
        scheduleLongPressTrigger(for: currentlySelectedLink)
    }

    private func touchChanged(in location: CGPoint) {
        if currentlySelectedLink == nil || currentlySelectedLink != link(at: location) {
            touchGesture.state = .cancelled
        }
    }

    private func touchEnded(in location: CGPoint) {
        longPressTrigger?.cancel()
        guard let currentlySelectedLink, currentlySelectedLink == link(at: location) else {
            return
        }

        state = .linkTapped(link: currentlySelectedLink)
    }

    private func touchCanceledOrFailed() {
        state = .idle
    }

    private func scheduleLongPressTrigger(for selectedLink: RichTextLink) {
        guard isLongPressTrackingEnabled else {
            return
        }

        longPressTrigger?.cancel()
        let longPressTrigger = DispatchWorkItem() { [weak self] in
            self?.state = .linkLongPressed(link: selectedLink)
            self?.state = .idle
        }
        self.longPressTrigger = longPressTrigger
        DispatchQueue.main.asyncAfter(deadline: .now() + linkLongPressDuration, execute: longPressTrigger)
    }

    private func link(at location: CGPoint) -> RichTextLink? {
        guard let textLabel else {
            return nil
        }

        if let lineRect = linksByRect.keys.first(where: { $0.rect.contains(location) }),
           let cachedLink = linksByRect[lineRect] {
            return cachedLink
        }

        let textOrigin = textLabel.textContainerOrigin
        let correctLocation = CGPoint(x: location.x - textOrigin.x, y: location.y - textOrigin.y)
        let touchedGlyphIndex = textLabel.layoutManager.glyphIndex(for: correctLocation, in: textLabel.textContainer)
        guard let link = links.first(where: { $0.range.contains(touchedGlyphIndex) }) else {
            return nil
        }

        let linkUsedRects = textLabel.layoutManager.usedRectsForGlyphs(in: link.range)
        guard let linkUsedRect = linkUsedRects.first(where: { $0.contains(location) }) else {
            return nil
        }

        linksByRect[RectHashWrapper(rect: linkUsedRect)] = link

        return link
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LinksInteractionHandler: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return link(at: touch.location(in: textLabel)) != nil
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        /// Scrolling/panning is preferable over links interactions
        guard otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) else {
            return false
        }

        if otherGestureRecognizer.state == .began {
            gestureRecognizer.state = .failed
        }

        return true
    }
}
