This is just a mirror of
[thrift.vim](https://raw.github.com/twitter/thrift/master/contrib/thrift.vim). Hopefully others find it useful.

I added an ftdetect and put things in folders to make it "just work".

This is from the 0.9.x release.


## Installation ##

I use this with [pathogen.vim](https://github.com/tpope/vim-pathogen).
Once you have that installed, you can simply:

    cd ~/.vim/bundle
    git clone git://github.com/theevocater/thrift.vim.git

Next time you open a thrift file it should be nicely syntax-d.


### With submodules ###

If you keep your vim files in a git repo, install pathogen and:

    cd ~/.vim
    mkdir bundle
    git submodule add git://github.com/theevocater/thrift.vim.git bundle/thrift/
