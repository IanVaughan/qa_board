require './server'
# require "rubygems"
# require "bundler/setup"

# root_dir = File.dirname(__FILE__)

# set :environment, ENV["RACK_ENV"].to_sym
# set :root,        root_dir
# set :app_file,    File.join(root_dir, "app.rb")
# disable :run

# log = File.new("log/sinatra.log", "a+")
# $stdout.reopen(log)
# $stderr.reopen(log)

run Server
# $:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'config')
