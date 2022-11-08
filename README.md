# MovieBrowser

Welcome to the second stage of recruitment process for Junior iOS developer position in Lake Coloring. This simple app will serve us a a starting point to few programming tasks.

The `MovieBrowser` is an app that allows user to browse "The Movie Database". For now, it allows only to see the list of all genres available in the service. Our task is to expand this functionality a bit. Here is the list of a few tasks for you.

1. As you can see, the app contains two view controllers: `GenresViewController` and `MoviesViewController`. Let's start by creating navigation between them two. After tapping on a genre, the app should show `MoviesViewController` with the name of the genre as a navigation bar title.
2. The `MoviesViewController` is now empty, but to show something there, we need some data. Add an API call for fetching the list of movies for given genre (they should be sorted by popularity and limited to 50). You can find full documentation of the API we use [here](https://developers.themoviedb.org/3/getting-started/introduction).
3. Now it's time to populate `MoviesViewController`. Please, show fetched movies in the form of a list. Each movie should be shown as a cell implemented like on the designs. You can find them [here](https://www.figma.com/file/fW3RIgKVAeaEIbOs4mIuBc/Recruitment-task) (let's not bother about the movie poster for now).
4. As you may noticed, movies data doesn't contain the poster image. To download it, we have to implement more API calls. Please, implement them and show poster. If poster is not yet available, app should show placeholder, which you can find in Figma file. When poster is downloaded, it should replace the placeholder with fade-out/in animation.
5. As a final step, let's show duration of movie in format `Xh Ym`, if movie is longer than 1 hour, or just `Ym` otherwise (`X` is number of hours and `Y` is number of minutes).
6. Write tests that check if duration formatting works well.
7. When you finish, please send us the code in form of a git repository.

And finally, just a few tips that might be helpful:
1. This app, although really simple, can be written in very different ways. If you think, that something can be done in better way, don't hesitate to show off and change some parts of it.
2. Help us understand your ideas and your code. If you think that a piece of code can be misunderstood, please write a comment why you did it that way.
3. Use Git. This is an industry standard nowadays and we require the knowledge of it.
4. Please, don't use third-party frameworks. In real life, they are really helpful and can speed up the development of the app by a lot, but here we'd like to check if you know the basic mechanisms used across the whole iOS platform.
5. Use `/configuration` endpoint to fetch data needed for downloading images. You can find more info in the API docs. Generally, this documentation is really good and you should check it when you stuck with networking code.
6. Don't use SwiftUI - although it's probably the future of writing UI for iOS, we still have a lot of UIKit code in Lake, so we want you to be able to work with that code too.
7. We'd like to encourage you to show off your skills. Are you good at animating views? Good, add some additional moves to the UI. Or maybe you are more into design patterns? Just refactor a part of the code to a better solution. Basically, don't hesitate to show us everything that will help us to see your potential.

If you have any questions, don't hesitate to contact with us.

Good luck!
