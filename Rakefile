#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'byebug'

require File.expand_path('../config/application', __FILE__)

Katuma::Application.load_tasks

# Pathname('engines').children.each do |engine_name|
  # %x(pushd #{engine_name.to_s} && bundle exec rake && popd)
# end
