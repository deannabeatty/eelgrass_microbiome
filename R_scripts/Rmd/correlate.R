library(tidyverse); packageVersion("tidyverse")

correlate <- function(df, x_var, y_var, taxa_list, taxa_level) {
  # initialize list
  correlation_table <- list()
  # i-th element of y_var correlate i-th position of x_var
  for(i in seq_along(taxa_list)) {
    F1=subset(df, taxa_level == taxa_list[i])
    x_var_Cor <- cor.test(F1[,x_var], F1[,y_var])
    out_row <- data.frame(unique_taxa=taxa_list[i],correlation=x_var_Cor$estimate,p=x_var_Cor$p.value)
    out_row$correlation <- round(out_row$correlation, digits = 3)
    out_row$p <- signif(out_row$p, digits = 3)
    correlation_table[[i]] <- out_row
    
    print(correlation_table[i])
  }
  Corr <- bind_rows(correlation_table)

  return(Corr)
}

# correlate each unique taxa relative abundance (y_var) with some x_var

# create df for correlate function (column 1: taxonomy, column 2: x_var, column 3: y_var)
# subset_df <- df[ , c("OTU", "SST", "Abundance")]
 
# obtain unique list of OTUs or taxa ids
# gini_ESV <- unique(subset_df$OTU)
# subset dataframe by OTUs or taxa
# taxa <- subset_df$OTU
 
# pass parameters to correlate function in this order: df, x_var, y_var, taxa_list, taxa_level
# correlation_table <- correlate(subset_df, c("PrevalenceMean"), c("Abundance"), gini_ESV, taxa)
