//
//  DependencyProvider.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation
import Swinject

// MARK : - So here we use Swinject without autoregister -> let's be patient with force unwrapping
//
class DependencyProvider {
    
    static var shared = DependencyProvider()
    
    let container = Container()
    let assembler: Assembler
    
    init() {
        assembler = Assembler([MainAssembly(),
                               RootAssembly(),
                               UserProfileAssembly()],
                              container: container)
    }
    
}

class MainAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }.inObjectScope(.container)
        
        container.register(SettingsStorage.self) { r in
            SettingsStorage(defaults: r.resolve(UserDefaults.self)!)
        }.inObjectScope(.container)
        
        container.register(HTTPFabric.self) { r in
            HTTPFabricImpl()
        }
    }
}
