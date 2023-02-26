//
//  ArticlesListViewModel+StateMachine.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 16.02.23.
//

import Foundation
import Combine

// TODO: make a base class
extension ArticlesListViewModel {
    class StateMachine {
        enum State {
            case start
            case loadingArticles
            case showArticles
            case error
        }
        
        enum Event {
            case loadArticles
            case loadArticlesSuccess
            case loadArticlesFailure
        }
        
        private(set) var state: State {
            didSet { stateSubject.send(self.state) }
        }
        private let stateSubject: PassthroughSubject<State, Never>
        let statePublisher: AnyPublisher<State, Never>
        
        init(state: State) {
            self.state = state
            self.stateSubject = PassthroughSubject<State, Never>()
            self.statePublisher = self.stateSubject.eraseToAnyPublisher()
        }
    }
}


// MARK: - State changes

extension ArticlesListViewModel.StateMachine {
    @discardableResult func tryEvent(_ event: Event) -> Bool {
        guard let state = nextState(for: event) else {
            return false
        }
        
        self.state = state
        return true
    }
    
    private func nextState(for event: Event) -> State? {
        switch state {
        case .start:
            switch event {
                case .loadArticles: return .loadingArticles
            default: break
            }
        case .loadingArticles:
            switch event {
                case .loadArticlesSuccess: return .showArticles
                case .loadArticlesFailure: return .error
            default: break
            }
        case .showArticles:
            switch event {
                case .loadArticles: return .loadingArticles
            default: break
            }
        case .error:
            switch event {
                case .loadArticles: return .loadingArticles
            default: break
            }
        }
        // Catch the wrong state
        unexpectedCodePath(message: "Wrong event <\(event)> for state <\(state)>" )
    }
}

