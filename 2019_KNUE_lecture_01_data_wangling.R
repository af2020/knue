
# library load
library(nycflights13)
library(tidyverse)

# data exploration

flights

View(flights)
help(flights)

# the abbreviation of carrier code
airlines
airports

# tidy verses with tibble object (<- -> data frame)

# 5 key verses

# filter()
# arrange()
# select()
# mutate()
# summarise()

# group_by()

# df ==> (tidyverse) ==> df
# recursive chaining

#####################################
# filter()
#####################################

filter(flights, month == 11)


# usage: filter(df, <exp>)
flights
filter(flights, month ==1, day==13) 
filter(flights, carrier == 'UA')

# <- operator

J1 <- filter(flights, month ==1, day==1) 

# using paranthesis
(
  J1 <- filter(flights, month==1, day==1)
)

# comparison operator

# >, >= <, <=, !=, ==

# error
filter(flights, month=1)

# filter by dep_delay
filter(flights, dep_delay <=1)

# filter by origin and dest
filter(flights, origin=='JFK', dest=='MIA')
filter(flights, origin !='JFK', dest =="MIA")

# logical operator
# &, |, ! 

filter(flights, month==5 | month == 6)

filter(flights, month ==11 | month ==12)

filter(flights, month %in% c(11,12))

# missing

 NA > 5
 10 == NA
 NA + 10

 NA==NA

# missing check
is.na()
x <- NA
is.na(x)
x
# filter : filters only is.na() == TRUE
df <- tibble(x=c(1, NA, 3))
df
filter(df, x>1)
filter(df, is.na(x) | x>1)

#####################################
# arrange() : sorting
#####################################

# default : asc
arrange(flights, year, month, day)

arrange(flights, year, desc(month), desc(day))

# desc
arrange(flights, desc(arr_delay))

# arrange missing value : NA
df <- tibble(x=c(5,2,NA))
arrange(df, x)
arrange(df, desc(x))

#####################################
# select() : selecct columns
#####################################

select(flights, year, month, day)

select(flights, year, month, day)

select(flights, year:arr_time)
select(flights, -c(year, month))
select(flights, -c(year:arr_time))

# apply column names expression functions

# starts_with()
# ends_with()
# contains()
# matches() - regular expression
# num_range("x", 1:3)
flights
select(flights, starts_with("dep_"))
select(flights, ends_with("delay"))
select(flights, contains("_"))

# rename column
# select(), rename()

flights

select(flights, ??=year, ??=month, ??=day)
select(flights, Y = year, M = month, D = day)

rename(flights, Y=year, M=month, D=day)

# using everything(), selected columns position change
select(flights, Y=year, M=month, D=day, everything())
select(flights, H=hour, M=minute, everything())
flights
#####################################
# mutate() : add column (variable)
#####################################

flights_selected <- 
  select(flights, year:day, distance, air_time)

mutate(flights_selected, speed = distance / air_time * 60)

mutate(flights_selected, speed = distance / air_time * 60)

# created variable can be referenced
mutate(flights_selected, 
       speed = distance / air_time * 60,
       speed100 = speed*100)

# remain only created variables
transmute(flights_selected, 
       speed = distance / air_time * 60,
       speed100 = speed*100)

# functions used for creating new variable in mutate()

# +, -, *, /, ^
flights_selected <- 
  select(flights,contains("dep"), contains("arr"), air_time, distance)

mutate(flights_selected,
       dep_scheduled = dep_time - dep_delay)

# %/%, %%
transmute(flights_selected,
       dep_hour = dep_time %/% 100,
       dep_minute = dep_time %% 100)
flights    
mutate(flights_selected,
       air_time_diff = air_time - mean(air_time))

mutate(flights_selected,
       air_time_diff = air_time - mean(air_time, na.rm=TRUE))

# lead(), lag()
flights_selected <-
select(flights, dep_time)

mutate(flights_selected,
       dep_time_lag = lag(dep_time),
       time_diff = dep_time - dep_time_lag)

# cumulative calculation
flights_filtered <- 
  filter(flights, year == 2013, month==1, day==1, carrier=="UA")

flights_filtered_selected <-
  select(flights_filtered, air_time, distance)

flights_filtered_selected

flights_filtered_selected_arranged <- 
  arrange(flights_filtered_selected, desc(air_time))

mutate(flights_filtered_selected_arranged,
       cumsum_air_time= cumsum(air_time),
       percent_air_time = round(air_time / sum(air_time, na.rm=TRUE)*100,2),
       cumsum_percent_air_time = cumsum(percent_air_time)
       )

# logical operator : <, <=, >, >=, !=

transmute(flights,
       positive_dep_delay = dep_delay >0)

# rank

transmute(flights,
       min_rank(air_time))


####################################
# summarise()
####################################

summarise(flights,
          MENA_air_time = mean(air_time, na.rm=TRUE))

summarise(flights, mean(air_time))
select(flights, air_time)
# must be used with group_by()
by_month <- group_by(flights, year, month)
summarise(by_month, MEAN_dep_delay_time = mean(dep_delay, na.rm=TRUE))

# by_carrier
by_carrier <- group_by(flights, carrier)
summarise(by_carrier, MEAN = mean(air_time, na.rm=TRUE))
# 2013.07. which carrier much delay time 

flights_filtered <- 
filter(flights, year==2013, month ==7)

flights_filtered_by_carrier <- 
group_by(flights_filtered, carrier)

flights_filtered_by_carrier_summarised <- 
summarise(flights_filtered_by_carrier, MEAN_dep_delay = mean(dep_delay, na.rm=TRUE))

flights_filtered_by_carrier_summarised_arranged <- 
arrange(flights_filtered_by_carrier_summarised, desc(MEAN_dep_delay))

flights_filtered_by_carrier_summarised_arranged

airlines

# one function
arrange(flights_filtered_by_carrier_summarised, desc(MEAN_dep_delay))
arrange(summarise(flights_filtered_by_carrier, MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)), desc(MEAN_dep_delay))
arrange(summarise(group_by(flights_filtered, carrier), MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)), desc(MEAN_dep_delay))
arrange(summarise(group_by(filter(flights, year==2013, month ==7), carrier), MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)), desc(MEAN_dep_delay))

arrange(
  summarise(
    group_by(
      filter(flights, year==2013, month ==7), 
      carrier), 
    MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)), 
  desc(MEAN_dep_delay))

####################################
# pipe operator : %>%
####################################
# x %>% f(y)
# f(x,y)

flights %>%
  filter(year==2013, month ==7) %>%
  group_by(carrier) %>%
  summarise(MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)) %>%
  arrange(desc(MEAN_dep_delay))



# why pipe operator

# machine operation
# arrange function ==> summarise function ==> group_by function ==> filter function
arrange(
  summarise(
    group_by(
      filter(flights, year==2013, month ==7), 
      carrier), 
    MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)), 
  desc(MEAN_dep_delay))

# human think
# filter ==> group_by ==> summarise ==> arrange
flights %>%
  filter(year==2013, month ==7) %>%
  group_by(carrier) %>%
  summarise(MEAN_dep_delay = mean(dep_delay, na.rm=TRUE)) %>%
  arrange(desc(MEAN_dep_delay))

# writing df as text file
write_delim(flights, "d:/flights.txt", delim="|", na="NA") 

# missing data handling
not_cancelled <- 
flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(mean=mean(dep_delay))

# delays for all airlines
delays <-
not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay))

# visualization
# how much delays for each airline
ggplot(data=delays, mapping=aes(x=delay)) +
  geom_freqpoly(binwidth=10)

# drill down
delays <- 
not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm=TRUE),
    n=n()
  )

ggplot(data=delays, mapping=aes(x=n, y=delay)) +
  geom_point(alpha = 0.1)


# using short cut : CTRL + SHIFT + P : using chunk again
delays %>%
  filter(n >200) %>%
  ggplot(mapping = aes(x=n, y=delay)) +
  geom_point(alpha=0.1)

# n(), n() with na.rm, n_distinct(), count()
not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

# sum(), mean() with logical operator
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>%
  group_by(year, month) %>%
  summarise(hour_delay_percent = mean(arr_delay > 60)) %>%
  ggplot(mapping = aes(x=month, y=hour_delay_percent, fill=hour_delay_percent)) +
  geom_bar(stat="identity")

# ungroup
flights %>%
  group_by(year, month, day) %>%
  ungroup() %>%
  summarise(mean(air_time, na.rm=TRUE))

# group_by() with filter() and mutate()

flights %>%
  group_by(year, month, day) %>%
  # arrange(desc(arr_delay)) %>%
  filter(rank(desc(arr_delay))<5)

flights %>%
  group_by(dest) %>%
  filter(n() >365)


# writing df as text file
write_delim(flights, "d:/flights.txt", delim="|", na="NA")
write_delim(mpg, "d:/mpg.txt", delim="|", na="NA") 
write_delim(diamonds, "d:/diamonds.txt", delim="|", na="NA") 















              
              
















































