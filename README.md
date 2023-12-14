# FlavorSaver

FlavorSaver is a mobile application that allows users to discover, search for, and cook delicious recipes. It offers a range of features designed to enhance the cooking and recipe-saving experience.

## Features

### Recipe Search
- Search for recipes based on a variety of search parameters, including incredients, dishes, and cuisine types.
- For each search, browse from several categories of recipes filtered on tags

### Recipe Discovery
- Explore trending and recommended recipes
- As a creator, have your sponsored recipe recommended to users of the app
- View detailed recipe information, including name, description, cooking time, dish type, cuisine type, recipe creator, ingredients, and cooking steps.
  
### Cooking Mode
- Enter a "cooking mode" to swipe between each recipe step with relevant ingredients displayed underneath.
- Navigate recipe steps using voice commands such as "next" and "previous."

### Recipe Management
- Save recipes from the search page, recipe detail page, and cooking mode.
- Organize saved recipes into user-created folders for personalized recipe management.
- Sort your recipes by recently added or alphabetical order to ensure easy retrieval
- Unsave recipes to remove them from the saved list.
- View the 10 most recently opened recipes in your profile.

## Implementation Decisions and Comments

### Technical
We decided to use Spoonacular API since it was the only API we could find that met all of our needs in finding recipes (having both ingredients, the cooking steps, and other useful information). In addition, we needed to use some sort of database to store these recipes to faciliate users saving recipes. We decided to use Firebase since it was the one we were most familiar with and knew could get the job done.

In addition, a GoogleInfo Plist is required for this app to function. This is required to access both the Firebase database to retrieve saved recipes in addition to containing the Spoonacular API key needed to search for recipes.

### Design
We decided to follow Apple's design patterns, as we not only believe it is what users would be most comfortable and familiar with, but also to maintain a professional look and build trust in our users. Nevertheless, we do include our orange brand of FlavorSaver for various parts of the app. 

### Vision
Our initial vision with this app was to create a platform in which users could both post their own recipes and search for others' recipes. This would allow a centralized place to keep all your recipes while providing a lower barrier of entry to creators interested in creating and posting their own recipes into the world. However, due to the scope of the project, we decided to use recipes from Spoonacular API and make cooking mode our main selling point. However, parts of this creator-supported space can still be seen in the app when clicking on an author of a recipe currently.

### Testing
There is a moderately exhaustive test suite which tests the models. Tests were only written for the models since UI tests would be unstable. While we strived for above 90% test coverage, some models did not reach this amount. 

Reasons for lacking test coverage in some models:
- The missed lines were error branches. These error branches would be infeasible to write into our test cases, since some of them include failures on Firebase's end as well as the API call's end, which we cannot induce naturally.
- Likewise, the signUp function in AccountManager is not tested since this would require signing up an account everytime the tests are run, which would be impractical and a waste of resources on Firebase's end.
- In FirebaseManager, all of the functions are asychronous functions which talk to the Firebase database. However, in the event that the test case finishes which calls these functions, it is immediately halted. This is why `addRecipe` in FirebaseManager is "not tested" despite it explicitly being a test case in `UserTests`. Other tests which are sychronous in nature but have asychronous updates to the database act similarly. 

Disregarding these points, we do achieve above 90% test coverage for all of the models.

#### Bugs
There is one bug we were unable to fix - the "x" button to close out of cooking mode does not work on a device. However, it works in all scenarios in the simulator. We did not know how to debug this due to this disparity, and online sources did not help us either.

## Final Words
Enjoy cooking and exploring delicious recipes with FlavorSaver!

Built using Spoonacular API and Google Firebase
