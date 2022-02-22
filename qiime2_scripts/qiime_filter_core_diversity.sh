# initialize conda
conda init

# activate qiime2
source activate qiime2-2020.2

# qiime --help

# start docker with qiime v.2020.2 using alias in .bash_profile
# biodocker 

#filter and remove mitochondria (965 ESVs) and chloroplasts (1,944 ESVs) from your sequence variant table (after classification of sequences)
qiime taxa filter-table --i-table 2019_eelgrass_runs_1_3_16S_table_deblur.qza 
--i-taxonomy 2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza 
--p-exclude mitochondria,chloroplast --o-filtered-table 2019_eelgrass_runs_1_3_16S_table_deblur_mitochondria_chloroplast_removed.qza

# rarefaction 4660
# qiime feature-table rarefy --i-table /data/qiime2_files/2019_eelgrass_runs_1_3_16S_table_deblur_mitochondria_chloroplast_removed.qza 
# --p-sampling-depth 4660 --o-rarefied-table /data/qiime2_files/rarefied_table_4660.qza'

# core diversity analyses (alpha and beta diversity visualizations)
qiime diversity core-metrics --i-table /data/qiime2_files/2019_eelgrass_runs_1_3_16S_table_deblur_mitochondria_chloroplast_removed.qza 
--p-sampling-depth 4660 --m-metadata-file /data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt 
--output-dir /data/qiime2_files/EelgrassWaterMicrobiome2019_corediversity_4660