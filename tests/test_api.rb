# frozen_string_literal: true

require 'minitest/autorun'
require 'rack/test'
require_relative '../api'

class APITest < Minitest::Test
  include Rack::Test::Methods

  def self.setup_once
    @db = SQLite3::Database.new(ENV.fetch('DATABASE_URL', 'db/test.sqlite3'))
    @db.execute_batch(File.read(ENV.fetch('SEED_FILE', 'db/seed_test.sql')))
    @db.results_as_hash = true
  end

  @@once ||= begin
    self.setup_once
    true
  end

  Minitest.after_run do
    @db.execute('delete from Magasins;')
    @db.execute('delete from Ventes;')
    @db.execute('delete from Produits;')
  end

  def app
    API
  end

  def test_chiffre_affaires
    get '/chiffre-affaires'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    assert_kind_of Numeric, data['chiffre_affaires_total']
    assert_equal 249.92, data['chiffre_affaires_total']
  end

  def test_ventes_par_produit
    get '/ventes-par-produit'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    assert_kind_of Array, data
    refute_empty data
    assert(data.all? { |p| p['produit'] && p['total_vendu'] })
  end

  def test_ventes_par_ville
    get '/ventes-par-ville'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    assert_kind_of Array, data
    refute_empty data
    assert(data.all? { |v| v['ville'] && v['chiffre_affaires'] })
  end
end
