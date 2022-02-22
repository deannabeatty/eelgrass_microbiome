#Installing qiime2R
#if (!requireNamespace("devtools", quietly = TRUE)){install.packages("devtools")}
#devtools::install_github("jbisanz/qiime2R")
library(qiime2R)
library(tidyverse)
library(phyloseq)

# import metadata 
# changed "#SampleID" to "sampleid" according to Qiime2R recommendation for metadata
MetadataTable <- read.table("metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt", sep = "\t", header = TRUE)

#import rooted phylogenetic tree
RootedTree <- read_qza("qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_aligned_masked_rooted_tree.qza")

#import taxonomy (chloroplasts & mitochondria are in the taxonomy table; removed from feature tables with Qiime2 filter feature-table function)
Taxonomy <- read_qza("qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza")
head(Taxonomy$data)
ParseTaxonomy <- parse_taxonomy(Taxonomy$data)
head(ParseTaxonomy)

#sampleids should not be numeric in R
#import reindexed feature table green tissue only
GreenOnlyRarefiedTable4660Reindex <- read_qza("qza_files/4660/rarefied_table_4660_eelgrass_GreenOnly_reindexed.qza")
#types of information in the imported object
names(GreenOnlyRarefiedTable4660Reindex)
#phyloseq object data each row denotes a sequence variant identified by unique hash ID  
GreenOnlyRarefiedTable4660Reindex$data[1:5,1:5]
#unique identifier for this object
GreenOnlyRarefiedTable4660Reindex$uuid
#type of file, FeatureTable[Frequency]
GreenOnlyRarefiedTable4660Reindex$type

#create phyloseq object green tissue samples only
GreenOnly4660PhyloseqObj <- qza_to_phyloseq(
  features = "qza_files/4660/rarefied_table_4660_eelgrass_GreenOnly_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_GreenOnly_seqs_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(GreenOnly4660PhyloseqObj, file = "phyloseq_object/GreenOnly4660PhyloseqObj.rds")

# merge ESVs that have the same classification at taxonomic rank family; keep NAs to match qiime2 glom
GreenOnly4660PhyloseqObjGlomFamilyNA = tax_glom(GreenOnly4660PhyloseqObj, taxrank = "Family", NArm = FALSE)
saveRDS(GreenOnly4660PhyloseqObjGlomFamilyNA, file = "phyloseq_object/GreenOnly4660PhyloseqObjGlomFamilyNA.rds")

#create phyloseq object lesion blade samples only
LesionBladeOnly4660PhyloseqObj<- qza_to_phyloseq(
  features = "qza_files/4660/rarefied_table_4660_eelgrass_LesionBladeOnly_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_LesionBladeOnly_seqs_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(LesionBladeOnly4660PhyloseqObj, file = "phyloseq_object/LesionBladeOnly4660PhyloseqObj.rds")

# create phyloseq object all eelgrass samples
Eelgrass4660PhyloseqObj <- qza_to_phyloseq(
  features = "qza_files/4660/rarefied_table_4660_eelgrass_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(Eelgrass4660PhyloseqObj, file = "phyloseq_object/Eelgrass4660PhyloseqObj.rds")

# create phyloseq object water samples only
Water4660PhyloseqObj <- qza_to_phyloseq(
  features = "qza_files/4660/rarefied_table_4660_water_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_water_seqs_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(Water4660PhyloseqObj, file = "phyloseq_object/Water4660PhyloseqObj.rds")

# merge ESVs that have the same classification at taxonomic rank family; keep NAs to match qiime2 glom
Water4660PhyloseqObjGlomFamilyNA = tax_glom(Water4660PhyloseqObj, taxrank = "Family", NArm = FALSE)
saveRDS(Water4660PhyloseqObjGlomFamilyNA, file = "phyloseq_object/Water4660PhyloseqObjGlomFamilyNA.rds")

# create phyloseq object of eelgrass and water samples
EelgrassWater4660PhyloseqObj <- qza_to_phyloseq(
  features = "qza_files/4660/rarefied_table_4660_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(EelgrassWater4660PhyloseqObj, file = "phyloseq_object/EelgrassWater4660PhyloseqObj.rds")

# phyloseq object of non-rarefied table after filtering out chloroplasts and mitochondria in qiime2
DeblurTablePhyloseqObj <- qza_to_phyloseq(
  features = "qza_files/table_deblur_mitochondria_chloroplast_removed_reindexed.qza",
  tree = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_aligned_masked_rooted_tree.qza",
  taxonomy = "qza_files/2019_eelgrass_runs_1_3_16S_rep_sequences_deblur_sklearn_naive_bayes_taxonomy.qza",
  metadata = "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt"
)
saveRDS(DeblurTablePhyloseqObj, file = "phyloseq_object/DeblurTablePhyloseqObj.rds")
