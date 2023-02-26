//
//  ArticlesListViewModel+StateMachine.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 16.02.23.
//

import Foundation
import Combine

class BaseStateMachine<IState, IEvent> {
    private(set) var state: IState {
        didSet { stateSubject.send(self.state) }
    }
    private let stateSubject: PassthroughSubject<IState, Never>
    let statePublisher: AnyPublisher<IState, Never>
    
    init(state: IState) {
        self.state = state
        self.stateSubject = PassthroughSubject<IState, Never>()
        self.statePublisher = self.stateSubject.eraseToAnyPublisher()
    }
    
    @discardableResult func tryEvent(_ event: IEvent) -> Bool {
        guard let state = nextState(for: event) else {
            return false
        }
        
        self.state = state
        return true
    }
    
    // TODO: should be private, but can't make it overridable then.
    func nextState(for event: IEvent) -> IState? {
        fatalError("load(from:) has not been implemented")
    }
}


extension ArticlesListViewModel {
    class StateMachine: BaseStateMachine<StateMachine.State, StateMachine.Event> {
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
        
        override func nextState(for event: Event) -> State? {
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
}

