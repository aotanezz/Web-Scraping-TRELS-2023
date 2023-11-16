### UC San Diego TRELS Summer Research Program 2023
## Web scraping city council website agendas for the city of Chino, CA
## Website link - http://chinocityca.iqm2.com/Citizens/Calendar.aspx 
# By: Alyson Otanez 

rm(list=ls(all=TRUE))

# Install Packages if necessary 
#install.packages('rvest')
#install.packages('xml2')
#install.packages('RCurl')
#install.packages('jsonlite')
#install.packages('httr')
#install.packages("pdftools")
#install.packages('tidtverse')
#install.packages('gsubfn')
#install.packages('here')
#install.packages('purrr')
#install.packages('rJava')
#install.packages('RSelenium')
#install.packages('netstat')
#install.packages('wdman')
#install.packages('seleniumPipes')

# Require packages 
require(rvest)
require(xml2) 
require(RCurl) 
require(jsonlite)
require(httr) 
require(pdftools)
require(tidyverse)
require(gsubfn)
require(here)
require(purrr)
require(rJava)
require(dplyr)
require(RSelenium)
require(netstat)
require(wdman)
require(seleniumPipes)

# Setwd
setwd('/Users/alysonotanez/Desktop/TRELS/Webscrapping Council')

## Chino 

# Load website 
url_chino <- 'http://chinocityca.iqm2.com/Citizens/Calendar.aspx?From=1/1/1900&To=12/31/9999'
chino <- read_html(url_chino)
chino

# Gather links within site 
chino.list <- chino %>% 
  html_nodes('a') %>%
  html_attr('href')
print(chino.list)

# Filter links that correspond to a meeting agenda and add the missing part of the link
chino.list <- chino.list[grep('/Citizens/Detail_Meeting', chino.list)]
chino.list <- paste('http://chinocityca.iqm2.com', chino.list, sep = "") 
chino.list

# Empty data frame to store results 
df <- data.frame(text = character(), stringsAsFactors = FALSE)

# For loop to iterate over each meeting agenda and gather the text, saving to empty df 
for (url in chino.list) {
  Sys.sleep(runif(1,1,5))
  page <- read_html(url)
  text_p <- page %>%
    html_nodes('body') %>%
    html_text() %>%
    trimws()
  date <- strapplyc(text_p, "\\d+/\\d+/\\d+", simplify = TRUE) 
  df <- rbind(df, data.frame(text = text_p, date = date), stringsAsFactors = FALSE)
}
df

# Save as csv
write.csv(df, 'chino_meetings.csv')
