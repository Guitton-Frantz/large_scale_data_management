# Large scale data management Benchmark

Au sein du module Gestion de données distribuées à large échelle enseigné par Pascal Molli, nous devions réaliser un projet comparant les performances de l'algorithme [PageRank](https://wikipedia.org/wiki/PageRank) entre une implémentations en [Pig](https://pig.apache.org/) et une en [PySpark](https://spark.apache.org/docs/latest/api/python/index.html) dans un contexte de données massives sur l'environnement [Google Cloud Platform](https://cloud.google.com).

## Run Locally

```bash
bash /benchmark/benchmark.sh
```
## Authors

- [@Gabriel Pouplin](https://github.com/Lapin-Obez)
- [@Tristan Ramé](https://github.com/TRRame)
- [@Marius Guitton-Frantz](https://github.com/Guitton-Frantz)

## Index

* [1-Configuration](#configuration) 
* [2-Resultats](#resultats) 
* [3-Comparaison graphique des différentes implémentations](#comparaison-graphique-des-différentes-implementations)
* [4-Résultat PageRank](#resultats-pagerank)
* [5-Discussion des résultats](#discussion-des-resultats)
* [6-Conclusion](#conclusion)


<a name="configuration"/>

## Configuration

Pour réaliser cette expérience, nous avons utilisé la configuration suivante pour pig et pour sparks :
* **Nombre d'itérations pour le PageRank :** _3_
* **Facteurs PageRank :** _0.85 et 0.15_
* **Nombres de noeuds utilisés :** _2, 3, 4 et 5_
* **Localisation du cluster :** _région Europe-west 2_
* **Localisation du bucket :** _région Europe-west 2_
* **Le fichier de données était enregistré dans le bucket**

Liste des fichiers utilisés : 
* Le fichier d'exécution peut être trouvé : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/becnhmark/benchmark.sh

* Le fichier Pig : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/dataproc.py

* Le fichier PySpark : https://github.com/Guitton-Frantz/large_scale_data_management/blob/main/pyspark/pagerank.py

* Code source d'origine utilisé : https://github.com/momo54/large_scale_data_management

### Modifications apportées
#### **Fichier Pig**
* 

#### **Fichier PySpark**
* Partionnement des données pour obtenir une meilleur localité des données


<a name="resultats"/>

## Resultats

### Pig

| Nombre de workers | Temps d'éxécution en minutes |
|---|---|
| 2 | 51,60811667 |
| 3 | 42,75751667 |
| 4 | 37,71896667 |
| 5 | 31,58546667 |

### Spark avec Partition

| Nombre de workers | Temps d'éxécution en minutes |
|---|---|
| 2 | 47,32798333 |
| 3 | 31,35621667 |
| 4 | 33,54715 |
| 5 | 34,67181667 |

<a name="comparaison-graphique-des-différentes-implementations"/>

## Comparaison graphique des différentes implémentations :
Le graphique ci-dessous met en lumière les différences de temps entre les différentes implémentations du pagerank en fonction du nombre de worker.

<a name="resultats-pagerank"/>

## Resultats PageRank
Nous avons obtenu que l'entité avec le meilleur pagerank c'est l'uri http://dbpedia.org/resource/Living_people, avec un pagerank de 36794.33146754482.

| URL de la page | Score du PageRank |
|---|---|
| http://dbpedia.org/resource/Living_people |  36794.33146754482  |


<a name="discussion-des-resultats"/>

## Discussion des résultats


<a name="conclusion"/>

## Conclusion
Ce projet nous a permis de mettre en oeuvre les différentes implémentations de pagerank étudiées au sein de ce module dans l'objectif de les comparer. Nous résumons les principales conclusions obtenues dans cette expérience ci-dessous.
