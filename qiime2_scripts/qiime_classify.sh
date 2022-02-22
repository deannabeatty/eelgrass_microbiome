#!/bin/bash
#
##SBATCH set -x                             # echo commands to stdout 
#SBATCH --mail-user=                        # send email to
#SBATCH --mail-type=ALL                     # slurm notification status to all (begin and end)
#SBATCH -J classify_mydata_silva138_390bp   # job id
##SBATCH -N 1                               # number of nodes requested
#SBATCH -p LM                               # partition requested
##SBATCH --ntasks-per-node 1                # request n cores be allocated per node
#SBATCH -t 24:00:00                         # walltime 
#SBATCH --mem=128GB                         # memory in GB, only valid for LM partition
#SBATCH -C LM&EGRESS                        # constraints, LM required for LM jobs that use plyon5 (3TB nodes only), egress allows allows compute nodes to communicate with sites external to bridges
#SBATCH -o qiimeclassifymydata.j%j.out      # standard output file to write to
#SBATCH -e qiimeclassifymydata.j%j.err      # standard error file to write to


# move to your appropriate pylon5 directory
# this job assumes:
#  - all input data is stored in this directory
#  - all output should be stored in this directory
# - cd /pylon5/groupname/username/path-to-directory
cd /pylon5/#######/dbeatty/eelgrass_2019/silva_v138

# module load anaconda 
# module load anaconda3/2019.3

# initialize conda
# conda init

# activate qiime2
source activate qiime2-2020.2

# qiime --help

# classify sequenes with sklearn using naive bayes trained classifier from Silva 138
qiime feature-classifier classify-sklearn --i-classifier classifier_ref_seqs_99_silva_v138_16S_f515_r926_uniq_390bp.qza --i-reads 2019_eelgrass_runs_1_3_16S_rep_sequences_deblur.qza --o-classification 2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza

conda deactivate

