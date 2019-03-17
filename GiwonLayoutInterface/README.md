# SampleInstaLayout

I’ve started this project in an attempt to replicate Instagram Layout app's UI/UX on my own.
Instagram Layout app offers intuitive UI/UX to create a distinct layout with the photos of your choice.
I’ve always wanted to implement it on my own to have some insights in building the relevant view models.

### Keywords: AutoLayout, Anchor Constraints, UIScrollView, UIPangesture, PhotoKit, UICollectionView, Image ContentMode, Snapshot, Subclassing, Delegate-Protocol pattern


----------------------------------------------------------------------------------------------------------------------------
## 0.1 release note

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079466-5a7086e8-e371-11e7-9d34-5bd30235a85c.gif">
</p>

### What kinds of Layout editing views exist? What are they made of?

Different types exist depending on the complexity of layout editing that the user might choose.
Type 1 and 2 allows editing frames for two different images, while Type 3 allows four different images.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079483-c1358eb4-e371-11e7-9249-09b428219798.png">
</p>

### How to build user interaction?

A Layout editing view is made of scroll views and size controls. 
Size controls are placed on the top of the other views and handles user interactions. When the size control gets a pan gesture, the size control asks the superview to see if the move is legal or not, since the size control doesn’t have any decision logics. If the move turns out as legal, the size control makes a move. The same move is notified to the superview, which manually updates positions, sizes of the other scrollviews and other size controls if needed.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079486-c1b5613e-e371-11e7-9bb2-acb8253a6f4f.png">
</p>


### How to make each scroll view zooms in/out by itself?

The trick is to make it look like it zooms in/out by itself.
As scrollview’s frame dynamically changes, the image view(scrollview’s subview) needs to update its widthAnchor, heightAnchor constants manually. I’ve given those values so that it shows ScaleAspectFill mode behavior as the size control changes its position.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079485-c18e8f1e-e371-11e7-8644-2548dfacd096.png">
</p>

* ScaleAspectFill Mode
<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079484-c165ad06-e371-11e7-9833-a5bede479d59.png">
</p>


----------------------------------------------------------------------------------------------------------------------------
