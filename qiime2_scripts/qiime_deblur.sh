# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

# qiime --help

# start docker with qiime v.2020.2 using alias in .bash_profile
# biodocker 

# run deblur to remove erroneous sequences using quality scores and truncate sequences at position 390, where median quality scores begin to drop
qiime deblur denoise-16S --i-demultiplexed-seqs /data/qiime2_files/2019_eelgrass_runs_1_3_16S.qza
 --p-trim-length 390 --o-representative-sequences /data/qiime2_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur.qza
  --o-table /data/qiime2_files/2019_eelgrass_runs_1_3_16S_table_deblur.qza --p-sample-stats --o-stats 
  /data/qiime2_files/2019_eelgrass_runs_1_3_16S_deblur_stats.qza
