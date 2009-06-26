# This file contains your application, it requires dependencies and necessary
# parts of the application.
#
# It will be required from either `config.ru` or `start.rb`

require 'rubygems'
require 'ramaze'
require 'sequel'
require 'configuration'
require 'rdiscount'
require 'maruku'
require 'memcache'

#$CACHE = MemCache.new 'localhost:11211', :namespace => 'blog'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]




Sequel.extension :pagination
#Sequel::Model.plugin :caching

require __DIR__('config')

db = Sequel.connect("mysql://#{CONFIG.database.user}:#{CONFIG.database.password}@#{CONFIG.database.server}/#{CONFIG.database.name}")

# Initialize controllers and models
require __DIR__('model/init')
require __DIR__('controller/init')

