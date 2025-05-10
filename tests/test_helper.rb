# frozen_string_literal: true

require 'minitest/autorun'
require 'dotenv'
require 'sqlite3'
require 'fileutils'


stub_request(:get, ENV.fetch('VENTES_CSV_URL'))
  .with(body: File.read('data/ventes.csv'))


stub_request(:get, ENV.fetch('PRODUITS_CSV_URL'))
  .with(body: File.read('data/produits.csv'))

# #
# Désactiver le parallélisme de Minitest
# Minitest.parallel_executor = Class.new do
#   def start(*) = self
#   def shutdown(*) = nil
#   def synchronize = yield
# end

# # Charger l'environnement de test
# Dotenv.load('.env.test')

# # Assure que la base de test existe
# TEST_DB_PATH = ENV['DATABASE_URL'] || 'db/test.sqlite3'
# unless File.exist?(TEST_DB_PATH)
#   abort("La base de test n'existe pas : #{TEST_DB_PATH}. Lance `rake db:setup_test` d'abord.")
# end

# puts "Environnement de test initialisé avec DB : #{TEST_DB_PATH}"
