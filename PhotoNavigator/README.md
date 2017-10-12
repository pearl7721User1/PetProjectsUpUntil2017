# PhotoNavigationUX


<p align="center">
<img src="https://user-images.githubusercontent.com/18760280/28749428-45ba9a72-74c7-11e7-94eb-b17401aa76c4.gif">
</p>


### What is it made of?
It is made of a view that allows you to swipe through the images and an indicator view 
Since the view takes the whole screen and you don’t know where you are while navigating, the indicator view is needed to tell you where you are.

<p align="center">
<img src="http://postfiles2.naver.net/MjAxNzA3MzBfMjEg/MDAxNTAxMzU5Njc4NTg3.5UWHGXuv4UAojFe6G1OUyR6Lzn8t-fo1ZHKgGBFqVEog.jRauC8qb9A-SAxqg46xa4GXCp8wXfjK6Yn5okawOygYg.JPEG.pearl7721/IMG_2552.jpg?type=w1">
</p>
<p align="center">
  <b>- the Photos app screenshot -</b><br>
  <br><br>
</p>



### Why scrollview? and what is the content size? 
UIScrollview is the same ordinary view except it embeds contents inside. It allows you to swipe through the contents.
UIScrollview inherently has the content size property. The content size makes the boundary that tells you how far you can scroll.
Naturally, you need to set its content size as the same as all the boundaries of the embedded views put together.
Either you give explicit content size, or you can set constraints to accomplish this.


<p align="center">
<img src="http://postfiles10.naver.net/MjAxNzA3MzBfMzAw/MDAxNTAxMzU5NjgyNjgx.wmBZnvlwMyRv7nkjxJ8qoB-FcTj5TvCIZQEsl2cXNDMg.FOfE4c3Re0EYwHK0bLyVTVpbOy5_V5dKnuGkK1eDwbMg.JPEG.pearl7721/ContentRect.jpg?type=w1">
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
<img src="http://postfiles14.naver.net/MjAxNzA3MzBfMjMz/MDAxNTAxMzU5NjgxNjky.LrfgX1t4OIb1luEbSMwWrlrpeaqclfCpE7Mi4_-ENxwg.8kfLZFNcQj-8hPNzqS9PZkO4tCBCThHbvhia73DJ7hAg.JPEG.pearl7721/Constraints.jpg?type=w1">
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
<img src="http://postfiles8.naver.net/MjAxNzA3MzBfMTI5/MDAxNTAxMzU5Njc5ODE3.SzbFTXe_3lgrOhYIswOtn-pCrJ-PDnNUhbQfHWIik44g.mobKJYZ0URwmDp6eAPSmE4_uB3eDidx6h7PrX8YOssog.JPEG.pearl7721/IMG_2553.jpg?type=w1">
</p>
<p align="center">
  <b>- How the Photos app separate contents from one another-</b><br>
  <br><br>
</p>


I introduced two frame views, one attached to the left side, the other attached to the right side for each focused image. 
They are offscreen, but they are visible whenever the scroll occurs. They make it look like the content is separate from one another.
Whenever scroll event occurs, the frame view(either right side or left side according to the scroll direction) move as much the same distance as the content offset is moved. Actually, it must move a little bit more, because it has to end up being positioned offscreen again after the scroll is finished.

<p align="center">
<img src="http://postfiles5.naver.net/MjAxNzA3MzBfMjcg/MDAxNTAxMzU5NjgwNzQz.WmqC_mgtWNtPT16ggG0blbHsX_3qAM4E_A07UuY-G4Ag.CwOwmOgwp7FPri6sy85oPqxnJTSwRIcN1oGUmQ107rsg.JPEG.pearl7721/Offscreen.jpg?type=w1">
</p>



### Building the connection between the view and the indicator view
The view that takes the whole screen and its indicator view must go hand in hand.
Whatever the scroll events occur on one view, the change has to be forwarded to the other view, and vice versa.
