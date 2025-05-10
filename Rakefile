# frozen_string_literal: true

require 'bundler/setup'
require 'rake'
require 'sqlite3'
require 'fileutils'
require 'dotenv'

DB_DIR = '/data'
PROD_DB = "#{DB_DIR}/prod.sqlite3"
TEST_DB = "#{DB_DIR}/test.sqlite3"
SCHEMA_FILE = "#{DB_DIR}/schema.sql"
SEED_FILE = "#{DB_DIR}/seed_test.sql"

namespace :db do
  desc 'Initialiser la base de production'
  task :setup_prod do
    FileUtils.mkdir_p(DB_DIR)
    FileUtils.rm_f(PROD_DB)
    db = SQLite3::Database.new(PROD_DB)
    db.execute_batch(File.read(SCHEMA_FILE))
    puts "Base de production initialisée à #{PROD_DB}"
  end

  desc 'Initialiser la base de test avec données fictives'
  task :setup_test do
    FileUtils.mkdir_p(DB_DIR)
    FileUtils.rm_f(TEST_DB)
    db = SQLite3::Database.new(TEST_DB)
    db.execute_batch(File.read(SCHEMA_FILE))
    puts "Base de test initialisée à #{TEST_DB}"
  end
end

desc 'Exécuter tous les tests avec la base de test'
task test: 'db:setup_test' do
  puts "Chargement des variables d'environnement de test"
  Dotenv.load('.env.test')

  puts 'Lancement des tests Minitest'
  ruby 'tests/test_api.rb'
  ruby 'tests/test_importer.rb'
end
