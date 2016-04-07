//
//  main.swift
//  TestApp
//
//  Created by Anton Aleksandrov on 4/6/16.
//
//

import Foundation

print ("Hello1")

class Tester{
	let projectId = ""
	let userId = ""
	let password = ""
	let containerName = "FileContainer"
	let objectName = "hello.txt"
	let region = ObjectStore.REGION_DALLAS
	
	func run(){
		let objStore = ObjectStore(projectId: "")
		objStore.connect(userId: userId, password: password, region: region) { (error) in
			if let error = error {
				print("connect failure \(error)")
			} else {
				print("connect success")
				self.getContainer(objStore)
			}
		}
	}
	
	func getContainer(objStore:ObjectStore){
		objStore.retrieveContainer(name: containerName, completionHandler: { (error, container) in
			if let error = error {
				print("retrieveContainer failure \(error)")
			} else {
				print("retrieveContainer success")
				self.getObject(container!)
			}
		})
		
	}
	
	func getObject(objContainer:ObjectStoreContainer){
		objContainer.retrieveObject(name: objectName) { (error, object) in
			if let error = error {
				print("getObject failure \(error)")
			} else {
				print("getObject success")
				self.loadObject(object!)
			}
		}
	}
	
	func loadObject(object:ObjectStoreObject){
		object.load(shouldCache: false) { (error, data) in
			if let error = error {
				print("loadObject failure \(error)")
			} else {
				print("loadObject success \(data)")
			}
		}
	}
}

Tester().run();
#if swift(>=3)
NSRunLoop.current().run()
#else
NSRunLoop.currentRunLoop().run()
#endif
