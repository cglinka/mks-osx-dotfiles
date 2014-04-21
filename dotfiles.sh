#!/bin/sh
{
  echo "This script will download and link your dotfiles for you."

  if [ ! -d ~/.mks-dotfiles ]; then
    mkdir ~/.mks-dotfiles
    git clone https://github.com/makersquare/osx-dotfiles.git ~/.mks-dotfiles

    echo "cleaning up old dotfiles"
    if [ -f ~/.gitignore ] || [ -h ~/.gitignore ]; then
      rm -f ~/.gitignore
    fi

    if [ -f ~/.gitconfig ] || [ -h ~/.gitconfig ]; then
      rm -rf ~/.gitconfig
    fi

    if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
      echo "existing .zshrc detected, renaming .old-zshrc"
      mv ~/.zshrc ~/.old-zshrc
    fi

    if [ -d ~/.homesick ]; then
      rm -rf ~/.homesick
    fi

    echo "symlinking dotfiles to your home directory"
    for f in ~/.dotfiles/home/.[^.]*
    do
      ln -s "$f" "$HOME/${f##*/}"
    done

    echo "DEFAULT_USER=`whoami`" >> .zshrc

  else
    echo "updating Dotfiles"
    cd ~/.mks-dotfiles
    git stash
    git pull origin master
    cd ~
  fi

  if [ ! -d ~/bin ]; then
    echo "Creating ~/bin"
    mkdir ~/bin
  fi

  if [ ! -f ~/bin/subl ]; then
    if [ -f /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl ]; then
      echo "Creating subl link to Sublime Text 2"
      ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl ~/bin/subl
      rm -f ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/Preferences.sublime-settings
      ln -s ~/.dotfiles/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/Preferences.sublime-settings
      if [ ! -d ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/flatland-mks ]; then
        git clone https://github.com/makersquare/flatland-mks.git ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/flatland-mks
      fi
    elif [ -f /Applications/Sublime\ Text\ 3.app/Contents/SharedSupport/bin/subl ]; then
      echo "Creating subl link to Sublime Text 3"
      ln -s /Applications/Sublime\ Text\ 3.app/Contents/SharedSupport/bin/subl ~/bin/subl
      rm -f ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
      ln -s ~/.dotfiles/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
      if [ ! -d ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/flatland-mks ]; then
        git clone https://github.com/makersquare/flatland-mks.git ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/flatland-mks
      fi
    elif [ -f /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ]; then
      echo "Creating subl link to Sublime Text"
      ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ~/bin/subl
      rm -f ~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings
      ln -s ~/.dotfiles/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings
      if [ ! -d ~/Library/Application\ Support/Sublime\ Text/Packages/flatland-mks ]; then
        git clone https://github.com/makersquare/flatland-mks.git ~/Library/Application\ Support/Sublime\ Text/Packages/flatland-mks
      fi
    else
      echo "Install Sublime Text first"
    fi
  fi

  if [ -d ~/code/mks ]; then
    mv ~/code/mks ~/code/mks_backup
  fi

  mkdir -p ~/code/mks/frontend
  mkdir ~/code/mks/backend
  mkdir ~/code/mks/misc

  cp ~/.dotfiles/Vagrantfile ~/code/mks/Vagrantfile
}
