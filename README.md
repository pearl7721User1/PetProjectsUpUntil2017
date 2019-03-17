# A little bit about myself

## 1. What are my repositories about?
Aside from what I do at work, I’d like to study several other topics of interests of iOS.
Here are some test suites or workarounds to pursuit further study.

## 2. What are two of my main interests?
### (1) Learn How to build Great User Experience
An app is more than just a program these days. 
A great app makes you feel you are controlling a fine-grained real-world physical machine. It takes me by surprise for the fact that it does on a mere two-dimensional display. I’ve never seen such things like that. That’s why I was gravitated to building mobile apps. I’d like to push the frontier of what I do and learn more about what iOS is capable of. 

### (2) Practice Software Design skills
As a software engineer, I expect to learn how to design apps better, which I mean better testability and scalability. 
It’s actually easier said than done. I believe the fastest way to improve myself is to experience real-world complexities a lot.
That’s the main reason why I plan to start a few projects on my own. Some of them are finished; some in progress; some I haven’t started yet.

# PetProjects
## Giwon Gallery
Among the feature that I worked on at work was photo editing feature.
Since the app I worked on is supporting iOS lower than 8.0 back in 2015. AssetsLibrary was the only option for me.
PhotoKit library that has been introduced since 2014 backs some great features I see in Apple Photos app.
I aimed to implement it on my own. For that, I need to practice to demystify PhotoKit because what’s explained in the documents was far beyond my reach of knowledge. 
I implemented a simple gallery app to study the use case of PhotoKit library and tried to get some ideas on what combination of those apis can lead to Apple Photos app. In addition, I studied interactive view controller transition issue.

## Giwon Image Cropper
What is AutoLayout?
It’s bounding the views with constraints and let the compiler figure out the layout rather than manually supplementing frames of the views.
It’s one stop solution for varying device sizes and device orientations.
To take advantage of it, I studied pure AutoLayout approach and mixed AutoLayout approach by implementing a simple image cropping interface.

## Giwon Large File Download
I listen to Audiobooks a lot, only each file size is huge.
Minimum a quarter of an hour, maximum an hour is spent to download it.
A download continuing feature is a paramount for a great user experience for such apps.
No matter the app is backgrounded or suspended or terminated, the download must continue.
URLSession supports that according to the document.
I wanted to try out to know what’s capable of and study more about URLSession.

## Giwon Memory Cell Game
I implemented the infamous memory cell game. 

## Giwon Photo Navigator
I implemented a preview feature that Apple Photos app features. Indicator is made of little thumbnail images and is scrolled left and right for preview.

## Giwon Layout Interface
I aimed to practice my skills to produce the same user interface that InstaLayout app features. Still ongoing as another project. 

## Giwon Podcast Searching
I aimed to study keyword based searching interface and tried some rss feed parsing. Still ongoing as another project.
