//
//  UserTest.swift
//  FlavorSaverTests
//
//  Created by Jacky Gao on 11/5/23.
//

import XCTest
import SwiftUI
@testable import FlavorSaver

@MainActor
final class UserTest: XCTestCase {
    var user : User = User(userID: "testUser", username: "TestUser", profileID: 0)
    let testRecipe = Recipe(id: 0, name: "testRecipe", image: "", imageType: "", servings: 0, readyInMinutes: 0, author: "", authorURL: "", spoonURL: "", summary: "", cuisines: [], dishTypes: [], ingredientInfo: [], ingredientSteps: [])
   
    override func setUpWithError() throws {
        let _ = user.createFolder(name: "TestFolder")
    }
    
    override func tearDownWithError() throws {
        for folder in user.getSavedRecipeFolders() {
            user.deleteFolder(folderName: folder.name)
        }
    }
    func testInitializationWithProfileID() {
        XCTAssertEqual(user.getUserID(), "testUser")
        XCTAssertEqual(user.getUsername(), "TestUser")
        XCTAssertEqual(user.getProfileID(), 0)
        XCTAssertEqual(user.getSavedRecipeFolders().count, 1)
    }
    
    func testInitializationWithoutProfileID() {
        let userWithoutProfileID = User(userID: "testUser2", username: "TestUser2")
        XCTAssertEqual(userWithoutProfileID.getProfileID(), 0)
    }
        
    func testSetProfileID() {
        user.setProfileID(profileID: 2)
        XCTAssertEqual(user.getProfileID(), 2)
    }
    
    
    func testAddRecipeToFolder() {
        let recipe = testRecipe
        user.addRecipeToFolder(recipe: recipe, folderName: "TestFolder")
        XCTAssertTrue(user.isRecipeSavedInFolder(recipeID: 0, folderName: "TestFolder"))
    }
    
    func testRemoveRecipeFromFolder() {
        let recipe = testRecipe
        user.addRecipeToFolder(recipe: recipe, folderName: "TestFolder")
        user.removeRecipeFromFolder(recipe: recipe, folderName: "TestFolder")
        XCTAssertFalse(user.isRecipeSavedInFolder(recipeID: 0, folderName: "TestFolder"))
    }
    
    
    func testCreateFolder() {
        print (user.getSavedRecipeFolders().count )
        XCTAssertTrue(user.createFolder(name: "NewFolder"))
        XCTAssertEqual(user.getSavedRecipeFolders().count, 2)
    }
    
    func testInvalidFolderName() {
        XCTAssertTrue(user.createFolder(name: "ExistingFolder"))
        XCTAssertFalse(user.createFolder(name: ""))
        XCTAssertFalse(user.createFolder(name: "  "))
        XCTAssertFalse(user.createFolder(name: "ExistingFolder"))
    }
    
    func testDeleteFolder() {
        XCTAssertTrue(user.createFolder(name: "ToDelete"))
        XCTAssertEqual(user.getSavedRecipeFolders().count, 2)
        user.deleteFolder(folderName: "ToDelete")
        XCTAssertEqual(user.getSavedRecipeFolders().count, 1)
    }
    
    func testGetSavedRecipesInFolder() {
        let recipe = testRecipe
        user.addRecipeToFolder(recipe: recipe, folderName: "TestFolder")
        XCTAssertEqual(user.getSavedRecipes(folderName: "TestFolder").count, 1)
    }
    
    func testChangeFolderOrdering() {
        XCTAssertTrue(user.createFolder(name: "OrderedFolder"))
        user.changeFolderOrdering(folderName: "OrderedFolder", ordering: "recent")
        XCTAssertEqual(user.getSavedRecipeFolders().first(where: {$0.name == "OrderedFolder"})!.ordering, .recent)
        
        user.changeFolderOrdering(folderName: "OrderedFolder", ordering: "alphabetical")
        XCTAssertEqual(user.getSavedRecipeFolders().first(where: {$0.name == "OrderedFolder"})!.ordering, .alphabetical)
        
        user.changeFolderOrdering(folderName: "OrderedFolder", ordering: "alphabeticalReverse")
        XCTAssertEqual(user.getSavedRecipeFolders().first(where: {$0.name == "OrderedFolder"})!.ordering, .alphabeticalReverse)
        
        user.changeFolderOrdering(folderName: "OrderedFolder", ordering: "recentReverse")
        XCTAssertEqual(user.getSavedRecipeFolders().first(where: {$0.name == "OrderedFolder"})!.ordering, .recentReverse    )
    }
    
    func testChangeFolderName() {
        XCTAssertTrue(user.createFolder(name: "ToRename"))
        XCTAssertTrue(user.getSavedRecipeFolders().contains(where: {$0.name == "ToRename"}))
        XCTAssertTrue(user.renameFolder(oldName: "ToRename", newName: "Renamed"))
        XCTAssertTrue(user.getSavedRecipeFolders().contains(where: {$0.name == "Renamed"}))
    }
}
