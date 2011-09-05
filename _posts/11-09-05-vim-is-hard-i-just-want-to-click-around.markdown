---
layout: post
title: Vim is hard, I just want to click around
excerpt: Setting up MacVim with Janus and a sexy file drawer
published: true
---

More than a year ago, I wrote about [switching to Vim](http://jeffkreeftmeijer.com/2010/stumbling-into-vim/). I was quite happy with how it all worked, but I found myself switching back to Textmate after a while. I read through a lot of dotfiles to "steal" some configuration options from others, took some time to go through `vimtutor`, read some blogposts and after a while, I was quite happy with how it all worked.

![Alloy's MacVim fork with Janus](http://jeffkreeftmeijer.com/images/vim2.png)
<span class="small">My new, full screen Janus-powered MacVim editor, with sexy drawer</span>

But after some time, I started switching back to Textmate. At first, I only opened it up to do non-code writing, but after a while, I started using Textmate for bigger projects too since it felt easier to navigate around project files. After about half a year, I was back to Textmate completely and I only used Vim on my Ubuntu-powered netbook sometimes.

Sometimes, I just want to click around, especially when looking for and opening files. I missed Textmate's drawer and never really got the hang of the NERDTree plugin I was using. Besides that, my Vim config felt incomplete, but I didn't know exactly what I was missing or what I needed to install to make everything easier. While I loved editing code in Vim, I couldn't really get used to the rest of the editor.

### MacVim

It turns out I wasn't the only one running into problems like this. Less than five kilometers from where I was switching back, [@alloy](http://twitter.com/alloy "Eloy Durán") decided to fix the problem instead of running back to Textmate. He created [his own fork of MacVim](https://github.com/alloy/macvim) and added a Textmate-like file drawer.

I got a new hard drive, which was a great excuse to do a clean install and set up a better work environment. I started out by installing Eloy's MacVim branch, and quickly found out the drawer works as good -- or even better -- as Textmate's.

The one thing I didn't really like was the new native Lion fullscreen mode, which newer versions of MacVim use by default. Its animations annoyed me and when using multiple screens, it cleared out the second screen when I put something in fullscreen mode on the first one. In my earlier attempt at using MacVim, they rolled their own fullscreen mode that worked perfectly and I wanted that back.

Luckily, that's pretty easy to achieve. It's a matter of throwing this into your terminal:

{% highlight console %}
$ defaults write org.vim.MacVim MMNativeFullScreen 0
{% endhighlight %}

If that doesn't work for you, update MacVim. I had some problems getting it to work, having a slightly older version.

### Janus

Instead of going around stealing configurations from other people's dotfiles again, I installed [Janus](https://github.com/carlhuda/janus). Janus is an awesome Vim config by [@wycats](http://twitter.com/wycats "Yehuda Katz") and [@carllerche](http://twitter.com/carllerche "Carl Lerche"), which comes with a bunch of great plugins and color schemes and it probably has everything you need.

It installs NERDTree by default, which I don't need because I already have a file drawer. It's really easy to skip it, though.  Before running `rake` in your `~/.vim` directory, create a file named `~/.janus.rake` and put this in:

{% highlight ruby %}
skip_vim_plugin "nerdtree"
{% endhighlight %}

If you already installed before (with NERDTree enabled), be sure to delete the `~/.vim/nerdtree` directory.

Without NERDTree, I started getting some error messages when changing directories inside MacVim:

    Error detected while processing function ChangeDirectory:
    line    4:
    E492: Not an editor command:   NERDTree

So, after looking around for a bit, I found the problem in `~/.vim/gvimrc`. In the `ChangeDirectory` function, I removed [line 172](https://github.com/carlhuda/janus/blob/master/gvimrc#L172) and the problem disappeared. I haven't had time to turn this into a patch, sorry.

Oh, and while Janus comes with a plugin that highlights trailing whitespace, it doesn't automatically clear it when you save. I put this in my `~/.vimrc.local` file to never have to worry about that again:

    autocmd BufWritePre * :%s/\s\+$//e

### Click, click?

What I found amazing is how fast I started to get used to switching files without clicking and using the drawer. Janus installed Command-T and I started to use that most of the time. It can even open files in new tabs by pressing `^+T` instead of Enter after selecting the file you need. Right now, I'm keeping the drawer closed by default and I'm using` ⌘+⇧+D` to pop it out whenever I need it.

Like last time, I still have a lot to learn -- both about Vim itself and the plugins I have installed -- but I think my setup is pretty good now. Have any great tips to make this even better? Let me know in the comments!