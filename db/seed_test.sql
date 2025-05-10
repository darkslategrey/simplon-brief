INSERT INTO Magasins (id_magasin, ville, nombre_salaries) VALUES
(1, 'Paris', 10),
(2, 'Lyon', 8);

INSERT INTO Produits (id_reference_produit, nom, prix, stock) VALUES
('REF001', 'Produit A', 49.99, 100),
('REF002', 'Produit B', 19.99, 50);

INSERT INTO Ventes (date, id_reference_produit, quantite, id_magasin) VALUES
('2023-01-01', 'REF001', 3, 1),
('2023-01-02', 'REF002', 5, 2);
