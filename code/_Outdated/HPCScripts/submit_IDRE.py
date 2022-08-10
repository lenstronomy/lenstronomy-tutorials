import sys
import os
import pickle
import time

job_name = str(sys.argv[1])

# hoffman2 specifics
dir_path_cluster = '/u/flashscratch/s/sibirrer/'
path2load = os.path.join(dir_path_cluster, job_name)+".txt"

f = open(path2load, 'rb')
input = pickle.load(f)
f.close()

job_name_list = input
for i, job_name in enumerate(job_name_list):
    os.system('./IDRE_submit_job.sh '+str(job_name))
    print('./IDRE_submit_job.sh ' + str(job_name))
    time.sleep(1)
print(len(job_name_list), 'jobs submitted!')
