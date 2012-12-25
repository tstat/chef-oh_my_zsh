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
  
  node['oh_my_zsh']['packages'].each do |pkg|
    package pkg
  end

  home_dir = Pathname.new(Etc.getpwnam(new_resource.user).dir).expand_path
  
  git "#{home_dir}/.oh-my-zsh" do
    repository "git://github.com/robbyrussell/oh-my-zsh.git"
    reference "master"
    destination "#{home_dir}/.oh-my-zsh"
    action :sync
    user "#{new_resource.user}"
  end

  # link .zshrc template unless a .zshrc already exists
  link "#{home_dir}/.zshrc" do
    to "#{home_dir}/.oh-my-zsh/templates/zshrc.zsh-template"
    not_if "test -R #{home_dir}/.zshrc"
  end

  # set default shell as zsh
  execute "zsh-default" do
    command "su -l -c 'chsh -s /bin/zsh #{new_resource.user}'"
    cwd '/root'
    user "root"
    not_if {Etc.getpwnam(new_resource.user).shell.include?("zsh")}
  end

end