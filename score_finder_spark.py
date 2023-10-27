# Find the best score in a liste of pagerank scores

import os
import re
from google.cloud import storage

def main():
    my_bucket = "my_own_bucket_lsdm"

    storage_client = storage.Client()
    bucket = storage_client.bucket(my_bucket)

    for blob in bucket.list_blobs():
        #find the blob that starts with out/spark/ and doesn't end with /
        if blob.name.startswith('out/spark/') and not blob.name.endswith('/'):
            print(blob.name)
            best_score, best_url = get_best_score(blob)
            print(best_score, best_url)


def get_best_score(file):
    with file.open(mode="r") as f:
        #foreach line in file
        # find the best score
        # return the best score and the url
        my_file = f.read()
        best_score = 0
        best_url = ''
        Lines = my_file.splitlines()
        for line in Lines:
            m = re.search(r'\((.*)\, (.*)\)', line)
            if m:
                score = float(m.group(2))
                if score > best_score:
                    best_score = score
                    best_url = m.group(1)    
        return best_score, best_url

if __name__ == "__main__":
    main()