#!/usr/bin/python
from org.apache.pig.scripting import *

INIT = Pig.compile("""
A = LOAD 'gs://public_lddm_data/small_page_links.nt' using PigStorage(' ') as (url:chararray, p:chararray, link:chararray);
B = GROUP A by url;                                                                                  
C = foreach B generate group as url, 1 as pagerank, A.link as links;                                 
STORE C into '$docs_in';
""")

UPDATE = Pig.compile("""
-- PR(A) = (1-d) + d (PR(T1)/C(T1) + ... + PR(Tn)/C(Tn))

previous_pagerank = 
    LOAD '$docs_in' 
    USING PigStorage('\t') 
    AS ( url: chararray, pagerank: float, links:{ link: ( url: chararray ) } );

outbound_pagerank =  
    FOREACH previous_pagerank 
    GENERATE 
        pagerank / COUNT ( links ) AS pagerank, 
        FLATTEN ( links ) AS to_url;

new_pagerank = 
    FOREACH 
        ( COGROUP outbound_pagerank BY to_url, previous_pagerank BY url INNER )
    GENERATE 
        group AS url, 
        ( 1 - $d ) + $d * SUM ( outbound_pagerank.pagerank ) AS pagerank, 
        FLATTEN ( previous_pagerank.links ) AS links;
        
STORE new_pagerank 
    INTO '$docs_out' 
    USING PigStorage('\t');
""")

params = { 'd': '0.85', 'docs_in': 'gs://small_page_links/out/pagerank_data_simple' }

stats = INIT.bind(params).runSingle()
if not stats.isSuccessful():
      raise 'failed initialization'

for i in range(3):
   out = "gs://my_own_bucket_lsdm/out/pig/pagerank_data_" + str(i + 1)
   params["docs_out"] = out
   Pig.fs("rmr " + out)
   stats = UPDATE.bind(params).runSingle()
   if not stats.isSuccessful():
      raise 'failed'
   params["docs_in"] = out
import csv

def top_pages_by_pagerank(file_path, top_n=10):
    with open(file_path, 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Ignorer l'en-tête s'il y en a un

        # Utiliser une liste pour stocker les 10 premières pages
        top_pages = []

        for row in reader:
            page = row[0]
            pagerank = float(row[1])

            # Insérer la page dans la liste triée par ordre décroissant de PageRank
            top_pages.append((page, pagerank))
            top_pages = sorted(top_pages, key=lambda x: x[1], reverse=True)[:top_n]

    return top_pages

# Exemple d'utilisation
file_path = 'resultats_pagerank.csv'
