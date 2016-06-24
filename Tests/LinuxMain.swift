import XCTest
@testable import BluemixObjectStorageTestSuite

XCTMain([
	testCase(ObjectStoreTests.allTests),
	testCase(ObjectStoreContainerTests.allTests),
	testCase(ObjectStoreObjectTests.allTests),
	testCase(UtilsTests.allTests)
])
