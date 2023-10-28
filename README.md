# Large scale data management Benchmark

Au sein du module Gestion de données distribuées à large échelle enseigné par Pascal Molli, nous devions réaliser un projet comparant les performances de l'algorithme pagerank entre une implémentations en pig et une en PySpark dans un contexte de données massives sur l'environnement google cloud plateform.
## Run Locally

```bash
bash /benchmark/benchmark.sh
```
## Authors

- [@Gabriel Pouplin](https://github.com/Lapin-Obez)
- [@Tristan Ramé](https://github.com/TRRame)
- [@Marius Guitton-Frantz](https://github.com/Guitton-Frantz)

## Configuration

Pour réaliser cette expérience, nous avons utilisé la configuration suivante pour pig et pour sparks :
* Le nombre d'itérations pour le page rank était 3
* Les facteurs page rank étaient 0.85 et 0.15
* Les nombres de noeuds utilisés étaient 2, 3, 4 et 5
* Le cluster était situé dans la région Europe-west 2
* Le bucket  était situé dans la région Europe-west 2
* Le fichier de données était enregistré dans le bucket

Liste des fichiers utilisés : 
* Le fichier d'exécution peut être trouvé ici : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/becnhmark/benchmark.sh

* Le fichier pig ici : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/dataproc.py

* Le fichier spark ici : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/pyspark/pagerank.py

## Results

### Pig

| Nombre de workers | Temps d'éxécution en minutes |
|---|---|
| 2 | 51,60811667 |
| 3 | 42,75751667 |
| 4 | 37,71896667 |
| 5 | 31,58546667 |

### Spark

| Nombre de workers | Temps d'éxécution en minutes |
|---|---|
| 2 | 48,53347917451666 |
| 3 | 39,96790781611666 |
| 4 | 40,70230198851667 |
| 5 | 39,5698322265 |

##Comparaison graphique des différentes implémentations :
Le graphique ci-dessous met en lumière les différences de temps entre les différentes implémentations du pagerank en fonction du nombre de worker.

## Result PageRank
Nous avons obtenu que l'entité avec le meilleur pagerank c'est l'uri http://dbpedia.org/resource/Living_people, avec un pagerank de 36794.33146754482.

| URL de la page | Score du PageRank |
|---|---|
| http://dbpedia.org/resource/Living_people |  36794.33146754482  |
|   |   |
|   |   |


## Conclusion
Ce projet nous a permis de mettre en oeuvre les différentes implémentations de pagerank étudiées au sein de ce module dans l'objectif de les comparer. Nous résumons les principales conclusions obtenues dans cette expérience ci-dessous.
