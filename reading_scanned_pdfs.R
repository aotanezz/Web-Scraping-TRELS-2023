### UC San Diego TRELS Summer Research 2-23
## Reading scanned pdf text of Ontario and March Joint Powers Authority City Council Agendas
# Note this is just a template
# By: Alyson Otanez 

rm(list=ls(all=TRUE))

# Setwd
setwd('/Users/alysonotanez/Desktop/TRELS/Webscrapping Council')

# Install packages if necessary
#install.packages('tidyverse')
#install.packages('tesseract')
#install.packages('pdftools')

# Load packages 
require(tidyverse)
require(tesseract)
require(pdftools)

# Load df 
df <- read.csv('marchjpa.csv')

df2 <- read.csv('ontario.csv')

# Extract links that have missing text and store them in a data frame
missing_text_links <- df %>%
  subset(is.na(Text) | grepl("^\\s*$", Text)) %>%
  select(PDF.Link)
print(missing_text_links$PDF.Link)

# Empty data frame to store text and PDF.Links 
df_text <- data.frame(Text = character(), PDF.Link = character(), stringsAsFactors = FALSE)

# For loop to read text 
# Loop must be ran twice for each city council 
for (link in missing_text_links$PDF.Link) {
  Sys.sleep(runif(1,1,5))
  pdf.text <- pdf_convert(link, dpi = 600) %>%
    map(ocr) %>% 
    str_replace_all('\n', ' ') %>%
    unlist ()
  pdf.text.all <- paste(pdf.text, collapse = "\n")
  df_updated <- rbind(df_text, data.frame(PDF.Link = link, Text = pdf.text.all), stringsAsFactors = FALSE)
}

# Select those who originally had text 
df_old_text <- df %>%
  subset(!is.na(Text) & !grepl("^\\s*$", Text))

# Merging data sets of those who have text, and text you just gathered 
completed_df <- rbind(df_text, df_old_text)

# Save as csv 
write.csv(completed_df, 'marchjpa_complete.csv')

write.csv(completed_df, 'ontario_complete.csv')
