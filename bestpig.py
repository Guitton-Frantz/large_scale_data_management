from google.cloud import storage
import os
import re
def top_pages_by_pagerank(top_n=10):
    my_bucket = "gabibou_bucket"

    storage_client = storage.Client()
    bucket = storage_client.bucket(my_bucket)
    for blob in bucket.list_blobs():
        #find the blob that starts with out/spark/ and doesn't end with /
        if blob.name.startswith('out/pig/pagerank_data_3') and not blob.name.endswith('/'):
            print(blob.name)
            file_path = blob
                
    with file_path.open(mode="r") as f:
        #foreach line in file
        # find the best score
        # return the best score and the url
        my_file = f.read()
        best_score = 0
        best_url = ''
        Lines = my_file.splitlines()
        pattern = r"<([^>]+)>\s+(\d+.\d+)"
        for line in Lines:
            matches = re.findall(pattern, line)
            for match in matches:
                score = float(match[1])
                if score > best_score:
                    best_score = score
                    best_url = match[0]       
        return best_score, best_url
print(top_pages_by_pagerank())
