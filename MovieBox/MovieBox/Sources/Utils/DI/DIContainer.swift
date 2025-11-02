//
//  DIContainer.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import Swinject

public class DIContainer {
    public static let shared = DIContainer()
    public var container: Container {
        get {
            return _container!
        }

        set {
            _container = newValue
        }
    }

    private var _container: Container!

    public func set(_ container: Container) {
        _container = container
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency

    init() {
        wrappedValue = DIContainer.shared.container.resolve(Dependency.self)!
    }
}
