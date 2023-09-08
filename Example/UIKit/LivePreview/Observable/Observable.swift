//
//  Observable.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 18/07/2023.
//

@propertyWrapper final class Observable<Value> {

    var projectedValue: Observable<Value> { self }

    var wrappedValue: Value {
        didSet { actions.forEach { $0(wrappedValue) } }
    }

    private var actions: [(Value) -> Void] = []

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func sink(fire: Bool = true, _ action: @escaping (Value) -> Void) {
        actions.append(action)
        if fire {
            action(wrappedValue)
        }
    }

    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) {
        let action = { object[keyPath: keyPath] = $0 }
        actions.append(action)
        action(wrappedValue)
    }

    func dispose() {
        actions.removeAll()
    }
}

// MARK: - Observable+CombineLatest

extension Observable {
    func combineLatest<OtherValue, Target>(
        _ other: Observable<OtherValue>,
        _ transform: @escaping (Value, OtherValue) -> Target
    ) -> Observable<Target> {
        let combined = Observable<Target>(wrappedValue: transform(wrappedValue, other.wrappedValue))
        sink(fire: false) { [weak combined, weak other] in
            guard let other else {
                return
            }

            combined?.wrappedValue = transform($0, other.wrappedValue)
        }
        other.sink(fire: false) { [weak self, weak combined] in
            guard let self else {
                return
            }

            combined?.wrappedValue = transform(self.wrappedValue, $0)
        }

        return combined
    }

    func combineLatest<OtherValue1, OtherValue2, Target>(
        _ other1: Observable<OtherValue1>,
        _ other2: Observable<OtherValue2>,
        _ transform: @escaping (Value, OtherValue1, OtherValue2) -> Target
    ) -> Observable<Target> {
        let combined = Observable<Target>(
            wrappedValue: transform(wrappedValue, other1.wrappedValue, other2.wrappedValue)
        )
        sink(fire: false) { [weak combined, weak other1, weak other2] in
            guard let other1, let other2 else {
                return
            }

            combined?.wrappedValue = transform($0, other1.wrappedValue, other2.wrappedValue)
        }
        other1.sink(fire: false) { [weak self, weak combined, weak other2] in
            guard let self, let other2 else {
                return
            }

            combined?.wrappedValue = transform(self.wrappedValue, $0, other2.wrappedValue)
        }
        other2.sink(fire: false) { [weak self, weak combined, weak other1] in
            guard let self, let other1 else {
                return
            }

            combined?.wrappedValue = transform(self.wrappedValue, other1.wrappedValue, $0)
        }

        return combined
    }
}
