# LargeSizedImageDownloadsAndPersistence

This is a simple project to study a couple of iOS subjects, such as persistence and managing background download tasks, and some other peripheral issues.
The outcome of the project at the moment looks likes this.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31137391-6e997634-a86b-11e7-8dbc-61af109597b8.png">
</p>


And, here are some demystified knowledge I’ve come to learn as I’ve been doing this project.

### Q. What are the possible app states? persistence?

One common app’s life cycle would be…
User opens the app; use the app for a while; tap the home button and exit the app; do some other tasks and forgets that the app is still running in the background.

The equivalent in terms of the app’s state perspective is…
‘App Launch’ -> ‘Stays foreground’ -> ‘Enters background’ -> ‘OS silently terminates the app’

In some apps where they provide downloading files in large size, downloads should keep going even if the user is not having it on the foreground. 
Background URL Session is the perfect option for that needs.

As the name suggests, session will last beyond the app launch, termination as long as it is configured as a background session with the same identifier. That way, downloads will continue even if the app goes to the background, and the tasks are restorable even if the app is terminated eventually.

Also, you can benefit from having a background session when the downloads are canceled for some reasons, for example, the user turns to the app switcher and quits the app, before the download is finished.

The unfinished downloads are not lost. They are cached in the app’s disk storage. You can pull them out upon the next app launch by just asking the background session.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31137934-fc48f18e-a86c-11e7-8421-6e8b72b45b80.png">
</p>


### Q. Why does each download unit preserve task identifier? What does the task identifier do?

Each time the URLSession creates a download task, the task is given an identifier. 
As long as the download task is created by the same URLSession, each identifier is unique. 

The background URLSession may have the latest resumeData if the task is terminated abruptly. (It happens when the user terminates the app without canceling the download or when the app is silently terminated by the system in the background.)

This app tries to pull out the cached resumeData upon each launch. 
By comparing the task identifier, you can update the resumeData for the right download task.


### Q. What kind of download states are there?

Four states exist for managing the download task. Ready, Waiting, Downloading, Finished.
Each state is self-explanatory. 
Some state transition are triggered by the URLSession delegate, while others by the user.
The user taps the button in the view layer, and then, the corresponding download task is started or canceled depending on the state it is in.


### Q. How is the view interacting with the model?

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31137935-fc4c26ce-a86c-11e7-9812-97a5d23ac1ac.png">
</p>

Since the download tasks are multiple, this app is using TableView, binding(using selector, delegate) each cell to each download task model.
There are two actions that the user can trigger to transition the model’s state - ‘start downloading’, ‘cancel downloading’, which is dictated by the view layer.
On the other hand, the model’s updates are notified to the view layer each time the download progress is made, and state is changed.


### Q. Why is binding properties needed when it is writing/reading from Core Data in the code?
Only some types of properties archive in the Core Data. URLSessionDownloadTask, URLSession are not among them. Also, you cannot use didSet on NSManagedObject properties. That's why I decided to seperate some properties from them so that I can make good use in the code level. Because of this, binding Core Data properties and code level properties when writing, reading is necessary.
