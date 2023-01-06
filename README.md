# Mobile Life Programming Test

# Notable features
- No duplicate image loading between list and details page. They both use the same downloaded image. Benefit is that users do not have to wait for the image to load on the list page before navigating into detail. The image will display as needed
- Images are properly cached to prevent the need to reload images that have been loaded prior
- UI supports both portrait and landscape mode
- Images are always centered on the layout when user scrolls 
- Coordinator pattern applied in the project to reduce dependencies among view controllers.

# Assumptions made
- Code-based UI, no depedencies on storyboard. Storyboard while nice to see for simpler projects can get very cumbersome and abstracts out a lot of details that are harder to debug as project grows. In my own experience, we have gone full code UI to allow faster debugging and still maintain high readability to ensure fast development cycles
- This project is written in MVVM instead of something more advance like VIPER because the projet scope is rather small and file size are still relatively acceptable. An architecture like VIPER would take a lot more setup and just be overkill for a test assignment. 
- Unit testing for this test is not meant for code coverage but rather to demo how I would DI mock objects to achieve the desired effect of ensuring all code paths are tested

# Ideas For Future Iteration
1. Notice how we have passed in the full pictures relay in the initializer for *ImageDetailViewModel*. This is purposely done to allow the possibility of adding a next and previous button to allow cycling through the list without having to first go back to the list page

