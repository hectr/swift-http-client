import Foundation
import httpClient
import XCTest

final class URLComponentsTests: XCTestCase {
    var sut: URLComponents!

    override func setUp() {
        super.setUp()
        sut = URLComponents()
    }

    func givenHasAuthority() {
        sut.port = 1
    }

    func givenHasNotAuthority() {
        sut.host = nil
        sut.password = nil
        sut.port = nil
        sut.user = nil
    }

    func testHasAuthorityAndHasUser() {
        sut.user = "some user"
        XCTAssertTrue(sut.hasAuthorityComponent)
    }

    func testHasAuthorityAndHasPassword() {
        sut.password = "some password"
        XCTAssertTrue(sut.hasAuthorityComponent)
    }

    func testHasAuthorityAndHasHost() {
        sut.host = "some host"
        XCTAssertTrue(sut.hasAuthorityComponent)
    }

    func testHasAuthorityAndHasPort() {
        sut.port = 1
        XCTAssertTrue(sut.hasAuthorityComponent)
    }

    func testHasAuthorityWithPath() {
        givenHasAuthority()
        XCTAssertTrue(sut.isPathValidWithAuthorityComponent)
    }

    func testHasAuthorityWithSlashPrefix() {
        givenHasAuthority()
        sut.path = "/path"
        XCTAssertTrue(sut.isPathValidWithAuthorityComponent)
    }

    func testHasAuthorityWithoutSlashPrefix() {
        givenHasAuthority()
        sut.path = "path"
        XCTAssertFalse(sut.isPathValidWithAuthorityComponent)
    }

    func testHasNotAuthorityWithEmptyPath() {
        givenHasNotAuthority()
        XCTAssertTrue(sut.isPathValidWithoutAuthorityComponent)
    }

    func testHasNotAuthorityWithoutSlashSlashPrefix() {
        givenHasAuthority()
        sut.path = "/path"
        XCTAssertTrue(sut.isPathValidWithoutAuthorityComponent)
    }

    func testHasNotAuthorityWithSlashSlashPrefix() {
        givenHasAuthority()
        sut.path = "//path"
        XCTAssertFalse(sut.isPathValidWithoutAuthorityComponent)
    }

    func testHasNotAuthorityAndHasNotUserPasswordHostPort() {
        XCTAssertFalse(sut.hasAuthorityComponent)
    }
}
