#!/usr/bin/env sh

rake db:setup_prod
ruby importer.rb
# ruby importer.rb --serve
# rackup importer.ru
