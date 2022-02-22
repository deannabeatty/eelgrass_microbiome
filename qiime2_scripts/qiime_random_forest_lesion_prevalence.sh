# initialize conda
conda init

# activate qiime2
source activate qiime2-2020.2

# qiime --help

# start docker with qiime v.2020.2 using alias in .bash_profile
# biodocker 

# filter table to eelgrass samples only
qiime feature-table filter-samples --i-table rarefied_table.qza 
--o-filtered-table rarefied_table_4660_eelgrass.qza --m-metadata-file 
/data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFull.txt --p-where "SampleType='eelgrass'"

# filter table to green tissue samples only
qiime feature-table filter-samples --i-table rarefied_table_4660_eelgrass.qza 
--o-filtered-table rarefied_table_4660_eelgrass_GreenOnly.qza --m-metadata-file 
/data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFull.txt --p-where "TissueType='Lesion'" 
--p-exclude-ids

# reindex sample id to non-numeric value (newsampleid)
 qiime feature-table group --i-table rarefied_table_4660_eelgrass_GreenOnly.qza --p-axis sample 
 --m-metadata-file /data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFull.txt --m-metadata-column newsampleid 
 --p-mode sum --o-grouped-table rarefied_table_4660_eelgrass_GreenOnly_reindexed.qza

# collapse feature table on the family level taxonomy: 
 qiime taxa collapse --i-table rarefied_table_4660_eelgrass_GreenOnly_reindexed.qza --i-taxonomy 
 /data/qiime2_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza
  --p-level 5 --o-collapsed-table rarefied_table_4660_eelgrass_GreenOnly_reindexed_L5_Family.qza

# random forest regression 1000 trees
qiime sample-classifier regress-samples --i-table rarefied_table_4660_eelgrass_GreenOnly_reindexed.qza 
--m-metadata-file /data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiomePrevalenceNARemoved.txt
 --m-metadata-column PrevalenceMean --p-estimator RandomForestRegressor --p-n-estimators 1000 --p-random-state 123 --output-dir 
 RandomForestPrevalenceMean4660EelgrassGreenOnlyReindexed1000Trees

# random forest regression 1000 trees on family level feature table
 qiime sample-classifier regress-samples --i-table rarefied_table_4660_eelgrass_GreenOnly_reindexed_L5_Family.qza 
 --m-metadata-file /data/qiime2_files/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiomePrevalenceNARemoved.txt
  --m-metadata-column PrevalenceMean --p-estimator RandomForestRegressor --p-n-estimators 1000 --p-random-state 123 --output-dir
   RandomForestPrevalenceMean4660EelgrassGreenOnlyReindexed1000TreesL5Family

