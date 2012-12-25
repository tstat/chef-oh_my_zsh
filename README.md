## Chef LWRP for installing zsh/oh-my-zsh

====================

This is a nice clean LWRP for installing zsh and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) 
through [chef.](http://opscode.com/chef) 


Setup
-----
Just add oh_my_zsh as one of your dependencies in your metadata.rb.

Usage
-----
Simply pass a username to this LWRP and zsh/oh-my-zsh will be installed, the .zshrc template will be 
sym-linked if one doesn't already exist, and zsh will be set as the default shell for that user.

```ruby
oh_my_zsh 'username'
```

Yay! Less typing in the future!!!
