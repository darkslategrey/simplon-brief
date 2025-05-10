# frozen_string_literal: true

require 'minitest/autorun'
require 'sqlite3'
require 'dotenv/load'

require 'webmock/minitest'
require_relative '../importer'

class ImporterTest < Minitest::Test
  def setup
    @db = SQLite3::Database.new(ENV.fetch('DATABASE_URL', 'db/test.sqlite3'))
    @db.results_as_hash = true
    @importer = Importer.new
  end

  def teardown
    @db.execute('delete from Ventes')
  end

  def test_import_magasins
    @importer.import_magasins(File.read('data/magasins.csv'))
    assert_equal 7, @db.get_first_value('select count(1) from Magasins')
  end

  def test_import_ventes
    @importer.import_ventes(File.read('data/ventes.csv'))
    assert_equal 30, @db.get_first_value('select count(1) from Ventes')
  end

  def test_import_produits
    @importer.import_produits(File.read('data/produits.csv'))
    assert_equal 5, @db.get_first_value('select count(1) from Produits')
  end

  def test_prevent_duplicate_vente
    @db.execute('INSERT INTO Ventes (date, id_reference_produit, quantite, id_magasin) VALUES (?, ?, ?, ?)',
                ['2023-06-01', 'REF009', 5, 10])
    assert_raises(SQLite3::ConstraintException) do
      @db.execute(
        'INSERT INTO Ventes (date, id_reference_produit, quantite, id_magasin) VALUES (?, ?, ?, ?)', ['2023-06-01',
                                                                                                      'REF009', 5, 10]
      )
    end
  end
end
