//
//  DependencyProvider.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation
import Swinject

class DependencyProvider {
    
    let container = Container()
    let assembler: Assembler
    
    init() {
        assembler = Assembler([MainAssembly(),
                               RootAssembly()],
                              container: container)
    }
    
}

class MainAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }
        container.register(SettingsStorage.self) { r in
            SettingsStorage(defaults: r.resolve(UserDefaults.self)!)
        }.inObjectScope(.container)
    }
}
