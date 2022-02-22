#!/bin/bash
#
##SBATCH set -x                             # echo commands to stdout 
#SBATCH --mail-user=                        # send email to
#SBATCH --mail-type=ALL                     # slurm notification status to all (begin and end)
#SBATCH -J train_classifier_silva138_390bp  # job id
##SBATCH -N 1                               # number of nodes requested
#SBATCH -p LM                               # partition requested
##SBATCH --ntasks-per-node 1                # request n cores be allocated per node
#SBATCH -t 24:00:00                         # walltime 
#SBATCH --mem=128GB                         # memory in GB, only valid for LM partition
#SBATCH -C LM&EGRESS                        # constraints, LM required for LM jobs that use plyon5 (3TB nodes only), egress allows allows compute nodes to communicate with sites external to bridges
#SBATCH -o qiimeclassifiersilva138.j%j.out                # standard output file to write to
#SBATCH -e qiimeclassifiersilva138.j%j.err                # standard error file to write to


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

# train a naive bayes classifier  from silva v.138 trimmed with primer pair 515F and 926R
qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads silva_138_ssu_nr99_seqs_515f_926r_uniq.qza --i-reference-taxonomy silva_138_99_tax_uniq.qza --o-classifier classifier_ref_seqs_99_silva_v138_16S_f515_r926_uniq_390bp.qza

conda deactivate

