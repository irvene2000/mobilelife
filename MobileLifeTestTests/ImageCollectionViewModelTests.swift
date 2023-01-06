//
//  APITests.swift
//  MobileLifeTestTests
//
//  Created by Tan Way Loon on 06/01/2023.
//

import XCTest
@testable import MobileLifeTest

final class ImageCollectionViewModelTests: XCTestCase {
    var subject: ImageCollectionViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        subject = nil
        try super.tearDownWithError()
    }
    
    func testImageReturnEmpty() {
        MockAPI.retrieveImagesReturn = .empty
        subject = ImageCollectionViewModel(api: MockAPI.self)

        let expectation = expectation(description: "Images Relay should be empty")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertEqual(subject.picturesRelay.value.count, 0)
    }
    
    func testImageReturnSingle() {
        MockAPI.retrieveImagesReturn = .singlePicture
        subject = ImageCollectionViewModel(api: MockAPI.self)

        let expectation = expectation(description: "Images Relay should only return one picture")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertEqual(subject.picturesRelay.value.count, 1)
    }
    
    func testImageReturnMultiple() {
        MockAPI.retrieveImagesReturn = .multiplePicture
        subject = ImageCollectionViewModel(api: MockAPI.self)

        let expectation = expectation(description: "Images Relay should return multiple pictures")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertGreaterThan(subject.picturesRelay.value.count, 1)
    }
}
