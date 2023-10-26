# Find the best score in a liste of pagerank scores

import os
import re


def main():
    my_bucket = "gs://my_own_bucket_lsdm/out/spark/"
    #foreach file in each folder in my_bucket
    #get the best score
    for folder in os.listdir(my_bucket):
        print(folder)
        for file in os.listdir(my_bucket + folder):
            print(file)
            if file.startswith('out'):
                print(file)
                file = open(my_bucket + folder + '/' + file, 'r')
                best_score, best_url = get_best_score(file)
                print(best_score, best_url)
                file.close()

def get_best_score(file):
    best_score = 0
    best_url = ''
    Lines = file.readlines()
    for line in Lines:
        print(line.rstrip())

        m = re.search(r'\((.*)\, (.*)\)', line)
        if m:
            score = float(m.group(2))
            if score > best_score:
                best_score = score
                best_url = m.group(1)
                
    return best_score, best_url

if __name__ == "__main__":
    main()