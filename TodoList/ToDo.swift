//
//  ToDo.swift
//  TodoList
//
//  Created by Nicholas Bittencourt  on 2020-10-08.
//

import Foundation

struct ToDo {
    let title: String
    let isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        
        self.title = title
        self.isComplete = isComplete
    }
    
    func completeToggled() -> ToDo {
        
        return ToDo(title: title, isComplete: !isComplete)
    }
}
