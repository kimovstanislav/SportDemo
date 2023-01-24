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
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(apiClient: apiClient)
        
        Task {
            do {
                let result = try await apiClient.loadArticlesList()
                let toCompareArticles = result.getAllAricles()
                let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.showArticles(articles: toCompareArticles)]
                
                var step: Int = 0
                let _ = viewModel.$viewState
                    .sink { value in
                        let stateToCompare = toCompareStates[step]
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
        
        let apiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(apiClient: apiClient)
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.showError(errorMessage: SDStrings.Error.API.loadingArticlesFromServerErrorMessage)]
        
        var step: Int = 0
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
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
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testLoadArticlesFailureAlert() throws {
        let expectation = self.expectation(description: "States")
        
        let failingApiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(apiClient: failingApiClient)
        
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
        
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(apiClient: apiClient)
        
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
