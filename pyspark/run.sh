#!/bin/bash

## En local ->
## pig -x local -

## en dataproc...

## copy data
##gsutil cp small_page_links.nt gs://myown_bucket/

## copy pig code
gsutil cp pagerank.py gs://tristan_kfc_bucket/

## Clean out directory
gsutil rm -rf gs://tristan_kfc_bucket/out


## create the cluster
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west2 --zone europe-west2-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project trim-silicon-401112


## run
## (suppose that out directory is empty !!)
gcloud dataproc jobs submit pyspark --region europe-west2 --cluster cluster-a35a gs://tristan_kfc_bucket/pagerank.py  -- gs://public_lddm_data/small_page_links.nt 3

## access results
gsutil cat gs://tristan_kfc_bucket/out/pagerank_data_10/part-r-00000

## delete cluster...
gcloud dataproc clusters delete cluster-a35a --region europe-west2

