//
//  ArticlesListTest.swift
//  SportDemoTests
//
//  Created by Stanislav Kimov on 24.01.23.
//

import XCTest
import Combine
@testable import SportDemo

final class ArticlesListTest: XCTestCase {
    private var bag: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testLoadArticles() throws {
        let expectation = self.expectation(description: "States")
        
        let stateMachine = ArticlesListViewModel.StateMachine(state: .start)
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(stateMachine: stateMachine, apiClient: apiClient)
        
        Task {
            do {
                let result = try await apiClient.loadArticlesList()
                let toCompareArticles = result.getAllAricles()
                
                // TODO: replace array with only 1 value
                let toCompareStates: [ArticlesListViewModel.ViewState] = [.loading, .loading, .showArticles(articles: toCompareArticles)]
                
                // TODO: read what is @Published and @ObservableObject in Combine
                // TODO: compare to just 1 last value
                var step: Int = 0
                let _ = viewModel.$viewState
                    .sink { value in
                        print("=> value: \(value)")
                        let stateToCompare = toCompareStates[step]
                        print("==> stateToCompare: \(stateToCompare) - step: \(step)")
                        guard stateToCompare == value else {
                            XCTFail("Wrong state")
                            return
                        }
                        step += 1
                        if step == toCompareStates.count {
                            expectation.fulfill()
                        }
                    }
                    .store(in: &bag)
            }
            catch let error as SDError  {
                Task.detached { @MainActor in
                    XCTFail(error.message)
                }
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesFailingAPI() throws {
        let expectation = self.expectation(description: "States")
        
        let stateMachine = ArticlesListViewModel.StateMachine(state: .start)
        let apiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(stateMachine: stateMachine, apiClient: apiClient)
        
        let errorMessage = SDStrings.Error.API.loadingArticlesFromServerErrorMessage
        let toCompareStates: [ArticlesListViewModel.ViewState] = [.loading, .loading, .showError(errorMessage: errorMessage)]
        
        var step: Int = 0
        let _ = viewModel.$viewState
            .sink { value in
                print("=> value: \(value)")
                let stateToCompare = toCompareStates[step]
                print("==> stateToCompare: \(stateToCompare) - step: \(step)")
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                print("===> incremented step: \(step)")
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testLoadArticlesFailureAlert() throws {
        let expectation = self.expectation(description: "States")
        
        let stateMachine = ArticlesListViewModel.StateMachine(state: .start)
        let failingApiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(stateMachine: stateMachine, apiClient: failingApiClient)
        
        let _ = viewModel.alertModel.$showAlert
            .sink { value in
                if value == true {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesSuccessNoAlert() throws {
        let expectation = self.expectation(description: "States")
        expectation.isInverted = true
        
        let stateMachine = ArticlesListViewModel.StateMachine(state: .start)
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(stateMachine: stateMachine, apiClient: apiClient)
        
        let _ = viewModel.alertModel.$showAlert
            .sink { value in
                if value == true {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension ArticlesListViewModel.ViewState: Equatable {
    public static func ==(lhs: ArticlesListViewModel.ViewState, rhs: ArticlesListViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
            
        case (.showEmptyList, .showEmptyList):
            return true
            
        case (let .showArticles(articles1), let .showArticles(articles2)):
            return articles1.sorted { a, b in a.id < b.id } == articles2.sorted { a, b in a.id < b.id }
            
        case (let .showError(error1), let .showError(error2)):
            return error1 == error2
            
        default:
            return false
            
        }
    }
}
