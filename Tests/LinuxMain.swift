import XCTest
@testable import BluemixObjectStorageTests

XCTMain([
	testCase(ObjectStoreTests.allTests),
	testCase(ObjectStoreContainerTests.allTests),
	testCase(ObjectStoreObjectTests.allTests),
	testCase(UtilsTests.allTests)
])
