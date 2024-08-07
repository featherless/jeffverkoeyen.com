# Three20 is -insert expletive-

From my monitoring of Twitter so far today, it seems some people are angered by the fact that Three20 is composed of many libraries.

Here are some of the arguments posited against Three20 lately and my corresponding rationales behind why the modular design will begin to solve them.

## Give me what I need, no more, no less.

Three20 is a massive library. Due to the way it was originally created, many of the components of Three20 have interdependencies that, today, make it impossible to pull out single components and use them in your app. For example, if you want to use a TTPhotoViewController, you currently need to import every single line of Three20 code to do so.

There’s no reason that this should be the case. If I’ve already built an application and all I want to do is add a launcher, there is absolutely no reason why I should have to include the entire Three20 library to do so; I just want to add a Three20Launcher module, that’s it.

Even if I’m starting from scratch, it would be much easier to grasp Three20 if I could start from some basic components and add more modules as I need them, rather than having to wade through the entire library to begin with.

A modular design puts the choice into the developer’s hands about what they want to use in their project.

## Three20′s documentation sucks

Pulling apart the library into separate modules is going to make it much easier to document the library. The primary obstacle to documenting Three20 right now is that it’s just so goddamn confusing. If the lines in the sand are drawn more clearly between components, it will be much easier first off to comprehend their usefulness, and second off to convey their usefulness.

## Three20′s xx feature is outdated by Apple’s yy library

Another argument posited on Twitter today and in the past is that Three20 is outdated, that many of its components have been deprecated by technologies that Apple has included in newer APIs.

This is true. TTStyle, for example, provides functionality that overlaps with CoreText.

But this just furthers the argument for pulling Three20 apart into separate modules. Why should anyone be forced to use TTStyle if they want to use aspects of Three20 but use CoreText for their text rendering? With the new modular design, you’ll have that choice.

## An ecosystem of extensions

My long-term vision of Three20 is to see it become a vibrant ecosystem of extensions provided by the community. The only way this could be possible is if we allow projects to be distinct from one another.

## tl;dr Summary

Three20 has its share of issues. But I firmly believe that it’s only advantageous to discuss how broken something is with an equal or greater amount of discussion on how to fix it. Some developers are quick to point out the broken components of Three20, but these components are fixable.

And that’s what I plan to do.

Cheers,   
\- Jeff
