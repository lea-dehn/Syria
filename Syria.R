#Hvilke lande har haft mest succes med at få udviste syrere til at forlade landet?


library(dplyr)
install.packages("restatapi")
help(package = "restatapi")
library(eurostat)
library(restatapi)

#“What tables do you have related to people being ordered to leave?”
search_eurostat_toc("ordered to leave")

#inspect metadata = information that explains the data.
migr <- get_eurostat_dsd("migr_asyappctza")

migr <- get_eurostat_dsd("migr_eiord")

#variables and categories are in the dataset
unique(migr$concept)


migr |>
  filter(concept == "citizen")

#take migr, keep rows where concept is citizen AND the name Syria

migr |>
  filter(concept == "citizen",
                name == "Syria")

filter(migr, concept == "geo")

#look for tyoe of units in dataset
filter(migr, concept == "unit")

# how often the observations are measured/reported = Annually
filter(migr, concept == "freq")

filter(migr, concept == "age")

filter(migr, concept == "sex")

#download actual data
ordered <- get_eurostat_data("migr_eiord")

#check NAs / none found
colSums(is.na(ordered))

#what years do i Have
unique(ordered$time)

#retrieving needed data
ordered_syria <- filter(ordered,
                        citizen == "SY",
                        age == "TOTAL",
                        sex == "T",
                        unit == "PER",
                        geo %in% c("DE", "DK", "ES", "IT"))



# how many returned?
search_eurostat_toc("returned")
return_meta <- get_eurostat_dsd("migr_eirtn")
unique(migr$concept)
filter(return_meta, code == "SY")

#download data for returning syrians
returned <- get_eurostat_data("migr_eirtn")

filter(return_meta, concept == "c_dest")

#check NAs
colSums(is.na(returned))


returned_syria <- filter(returned,
                         citizen == "SY",
                         c_dest == "TOTAL",
                         age == "TOTAL",
                         sex == "T",
                         unit == "PER",
                         geo %in% c("DE", "DK", "ES", "IT"))


# join tables: rename columns
ordered_syria <- rename(ordered_syria,
                        ordered = values)

returned_syria <- rename(returned_syria,
                         returned = values)

#inner join

comparison <- inner_join(ordered_syria,
                         returned_syria,
                         by = c("geo", "time"))

#keep only what I need, no duplicates

comparison <- select(comparison,
                     geo,
                     time,
                     ordered,
                     returned)

#create a new column with mutate

comparison <- mutate(comparison,
                     return_rate = returned / ordered * 100)

#separate calculation for each country ( add ordered + returned/)

comparison_by_country <- group_by(comparison, geo)
comparison_by_country

country_summary <- summarise(comparison_by_country,
                             total_ordered = sum(ordered),
                             total_returned = sum(returned))

#comparison tot returned/tot ordered x 100

country_summary <- mutate(country_summary,
                          overall_rate = total_returned / total_ordered * 100)


#plot

library(ggplot2)

ggplot(country_summary,
       aes(x = geo, y = overall_rate)) +
  geom_col() +
  geom_text(aes(label = round(overall_rate, 1)),
            vjust = -0.5) +
  labs(
    x = "Country",
    y = "Return ratio (%)",
    caption = "Source: Eurostat"
  )
