# frozen_string_literal: true

require 'csv'
require 'open-uri'
require 'sqlite3'
require 'logger'
require 'dotenv/load'

DB_PATH = ENV.fetch('DATABASE_URL', 'db/prod.sqlite3')

# URLs des fichiers CSV
VENTES_CSV_URL = ENV.fetch('VENTES_CSV_URL')
MAGASINS_CSV_URL = ENV.fetch('MAGASINS_CSV_URL')
PRODUITS_CSV_URL = ENV.fetch('PRODUITS_CSV_URL')

class Importer
  def initialize
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    @logger = Logger.new($stdout)
  end

  def import_data
    puts "Import des magasins... Depuis #{MAGASINS_CSV_URL}"
    import_magasins(import_csv(MAGASINS_CSV_URL))

    puts "Import des produits... Depuis #{PRODUITS_CSV_URL}"
    import_produits(import_csv(PRODUITS_CSV_URL))

    puts "Import des ventes... Depuis #{VENTES_CSV_URL}"
    import_ventes(import_csv(VENTES_CSV_URL))

    puts 'Import terminé.'
  end

  def import_magasins(csv_text)
    CSV.parse(csv_text, headers: true).each do |row|
      @db.execute(
        'INSERT INTO Magasins VALUES (?, ?, ?)', [row[0], row[1], row[2]]
      )
    rescue SQLite3::ConstraintException => e
      @logger.error "Import Magasins : Conflit d'import : #{e.message}"
    end
  end

  def import_produits(csv_text)
    CSV.parse(csv_text, headers: true).each do |row|
      @db.execute(
        'INSERT INTO Produits VALUES (?, ?, ?, ?)', [row[1], row[0], row[2], row[3]]
      )
    rescue SQLite3::ConstraintException => e
      @logger.error "Import Produits : Conflit d'import : #{e.message}"
    end
  end

  def import_ventes(csv_text)
    CSV.parse(csv_text, headers: true).each do |row|
      @db.execute(
        'INSERT INTO Ventes VALUES (?, ?, ?, ?)', [row[0], row[1], row[2], row[3]]
      )
    rescue SQLite3::ConstraintException => e
      @logger.error "Import Ventes : Conflit d'import : #{e.message}"
    end
  end

  private

  def import_csv(url)
    URI.open(url).read
  end
end

Importer.new.import_data unless ENV.fetch('APP_ENV', 'production') == 'test'
