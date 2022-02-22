# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

# qiime --help

# start docker with qiime v.2020.2 using alias in .bash_profile
# biodocker 

# import qiime2 formatted silva 138.1 release small subunit 16S Reference taxonomy 99% silva-138-ssu-nr99-seqs-derep-uniq otherwise called silva-138-99-seqs.qza and silva-138-99-tax.qza 
# extract reads with our primer pair and truncate length of sequences to 390 bp which will reduce run time
qiime feature-classifier extract-reads --i-sequences Silva138.1SSU99QIIME2formatted/silva-138-99-seqs.qza 
--p-f-primer GTGCCAGCMGCCGCGGTAA --p-r-primer CCGYCAATTYMTTTRAGTTT --p-trunc-len 390 --p-read-orientation 
'forward' --o-reads Silva138.1SSU99QIIME2formatted/silva_138_ssu_nr99_seqs_515f_926r.qza

# dereplicate (again) the sequences that are redundant after extracting with your primer pairs and trimming the length of sequences.
qiime rescript dereplicate --i-sequences /data/qiime2_files/Silva138.1SSU99QIIME2formatted/silva_138_ssu_nr99_seqs_515f_926r.qza
 --i-taxa /data/qiime2_files/Silva138.1SSU99QIIME2formatted/silva-138-99-tax.qza --p-rank-handles 'silva' --p-mode 'uniq' 
 --o-dereplicated-sequences /data/qiime2_files/Silva138.1SSU99QIIME2formatted/silva_138_ssu_nr99_seqs_515f_926r_uniq.qza 
 --o-dereplicated-taxa /data/qiime2_files/Silva138.1SSU99QIIME2formatted/silva_138_99_tax_uniq.qza

 # training a classifier and classifying sequences are run on HPCC XSEDE as separate bash scripts
 # see qiime_train_classifier.sh and qiime_classify.sh in qiime2_scripts directory 
