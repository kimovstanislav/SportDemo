# SportDemo

Just a test demo project.

It uses no external dependencies, so to run the project just open the project file and start it.

I made a ViewModel with states and unit tests for them for the 1st screen (articles list). Article detail with a web view and select category screens are very basic in UI, functionality and architecture. In real world I'd take more time and make it more thorough, but that's extra time and effort, out of the scope of this small project.

The navigation between screens is also simple. Usually I'd use a Coordinator with UIKit UINavigationController, and if we want to create SwiftUI views, they can be wrapped in a HostingController. And a ViewModel for each screen, both UIKit and SwiftUI, so MVVM+C.
Here I wanted to use pure SwiftUI. With the new NavigationStack I'd research how to implement Coordinator for it, for pure SwiftUI navigation, that can be triggered programmatically. But I don't have experience with SwiftUI NavigationStack yet, so I'd need more time for that. Again, out of the scope of this project.
