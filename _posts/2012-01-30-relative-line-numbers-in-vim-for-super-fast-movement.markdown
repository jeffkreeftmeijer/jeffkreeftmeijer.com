---
layout: post
title: Relative line numbers in Vim for super-fast movement
excerpt: Vim's relativenumber option is great, but sometimes it gets into your way a bit. With some clever settings, let's set it up so it just works.
published: true
---

Vim's <code>relativenumber</code> is a great setting to help you move around files quickly, but sometimes it can get into your way a bit. Luckily, it's really easy to add some clever settings, so Vim knows when to toggle between relative and absolute line numbers.

Moving around is probably the most useful thing to learn when you're starting to use Vim. A good starting point would be to get [@tednaleid](http://twitter.com/#!/tednaleid "Ted Naleid")'s [movement shortcuts wallpaper](http://naleid.com/blog/2010/10/04/vim-movement-shortcuts-wallpaper), a great cheat sheet you can use to get familiar with some of the commands.

![Relative line numbers in Vim](http://jeffkreeftmeijer.com/images/relativenumber.png)
<span class="small">Relative line numbers in Vim</span>

After a while, you'll be able to move by lines, paragraphs and whole screens. Using `gg` and `G`, you can move to the start and end of the file and you can use `/` and `?` to quickly find some text. Awesome.

But, what do you do when you know where to go and you need to move five, seven, or thirteen lines down? Maybe you want to delete seven lines. What about that?

Commands like `j` and `k` can be prefixed with numbers, so `5j` will jump down five lines. While that's pretty cool, chances are you won't actually do that, since counting lines usually takes longer than pressing `j` until you're on the right line, especially when you need to jump more than five lines. The same goes for deleting lines, as you probably switch to visual mode and press `j` a couple of times instead of counting lines and pressing `d7d`.

### Relative or absolute?

Since 7.3, Vim has a setting called `relativenumber` (you can set it up with `:set relativenumber` or `:set rnu`), which is a lot like the `number` setting you're probably using to have line numbers already. But, instead of showing the absolute line numbers from the top of the file, it shows them relative to the line you're currently on. That means the line below the current one is marked with 1, as is the line above. Now it's quite easy to find out how many lines you need to jump up or down.


You can't use absolute and relative line numbers at the same time, so let's set something up to quickly switch back to absolute line numbers if we need them. A simple function will do this for us and we'll use `<C-n>` (that's control + n) to call it:

{% highlight vim %}
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
{% endhighlight %}

### Sometimes you need absolute line numbers

Relative line numbers are only useful when moving, so there are a couple of situations where you'd probably want to switch back. Something I ran into was running tests.

Most testing libraries allow you to run a subset of tests based on their line number by running something like `rspec spec/models/user_spec.rb:15`. Whenever I'd switch to my terminal window to run a single test, I looked back at Vim to see which exact line number I needed to run. Because my line numbers were in relative mode, I needed to switch back to Vim, press `<C-n>` to get the absolute line numbers again, and then switch back to my terminal to actually run the spec.

A quick solution is to automatically switch to absolute line numbers whenever Vim loses focus, since we don't really care about the relative line numbers unless we're moving around:

{% highlight vim %}
:au FocusLost * :set number
:au FocusGained * :set relativenumber
{% endhighlight %}

There, now we only have relative numbers when we're in Vim. But there are more cases when we probably prefer absolute line numbers. In insert mode, for example.

I [disabled my arrow keys in insert mode](https://github.com/jeffkreeftmeijer/dotfiles/blob/master/home/.vim/config/hjkl.vim), to force myself to use `5j` in normal mode instead of just pressing `↓↓↓↓↓`. I never move around in insert mode, so relative numbers would be useless and I would probably prefer absolute line numbers. Let's tell Vim to automatically use absolute line numbers when we're in insert mode and relative numbers when we're in normal mode:

{% highlight vim %}
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
{% endhighlight %}

There. Now your line numbers are absolute by default, unless you're moving around in normal mode. This allows you to use the full power of relative line numbers, without them getting in your way.

Because you're so special to me, I've put the function and autocommands we talked about into a [plugin](https://github.com/jeffkreeftmeijer/vim-numbertoggle), so you can install it easily.

Also, I'd love to know how these settings (or the whole plugin) work for you, so be sure to let me know in the comments or in the [plugin's issue tracker](https://github.com/jeffkreeftmeijer/vim-numbertoggle/issues).
