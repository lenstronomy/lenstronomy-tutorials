#### submit_job.sh START #####
#!/bin/bash

name="submit"
slots=24
mem=1  # this will give you 1G per proc
time=1 # this will give you 1 hour runtime

function usage {
    echo -e "\nUsage:\n $0 <config_string>"
}

if [ $# == 0 ]; then
    echo -e "\n Please provide a config_string"
    usage
    exit
fi

config_string="$1"

cat << EOF > ./${name}_${config_string}.cmd
#!/bin/bash
#  UGE job for run_sequence.py built Thu Feb 16 09:35:24 PST 2017
#
#  The following items pertain to this script
#  Use current working directory
#$ -cwd
#  input           = /dev/null
#  output          = /u/home/s/sibirrer/Logs/joblog
#$ -o /u/home/s/sibirrer/Logs/joblog.$JOB_ID
#  error           = Merged with joblog
#$ -j y
#  The following items pertain to the user program
#  user program    = /u/home/s/sibirrer/Scripts/run_sequence.py
#  arguments       = mcmc_test
#  program input   = Specified by user program
#  program output  = Specified by user program
#  Parallelism:  $slots-way parallel
#  Resources requested
# -pe shared 24
#  -l h_data=1024M,h_rt=24:00:00
# -pe $PE $slots
#$ -pe dc_* $slots
#$ -l h_data=${mem}g,h_rt=${time}:00:00$hp
# -pe dc_* 24
# -l h_data=2000M,h_rt=24:00:00,highp
#

#  Name of application for log
#$ -v QQAPP=intelmpi
#  Email address to notify
#$ -M $USER@mail
# -M sibirrer@mail  # old file
#  Notify at beginning and end of job
#$ -m bea
#  Job is not rerunable
#$ -r n
#  Uncomment the next line to have your environment variables used by SGE
# -V
# Initialization for mpi parallel execution
#
  unalias *
  set qqversion =
#  set qqapp     = "intelmpi parallel"
  set qqapp     = "openmpi parallel"
  set qqptasks  = $slots
  set qqidir    = /u/home/s/sibirrer/Scripts
  set qqjob     = run_sequence.py
  set qqodir    = /u/home/s/sibirrer/Scripts
  cd     /u/home/s/sibirrer/Scripts
  source /u/local/bin/qq.sge/qr.runtime
  if ($status != 0) exit (1)
#
  echo "  run_sequence.py directory:"
  echo "    "/u/home/s/sibirrer/Scripts
  echo "  Submitted to UGE:"
  echo "    "$qqsubmit
  echo "  'scratch' directory (on each node):"
  echo "    $qqscratch"
  echo "  mcmc_script.sh n-way parallel job configuration:"
  echo "    $qqconfig" | tr "\\" "\n"
#
  echo ""
  echo "run_sequence.py started on:   "` hostname -s `
  echo "run_sequence.py started at:   "` date `
  echo ""
#
echo ""
echo "Job \$JOB_ID started on:   "\` hostname -s \`
echo "Job \$JOB_ID started on:   "\` date \`
echo ""
#
# Run the user program
#

  source /u/local/Modules/default/init/modules.csh
#  module load gcc/4.3.5
#  module load intelmpi
  module load intel/13.cs
  setenv PATH /u/local/bin:$PATH
  setenv OMP_NUM_THREADS 1
  export PYTHONPATH=/u/local/apps/python/2.7.3/bin/:$PATH
#  export PYTHONPATH=/apps/monch/openmpi/1.7.5/gcc/4.7.3/python_2.7.5/site-packages/:$PYTHONPATH
#  export LD_LIBRARY_PATH=/apps/monch/openmpi/1.7.5/gcc/4.7.3/lib:$LD_LIBRARY_PATH
#  export PATH=/apps/monch/openmpi/1.7.5/gcc/4.7.3/bin:$PATH

#  module load intel/11.1
#  module load openmpi/1.4

  module load python/2.7.3

  which mpirun
  which python

  echo "mpirun -np ${slots} python /u/home/s/sibirrer/Scripts/run_sequence.py $config_string >& /u/home/s/sibirrer/Logs/output.$JOB_ID"

  time mpirun -np ${slots} python  \
         /u/home/s/sibirrer/Scripts/run_sequence.py $config_string >& /u/home/s/sibirrer/Logs/output.$JOB_ID


  echo ""
  echo "run_sequence.py finished at:  "` date `


EOF

chmod u+x ${name}_${config_string}.cmd

if [[ -x ${name}_${config_string}.cmd ]]; then
    echo "qsub ${name}_${config_string}.cmd"
    qsub ${name}_${config_string}.cmd
fi
#### submit_job.sh END #####