#!/bin/bash

##------------------ SET UP ------------------

## copy pig code
gsutil cp dataproc.py gs://my_own_bucket_lsdm/

## copy spark code
gsutil cp ./pyspark/pagerank-notype.py gs://my_own_bucket_lsdm/

data="gs:///public_lddm_data/"
my_bucket="gs://my_own_bucket_lsdm"
project_id="true-server-401112"

## Define list of workers
workers=(2 4 6)

## Loop over workers
for num_workers in "${workers[@]}"; do
    ##------------------ SPARK ------------------
    ## Clean out directory
    gsutil rm -rf $my_bucket/out/pig
    gsutil rm -rf $my_bucket/out/spark

    ## create the cluster
    gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers $num_workers --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project $project_id

    ## run
    ## (suppose that out directory is empty !!)
    pig_start_time=$(date +%s)
    gcloud dataproc jobs submit pig --region europe-west1 --cluster cluster-a35a -f $my_bucket/dataproc.py
    pig_end_time=$(date +%s)

    ##------------------ SPARK ------------------

    ## run
    ## (suppose that out directory is empty !!)
    spark_start_time=$(date +%s)
    gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a $my_bucket/pagerank-notype.py -- data/small_page_links.nt 3
    spark_end_time=$(date +%s)

    ## delete cluster...
    gcloud dataproc clusters delete cluster-a35a --region europe-west1 -Y

    pig_computing_time=$((pig_end_time - pig_start_time))
    spark_computing_time=$((spark_end_time - spark_start_time))

    ## access results
    gsutil cat $my_bucket/out/pig/pagerank_data_10/part-r-00000 >pig_results_$num_workers.txt
    ## access results
    gsutil cat $my_bucket/out/spark/pagerank_data_10/part-r-00000 >spark_results_$num_workers.txt

    ## write computing time to file
    echo "$num_workers workers: $pig_computing_time seconds" >>computing_times_pig.txt
    ## write computing time to file
    echo "$num_workers workers: $spark_computing_time seconds" >>computing_times_spark.txt
done