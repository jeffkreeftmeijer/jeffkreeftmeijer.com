Well over a year ago, I wrote about [using relative line numbers in Vim](http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/) to speed up movement by displaying line numbers relative to the current line. This makes it easier to find out how many lines up or down you have to jump to get to where you want to be.

Because I wanted to switch back to absolute line numbers when I wasn't busy moving around files, I wrote a small vim plugin to do so and released it as [vim-numbertoggle](https://github.com/jeffkreeftmeijer/vim-numbertoggle). This allowed me, and a lot of other people, to use relative numbers when it made sense, and switch back to the default when it didn't.

Since Vim 7.4, you can enable both the `number` and `relativenumer` settings at the same time, which will give you something I'll call hybrid line number mode. Using that, all lines will show their relative line number, except for the line you're currently on, which will show its absolute line number.

![The New hybrid line number mode in Vim 7.4](http://jeffkreeftmeijer.com/images/hybridnumber.png)
<span class="small">Hybrid line number mode in Vim 7.4</span>

Setting up Vim to use hybrid mode is easy. All you have to do is enable both the `number` and `relativenumber` settings in your config file;

{% highlight vim %}
set relativenumber 
set number          
{% endhighlight %}

I wrote the vim-numbertoggle plugin to switch between relative and absolute line numbers because I couldn't display them both at the same time. The next best thing was to show relative numbers in normal mode ---because that's the mode you use to move around--- and absolute line numbers in insert mode, or when the editor loses focus.

Vim's hybrid mode isn't exactly the same as what vim-numbertoggle did, but I believe it's the most ideal solution right now, so I'm switching to it. This means I won't be able to maintain vim-numbertoggle, since I won't be using it anymore.

However, as of yesterday, the plugin has been updated to work nicely with Vim 7.4, so you can keep using it like you did before. I do want to urge you to check out hybrid number mode, though, because it's probably better than what I came up with.
