# Brief projet

J'ai choisis `ruby` comme langage et `sinatra` pour présenter un mini dashboard web accessible à l'adresse <http://127.0.0.1:4567>.

## Schéma de données

![schéma de la base](/images/schema.svg)

## Schema des services du `docker-compose`

![schéma des services docker](/images/architecture-services.svg)

## Usage

### Build des images

``` sh
docker compose build
```

### Lancer les tests

Tester l'importer et le mini dashboard.

``` sh
docker run -it --rm -v ./db:/data simplon-importer bundle exec rake test
```

### Création de la base de production vide

Crée une base de production vide dans `db/prod.sqlite3`

``` sh
rake db:init
```

### Ouvrir une console dans la base

``` sh
rake db:console
```

### Lancer les services

``` sh
docker compose up
```

Trois services sont lancés : 

1. Un container `sqlite3` pour accéder à la base
2. Un container `importer` pour importer les données distantes
3. Un container `front` pour présenter un mini dashboard avec le CA total, les ventes par produits et le CA par ville.
<http://127.0.0.1:4567>

## Le mini dashboard

![mini dashboard](/images/front.png)

## Liste des fichiers

``` sh
.
├── ./api.rb # pour le front, application sinatra
├── ./config.ru # lance le front
# Les données pour les tests avec minitest
├── ./data
│   ├── ./data/magasins.csv
│   ├── ./data/produits.csv
│   └── ./data/ventes.csv
├── ./db
│   ├── ./db/Dockerfile    # sqlite3 Dockerfile
│   ├── ./db/prod.sqlite3  # base de prod
│   ├── ./db/schema.sql    # le schema de la bdd
│   ├── ./db/seed_test.sql # donnees pour les tests 
│   └── ./db/test.sqlite3  # base de test

├── ./docker-compose.yml   # Lance tous les services
├── ./Dockerfile           # Pour l'image de l'importer
├── ./.dockerignore
├── ./docs # ennonce du projet
│   └── ./docs/[Positionnement] Brief projet Analyser les ventes d’une PME - Data Engineer.pdf
├── ./.env # env de prod
├── ./.env.test # env de test
├── ./Gemfile
├── ./Gemfile.lock
├── ./.github # TODO 
│   └── ./.github/workflow
│       └── ./.github/workflow/ci-cd.yml
├── ./go.sh # point d'entrée pour le container importer
├── ./images # asset du readme
│   ├── ./images/architecture-des-services-docker.mermaid
│   ├── ./images/architecture-services.svg
│   ├── ./images/schéma-de-la-base-de-données.mermaid
│   └── ./images/schema.svg
├── ./importer.rb # Importe les données distantes
├── ./public # Le js pour les graphiques du front
│   └── ./public/charts.js
├── ./Rakefile # taches pour lancer les tests et initialiser les bases de tests et de prod
├── ./.rbenv-gemsets
├── ./README.md
├── ./.ruby-version
├── ./tests # les tests
│   ├── ./tests/test_api.rb
│   ├── ./tests/test_helper.rb
│   └── ./tests/test_importer.rb
└── ./views # La vue principale du front
    └── ./views/dashboard.erb
```

