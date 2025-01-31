# Fetch Recipes Take Home Assignment

### Screenshots
<p float="left">
    <img src="/Recipes.png" alt="Recipes Loaded" height="400">
    <img src="/No-Recipes.png" alt="Recipes not available" height="400">
    <img src="/Malformed-Recipes.png" alt="Recipe Issue" height="400">
    <img src="/filter.png" alt="Filter Options" height="400">
</p>

## Summary

The Recipe App is a simple app that shows a list of recipes. You will see a picture of the prepared meal along with its title and cuisine type. The recipes also have a web link and a YouTube link to get detailed instructions on how to prepare the recipe.

Highlights:
- A vertical scrolling list of recipes
- External links to the web and YouTube to get detailed instructions
- Filter options to filter recipes by cuisine type
- An image of the prepared meal
- Pull down the list to refresh the recipes
- Supports iOS 16.0+

### Code Summary

The app is built using SwiftUI, Swift Concurrency, Async/Await, and uses the MVVM pattern. The project can be broken down into a few main components:

- Networking: The app fetches recipes in JSON format from an API. The networking layer uses protocols to abstract the network calls, so any APIs can utilize the protocol to quickly set up a new request by defining the Decodable model (as an associatedtype) and the URL for the request. The layer also allows you to mock the API response for testing purposes. All network requests use Async/Await to ensure the Main Thread is not blocked while waiting for the network response.

- Image Caching: To allow the images to load quickly and efficiently, the app will asynchronously load the images while saving them to disk for future use. The image cache is a global actor so it can be used for images throughout the app. An actor also ensures the storage and retrieval are happening in the background, allowing the Main Thread to still operate smoothly, while also saving the disk access from data races.

- Cache Async Image: A homegrown version of AsyncImage that uses the Image Caching layer under the hood to load the images from disk if they were previously stored, otherwise it will load the image from the network. This helps to ensure the images are loaded quickly and efficiently, keeping the scrolling as smooth as possible.  Saving to disk also means that future runs of the app will have the images cached and ready to go.

- View/ViewModel: All UI is built using SwiftUI and the MVVM pattern. The ViewModels are all MainActors to ensure the Main Thread is used to update the View. The View is updated by having the ViewModel publish changes to the View using @Published properties. The View will then update when the ViewModel changes. This separates the business logic from the view, which makes it easier to maintain and change the UI or business logic separately, it also makes unit testing easier.

- Unit Testing: The app has unit tests that test the networking layer, image caching, and the various ViewModels. The unit tests use Swift Testing. The main API, with recipes, empty and malformed all are mocked so the unit test doesn't have to use the APIs. To test the image caching a locally loaded image is used instead of a newtork request too.

### Focus Areas:

The main areas of focus:
- Image Caching: This requirement was called out explicitly and since the app is one screen that is a vertical scroll view, it is important to the main functionality of app to have the images load efficiently and keep the UI scrollling smoothly.
- Networking: Without the network there would be no recipes in this app, so it was important to have a solid networking layer. The networking layer is also abstracted to allow for easy testing and to allow for easy setup of new APIs and testing.
- Unit Testing: Using good MVVM and allowing APIs to be mocked supports the ability to test the app. The app has a good amount of unit tests to ensure the app is working as expected.

### Time Spent: 

I spent around 10 hours on this project.  
- 1 hour: Setting up the project and doing general research and planning out the project
- 1 hour: Setting up the networking layer
- 2 hours: Setting up the image caching layer and the Cache Async Image replacement
- 3 - 4 hours: Building the Views and the ViewModels
- 2 hours: Testing, unit testing, touching up, and debugging the app

### Trade-offs and Decisions:

Although the JSON APIs can be mocked in the Unit Test with the current design, some unit testing uses network calls. Specifically, when testing the Cache Async Image View Model, internally it uses the Image Caching layer, which uses the network to load the image. This could be improved by adding a mock image loader in the Image Caching layer, but I felt this was a trade-off that was acceptable for this project. Using APIs in unit testing is generally not recommended, because APIs can fail, can cost money, but in this case, I felt it was an acceptable trade-off.

### Weakest Part of the Project:

The weakest part of the project is the UI. The UI is very basic and could use some more design work. The app is very functional, but the UI could be improved to make it more visually appealing.

### Additional Information:

Requirements met:
- [x] Recipe app loads a list of recipes from the provided API
- [x] Recipe shows name, photo, and cuisine type
- [x] Users can refresh the list by pulling down on the list view, or button press on the error or empty state
- [x] Enhanced screen by allowing you to filter the recipes by cuisine type
- [x] App is one screen
- [x] Swift Concurrency
- [x] No External Dependencies
- [x] Implemented homegrown image caching and loading
- [x] Unit Tests
- [x] SwiftUI / iOS 16.0+ support
- [x] Malformed and Empty recipes handled

### Video (GIF)
<img src="/demo.gif">
