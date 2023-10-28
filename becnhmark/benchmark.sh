#!/bin/bash
##------------------ SET UP ------------------
data="gs://my_own_bucket_lsdm"
my_bucket="gs://my_own_bucket_lsdm"
project_id="my_lsdm_id_project"
region=europe-west2
zone=europe-west2-c

## copy pig code
gsutil cp ../dataproc.py $my_bucket/

## copy spark code
gsutil cp ../pyspark/pagerank.py $my_bucket/

## Define list of workers
workers=(2 3 4 5)

## Loop over workers
for num_workers in "${workers[@]}"; do
    ## Clean out directory
    gsutil rm -rf $my_bucket/out
    gsutil rm -rf $my_bucket/out/spark

    ## create the cluster
    gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region ${region} --zone ${zone} --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers $num_workers --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project $project_id

    ##------------------ PIG ------------------

    ## run
    ## (suppose that out directory is empty !!)
    pig_start_time=$(date +%s%N)
    gcloud dataproc jobs submit pig --region ${region} --cluster cluster-a35a -f $my_bucket/dataproc.py
    pig_end_time=$(date +%s%N)

    ##------------------ SPARK ------------------

    ## run
    ## (suppose that out directory is empty !!)
    spark_start_time=$(date +%s%N)
    gcloud dataproc jobs submit pyspark --region ${region} --cluster cluster-a35a $my_bucket/pagerank.py -- $data/page_links_en.nt.bz2 3
    spark_end_time=$(date +%s%N)

    ## delete cluster...
    gcloud dataproc clusters delete cluster-a35a --region ${region} --quiet

    python ./../score_finder_spark.py >> res_spark.txt
    python ./../bestpig.py >> res_pig.txt
    pig_computing_time=$((pig_end_time - pig_start_time))
    spark_computing_time=$((spark_end_time - spark_start_time))

    let "pig_computing_time=$pig_computing_time/1000000"
    let "spark_computing_time=$spark_computing_time/1000000"

    ## access results
    gsutil cat $my_bucket/out/pig/pagerank_data_10/part-r-00000 >pig_results_$num_workers.txt
    ## access results
    gsutil cat $my_bucket/out/spark/pagerank_data_10/part-r-00000 >spark_results_$num_workers.txt

    ## write computing time to file
    echo "$num_workers workers: $pig_computing_time ms" >>computing_times_pig.txt
    ## write computing time to file
    echo "$num_workers workers: $spark_computing_time ms" >>computing_times_spark.txt
done
