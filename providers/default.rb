#
# Cookbook Name:: oh_my_zsh
# Provider:: default
#
# Copyright 2012, Travis Staton
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'pathname'

action :create do
  user = new_resource.user
  home_dir = Pathname.new(Etc.getpwnam(user).dir).expand_path
  
  install_packages
  clone_oh_my_zsh(home_dir, user)
  sym_link_zshrc(home_dir)
  set_zsh_default(user)
end

def install_packages
  node['oh_my_zsh']['packages'].each do |pkg|
    package pkg
  end
end

def clone_oh_my_zsh(dir, user)
    git "#{dir}/.oh-my-zsh" do
    repository "git://github.com/robbyrussell/oh-my-zsh.git"
    reference "master"
    destination "#{dir}/.oh-my-zsh"
    action :sync
    user "#{user}"
  end
end

def sym_link_zshrc(dir)
  link "#{dir}/.zshrc" do
    to "#{dir}/.oh-my-zsh/templates/zshrc.zsh-template"
    not_if "test -R #{dir}/.zshrc"
  end
end

def set_zsh_default(user)
  execute "set_zsh_as_default_for_#{user}" do
    command "su -l -c 'chsh -s /bin/zsh #{user}'"
    cwd '/root'
    user "root"
    not_if {Etc.getpwnam(user).shell.include?("zsh")}
  end
end

