# frozen_string_literal: true

require 'sinatra/base'
require 'sqlite3'
require 'json'

require 'dotenv/load'
puts ENV.fetch('DATABASE_URL')
DB_PATH = ENV.fetch('DATABASE_URL', 'db/prod.sqlite3')

DB = SQLite3::Database.new(DB_PATH)
DB.results_as_hash = true

class API < Sinatra::Base
  # Serveur statique pour JS/CSS
  set :public_folder, "#{File.dirname(__FILE__)}/public"

  # HTML dashboard
  get '/' do
    erb :dashboard
  end

  # Total CA = SUM(quantité × prix)
  get '/chiffre-affaires' do
    result = DB.get_first_value <<-SQL
    SELECT * FROM Vue_ChiffreAffairesTotal;
    SQL
    { chiffre_affaires_total: result.to_f.round(2) }.to_json
  end

  # Ventes par produit
  get '/ventes-par-produit' do
    data = DB.execute <<-SQL
    SELECT * FROM Vue_VentesParProduit
    SQL
    data.map do |row|
      {
        produit: row['nom_produit'],
        total_vendu: row['total_ca'].round(2)
      }
    end.to_json
  end

  # Ventes par région (ville)
  get '/ventes-par-ville' do
    data = DB.execute <<-SQL
    SELECT * FROM Vue_VentesParVille;
    SQL

    data.map do |row|
      {
        ville: row['ville'],
        chiffre_affaires: row['total_ca'].round(2)
      }
    end.to_json
  end
end
