# Photo Navigator


<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/34079125-7014e9c8-e36a-11e7-9d90-c6b494077063.gif">
</p>


## Comments
I’ve started this project to reproduce Apple’s Photos app UI/UX. 

The UI/UX is distinct with the indicator on the bottom(the photo thumbnail) that tells you where you are. It’s something I wanted to accomplish by myself.

### Keywords: AutoLayout, Device Orientation Change, UIPanGesture, Subclassing, Delegate-Protocol pattern, Hit Testing

 
---

## What is it made of?
It is made of a view that allows you to swipe through the images and an indicator view.
Since the view takes the whole screen and you don’t know where you are while navigating, the indicator view is needed to tell you where you are.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31515640-28aa05f8-af96-11e7-8707-f104a009d0c1.jpg">
</p>
<p align="center">
  <b>- the Photos app screenshot -</b><br>
  <br><br>
</p>



## Why scrollview? and what is the content size? 
UIScrollview is the same ordinary view except it embeds contents inside. It allows you to swipe through the contents.
UIScrollview inherently has the content size property. The content size makes the boundary that tells you how far you can scroll.
Naturally, you need to set its content size as the same as all the boundaries of the embedded views put together.
Either you give explicit content size, or you can set constraints to accomplish this.


<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31515642-28dfdfe8-af96-11e7-804f-770104cd7501.jpg">
</p>
<p align="center">
  <b>- UIScrollView's embedded contents -</b><br>
  <br><br>
</p>


### AutoLayout approach for giving the content size?
The indicator view is made of several images. Each image is given a rectangle of the same size
As you move fingers and reach an image, the rectangle that holds the image opens up to reveal the whole contents of the image
It stays opened up until you reach another image. When that happens, the old image jumps back to the size like the others, and the newly reached image opens up. Having the scrollview contents bounded by constraints gives me an advantage of accomplishing this view opening, closing effect.


<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31515643-28f98c36-af96-11e7-9069-b72b1862ca6f.jpg">
</p>
<p align="center">
  <b>- Building UIScrollView with Autolayout-</b><br>
  <br><br>
</p>


I only need to access two constraints and edit its constant value, have it changed animatedly, and it will do.
I don’t need to rearrange the other content views’ position each time the boundary, position change occurs or the animation occurs.



### Separating contents from one another
I wanted the scroll view act pretty much like the photos app do.
The photos app makes it look like it separates each content from one another.


<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31515638-288eb8e8-af96-11e7-8e48-14660cbb2111.jpg">
</p>
<p align="center">
  <b>- How the Photos app separate contents from one another-</b><br>
  <br><br>
</p>


I introduced two frame views, one attached to the left side, the other attached to the right side for each focused image. 
They are offscreen, but they are visible whenever the scroll occurs. They make it look like the content is separate from one another.
Whenever scroll event occurs, the frame view(either right side or left side according to the scroll direction) move as much the same distance as the content offset is moved. Actually, it must move a little bit more, because it has to end up being positioned offscreen again after the scroll is finished.

<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/31515641-28c4e602-af96-11e7-9c36-6464ba076c2e.jpg">
</p>



### Building the connection between the photo navigator view and its indicator view
The photo navigator view that takes the whole screen and its indicator view must go hand in hand.
Whatever the scroll events occur on one view, the change has to be forwarded to the other view, and vice versa.
