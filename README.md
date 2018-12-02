olander's dotfiles
==================

Quick and dirty fork from [thoughtbot/dotfiles][origin] to better keep track of
my dotfiles. I should probably use the [the `*.local` convention][dot-local]
instead further down the line, but since I am not working with team dotfiles,
this will suffice for now.

[origin]: https://github.com/thoughtbot/dotfiles
[dot-local]: http://robots.thoughtbot.com/manage-team-and-personal-dotfiles-together-with-rcm

Requirements
------------

Install some dependencies on Ubuntu:

    sudo apt install vim git zsh silversearcher-ag tmux exuberant-ctags

Set zsh as my login shell:

    chsh -s $(which zsh)

Install
-------

Clone onto my computer:

    git clone https://github.com/tomasolander/dotfiles.git

(And remember to [keep my fork
updated](http://robots.thoughtbot.com/keeping-a-github-fork-updated)).

Install [rcm](https://github.com/thoughtbot/rcm):

    wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
    echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
    sudo apt-get update
    sudo apt-get install rcm

Install the dotfiles:

    env RCRC=$HOME/dotfiles/rcrc rcup

This command will create symlinks for config files in my home directory.

I can safely run `rcup` multiple times to update.

### Windows

Since we don't have rcm on Windows, we'll just focus on what's important and get
my configuration files installed in a rather patchwork manner.

Run the following in a PowerShell with administrative rights:

    git clone https://github.com/tomasolander/dotfiles.git $HOME\dotfiles
    cmd /c mklink _vimrc "$HOME\dotfiles\vimrc"
    cmd /c mklink _gvimrc "$HOME\dotfiles\gvimrc"
    cmd /c mklink .vimrc.bundles "$HOME\dotfiles\vimrc.bundles"
    cmd /c mklink /D .vim "$HOME\dotfiles\vim"
    mkdir $HOME\vimfiles\undo
    mkdir $HOME\vimfiles\autoload
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile "$HOME\vimfiles\autoload\plug.vim"
    gvim -u "$HOME\.vimrc.bundles" +PlugInstall +PlugClean! +qa

zsh Configurations
------------------

Additional zsh configuration can go under the `~/.zsh/configs` directory. This
has two special subdirectories: `pre` for files that must be loaded first, and
`post` for files that must be loaded last.

For example, `~/.zsh/configs/pre/virtualenv` makes use of various shell
features which may be affected by my settings, so load it first:

    # Load the virtualenv wrapper
    . /usr/local/bin/virtualenvwrapper.sh

Setting a key binding can happen in `~/.zsh/configs/keys`:

    # Grep anywhere with ^G
    bindkey -s '^G' ' | grep '

Some changes, like `chpwd`, must happen in `~/.zsh/configs/post/chpwd`:

    # Show the entries in a directory whenever you cd in
    function chpwd {
      ls
    }

This directory is handy for combining dotfiles from multiple teams; one team
can add the `virtualenv` file, another `keys`, and a third `chpwd`.

The `~/.zshrc.local` is loaded after `~/.zsh/configs`.

vim Configurations
------------------

Similarly to the zsh configuration directory as described above, vim
automatically loads all files in the `~/.vim/plugin` directory. This does not
have the same `pre` or `post` subdirectory support that our `zshrc` has.

This is an example `~/.vim/plugin/c.vim`. It is loaded every time vim starts,
regardless of the file name:

    # Indent C programs according to BSD style(9)
    set cinoptions=:0,t0,+4,(4
    autocmd BufNewFile,BufRead *.[ch] setlocal sw=0 ts=8 noet

