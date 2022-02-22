library(tidyverse)
library(plyr)
library(dplyr)

# Import site level metadata ----------------------------------------------

#import site level metadata 
eelgrass_metadata_2019_sitelevel <- read_csv("metadata/eelgrass_metadata_2019_sitelevel.csv")

# Import transect level metadata merged with microbiome data ------------------------------------------
EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId <- read_csv("metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleid.csv")

# Import MUR GHRSS daily 2019 temp data -----------------------------------

#import MUR 2019 satellite temp data
MUR2019 <- read.table("metadata/MUR_2019.txt", header = TRUE, sep = ",")
str(MUR2019)

#import GHRSST satellite temp data
GHRSST_2019_combo <- read.table("metadata/GHRSST_2019_combo.txt", header = TRUE, sep = ",")
str(GHRSST_2019_combo)

#create create common variable
MUR2019$RegionSiteCode <- MUR2019$Meadow
#remove "_" in variable
MUR2019$RegionSiteCode <- gsub("_", "", MUR2019$RegionSiteCode)
#remove redundant columns
MUR2019subset <- subset(MUR2019, select = -c(Region,Site))
#remove LA derived SST data 
MUR2019subset <- subset(MUR2019subset, select = -c(Tmean,count,T90,Tmean_ma,T90_ma,DiffMean,DiffT90))
#change analysed_sst col name to SST (column names must be the same for rbind)
MUR2019subset$SST <- MUR2019subset$analysed_sst
#remove redundant column
MUR2019subset = subset(MUR2019subset, select = -c(analysed_sst))
#list column names
colnames(MUR2019subset)

#create create common variable (change name of meadow to RegionSiteCode) in GHRSST
GHRSST_2019_combo$RegionSiteCode <- GHRSST_2019_combo$Meadow
#remove "_" in variable
GHRSST_2019_combo$RegionSiteCode <- gsub("_", "", GHRSST_2019_combo$RegionSiteCode)
#remove redundant columns
GHRSST_2019_combosubset <- subset(GHRSST_2019_combo, select = -c(Region,SiteCode,Site))
# remove LA derived SST data 
GHRSST_2019_combosubset <- subset(GHRSST_2019_combosubset, select = -c(Tmean,count,T90,Tmean_ma,T90_ma,DiffMean,DiffT90))
#list column names
colnames(GHRSST_2019_combosubset)

# Bind MUR and GHRSST temp datasets ---------------------------------------

#use rbind to bind rows of two dataframes with the same number of columns and column names
MUR_GHRSST_temp_daily_2019 <- rbind(GHRSST_2019_combosubset, MUR2019subset)
colnames(MUR_GHRSST_temp_daily_2019)
#write_csv(MUR_GHRSST_temp_daily_2019, "metadata/MUR_GHRSST_temp_daily_2019.csv")

# Join temp datasets (MUR & GHRSST daily 2019) with eelgrass metadata at site --------

#join eelgrass site level metadata with MUR_GHRSST_temp_daily_2019 (365 days included)
eelgrass_metadata_2019_sitelevel_MUR_GHRSST_temp_daily_2019 <- left_join(eelgrass_metadata_2019_sitelevel, MUR_GHRSST_temp_daily_2019, by = 'RegionSiteCode')
colnames(eelgrass_metadata_2019_sitelevel_MUR_GHRSST_temp_daily_2019)
#write_csv(eelgrass_metadata_2019_sitelevel_MUR_GHRSST_temp_daily_2019, "metadata/eelgrass_metadata_2019_sitelevel_MUR_GHRSST_temp_daily_2019.csv")

# Subset temp datasets (MUR & GHRSST daily 2019) by DateCollectedMicrobiome for each RegionSiteCode-----------------

#subset EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId to DateCollectedMicrobiome and RegionSiteCode
RegionSiteCodeDateCollectedMicrobiome <- subset(EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId, 
                                                select = c(RegionSiteCode, DateCollectedMicrobiome))

#remove NAs (negative controls)
RegionSiteCodeDateCollectedMicrobiome <- RegionSiteCodeDateCollectedMicrobiome %>%
  filter(DateCollectedMicrobiome != "NA")
colnames(RegionSiteCodeDateCollectedMicrobiome)
nrow(RegionSiteCodeDateCollectedMicrobiome)

# change variable DateCollectedMicrobiome from character to Date to match MUR_GHRSST_temp_daily_2019
RegionSiteCodeDateCollectedMicrobiome$DateCollectedMicrobiome <- gsub("_", "-", RegionSiteCodeDateCollectedMicrobiome$DateCollectedMicrobiome)
RegionSiteCodeDateCollectedMicrobiome$DateCollectedMicrobiome <- as.Date(RegionSiteCodeDateCollectedMicrobiome$DateCollectedMicrobiome, format = "%m-%d-%y")

# remove duplicate rows in RegionSiteCodeDateCollectedMicrobiome
DistinctRegionSiteCodeDateCollectedMicrobiome <- distinct(RegionSiteCodeDateCollectedMicrobiome)

# create lists before accumulating rows of interest from MUR_GHRSST_temp_daily_2019
MUR_GHRSST_temp_2019_date_collected_microbiome             <- list()
MUR_GHRSST_temp_2019_seven_upto_date_collected_microbiome  <- list()
MUR_GHRSST_temp_2019_thirty_upto_date_collected_microbiome <- list()
MUR_GHRSST_missing_data                                    <- list()

# loop through distinct RegionSiteCode and DateCollectedMicrobiome pairs 
# accumulate temperature for each sampling date from MUR_GHRSST_temp_daily_2019
# obtain temperature values for seven days up to and thirty days up to date collected microbiome
# calculate minimum, maximum, range, and mean temperature for seven days up to and thirty days up to date collected microbiome
for(i in 1:nrow(DistinctRegionSiteCodeDateCollectedMicrobiome) ) {
  this_date <- DistinctRegionSiteCodeDateCollectedMicrobiome[i, "DateCollectedMicrobiome"][[1]]
  this_region_site_code <- DistinctRegionSiteCodeDateCollectedMicrobiome[i, "RegionSiteCode"][[1]]
  this_row <- subset(MUR_GHRSST_temp_daily_2019, subset = (RegionSiteCode == this_region_site_code & Date == this_date))
  
  # get the row index for the variable 'this_row'
  end_index <- which(MUR_GHRSST_temp_daily_2019$Date==this_date & MUR_GHRSST_temp_daily_2019$RegionSiteCode==this_region_site_code)
  
  # get the last seven & thirty days before specified date for specified RegionSiteCode
  if(length(end_index) != 0) {
    # Get the data for the last seven days
    prev_seven_days <- MUR_GHRSST_temp_daily_2019[c((end_index-6):end_index), ]
    
    # calculate stats & add to this_row
    numeric_SST_vals       <- as.numeric(unlist(prev_seven_days["SST"]))
    this_row$"seven_day_min"   <- min(numeric_SST_vals)
    this_row$"seven_day_max"   <- max(numeric_SST_vals)
    this_row$"seven_day_mean"  <- mean(numeric_SST_vals)
    this_row$"seven_day_range" <- (max(numeric_SST_vals) - min(numeric_SST_vals))
    
    # get the data for the last thirty days
    prev_thirty_days <- MUR_GHRSST_temp_daily_2019[c((end_index-29):end_index), ]
    
    # calculate stats & add to this_row
    numeric_SST_vals        <- as.numeric(unlist(prev_thirty_days["SST"]))
    this_row$"thirty_day_min"   <- min(numeric_SST_vals)
    this_row$"thirty_day_max"   <- max(numeric_SST_vals)
    this_row$"thirty_day_mean"  <- mean(numeric_SST_vals)
    this_row$"thirty_day_range" <- (max(numeric_SST_vals) - min(numeric_SST_vals))
    
    MUR_GHRSST_temp_2019_date_collected_microbiome <- append(MUR_GHRSST_temp_2019_date_collected_microbiome, list(this_row))
    
    # min_str <- sprintf("Min SST value of Region Site Code %s: %s", this_region_site_code, min_seven_days)
    # print(min_str)
    # MUR_GHRSST_temp_2019_seven_upto_date_collected_microbiome <- append(MUR_GHRSST_temp_2019_seven_upto_date_collected_microbiome, list(prev_seven_days))
    # MUR_GHRSST_temp_2019_thirty_upto_date_collected_microbiome <- append(MUR_GHRSST_temp_2019_thirty_upto_date_collected_microbiome, list(prev_thirty_days))
  } else {
    str = sprintf("Region Site %s does not have any data for %s", this_region_site_code, this_date)
    MUR_GHRSST_missing_data <- append(MUR_GHRSST_missing_data, list(str))
    print(str)
    write.table(MUR_GHRSST_missing_data, file = "MUR_GHRSST_missing_data.txt")
  }
}

# rbind the list
MUR_GHRSST_temp_2019_date_collected_microbiome <- do.call(rbind, MUR_GHRSST_temp_2019_date_collected_microbiome)
# MUR_GHRSST_temp_2019_seven_upto_date_collected_microbiome <- do.call(rbind, MUR_GHRSST_temp_2019_seven_upto_date_collected_microbiome)
# MUR_GHRSST_temp_2019_thirty_upto_date_collected_microbiome <- do.call(rbind, MUR_GHRSST_temp_2019_thirty_upto_date_collected_microbiome)
MUR_GHRSST_missing_data <- do.call(rbind, MUR_GHRSST_missing_data)

# write accumulated data
#write_csv(MUR_GHRSST_temp_2019_date_collected_microbiome, "metadata/MUR_GHRSST_temp_2019_date_collected_microbiome.csv")
#write.table(MUR_GHRSST_temp_2019_date_collected_microbiome, file = "metadata/MUR_GHRSST_temp_2019_date_collected_microbiome.txt", sep = "\t", quote = FALSE, row.names = FALSE)

# Bind site level metadata with temperature data --------

#bind eelgrass site level metadata with temp data by RegionSiteCode
eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome <- left_join(eelgrass_metadata_2019_sitelevel, 
                                                                                        MUR_GHRSST_temp_2019_date_collected_microbiome, by="RegionSiteCode")
colnames(eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome)
#write_csv(eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome, "metadata/eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome.csv")
#write.table(eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome, file = "metadata/eelgrass_metadata_2019_sitelevel_temp_daily_2019_date_collected_microbiome.txt",
#            sep = "\t", quote = FALSE, row.names = FALSE)

# Bind transect level metadata with daily temp  --------

EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId_temp_daily_2019_date_collected_microbiome <- left_join(EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId, 
                                                                                                              MUR_GHRSST_temp_2019_date_collected_microbiome, by = "RegionSiteCode")
colnames(EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId_temp_daily_2019_date_collected_microbiome)
#write_csv(EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId_temp_daily_2019_date_collected_microbiome, "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.csv")
write.table(EelgrassMicrobiomeWaterSamples2019MetadataFullSampleId_temp_daily_2019_date_collected_microbiome, "metadata/EelgrassMicrobiomeWaterSamples2019MetadataFullSampleIdTempDaily2019DateCollectedMicrobiome.txt",
            sep = "\t", quote = FALSE, row.names = FALSE)
