async function fetchJSON(url) {
  const res = await fetch(url);
  return res.json();
}

async function main() {
  // Chiffre d'affaires total
  const ca = await fetchJSON('/chiffre-affaires');
  document.getElementById('ca-total').innerText = `Chiffre d'affaires total : ${ca.chiffre_affaires_total.toFixed(2)} €`;

  // Ventes par produit
  const produits = await fetchJSON('/ventes-par-produit');
  new Chart(document.getElementById('produitChart'), {
    type: 'bar',
    data: {
      labels: produits.map(p => p.produit),
      datasets: [{
        label: 'Total des ventes',
        data: produits.map(p => p.total_vendu),
        backgroundColor: '#4e79a7'
      }]
    }
  });

  // CA par ville
  const villes = await fetchJSON('/ventes-par-ville');
  new Chart(document.getElementById('villeChart'), {
    type: 'pie',
    data: {
      labels: villes.map(v => v.ville),
      datasets: [{
        label: 'CA',
        data: villes.map(v => v.chiffre_affaires),
        backgroundColor: ['#f28e2b', '#e15759', '#76b7b2', '#59a14f', '#edc948', '#b07aa1', '#ff9da7']
      }]
    }
  });
}

main();
