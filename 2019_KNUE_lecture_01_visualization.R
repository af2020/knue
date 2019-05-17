# library load
library(tidyverse)

# data exploration

# tibble type
mpg
help(mpg)

print(mpg, n=20)
View(mpg)

diamonds %>% print(n=20)
View(diamonds)
help(mpg)
help(diamonds)

# data visualization using mpg data

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy))


ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ, y=hwy))

ggplot(data=mpg) +
  geom_area(mapping = aes(x=displ, y=hwy))


ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy))

# color : scaling
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color = class))


ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color = class))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, 
                           color = class,
                           size = hwy,
                           alpha = hwy))
# size : continuous variable, if not warning

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, size=displ))

# alpha 

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, alpha = displ))

# alpha with size

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, alpha = displ, size = displ))


# shape : discrete if not warning

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, shape = class))


# aestheic factor decide 'directly'

# color
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy), color = "blue")


# size
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=class), size = 5)

# alpha
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy), alpha = 0.1)

# shape
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy), shape = 22, color="red", fill="blue")

help(ggplot2)

# shape, color, fill 

##################################
# facet 
##################################

# facet_wrap()

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy)) +
  facet_wrap(~class, nrow=2)

# facet_grid()

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy)) +
  facet_grid(drv ~ cyl)

# facet_grid() with dot

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy)) +
  facet_grid(drv ~ cyl)



##################################
# geometric objects
##################################

# geom_point

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy))

# geom_smooth
ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ, y=hwy))

# geom_smooth with linetype
ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ, y=hwy, 
                            linetype = drv,
                            color=drv))

# geom_smooth with linetype
ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ, y=hwy, linetype = drv, color=drv))
  
# multi layers : geom_smooth + geom_point 1
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=drv)) +
  geom_smooth(mapping = aes(x=displ, y=hwy, linetype = drv, color=drv))

# multi layers : geom_smooth + geom_point 2
ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ, y=hwy, linetype = drv, color=drv),
              show.legend = FALSE)+
  geom_point(mapping = aes(x=displ, y=hwy))

# layers with same data setting

ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) +
  geom_point(mapping = aes(color=class)) +
  geom_smooth()

# layers with different data setting for each layer

ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) +
  geom_point(mapping = aes(color=class)) +
  geom_smooth(
    data=filter(mpg, class=="subcompact"),
    se=FALSE
  )

##################################
# statistical transformation
##################################

# data 
diamonds
help(diamonds)

# what is y?
# data transform included : count as y axis

ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut))

?geom_bar

ggplot(data=diamonds) +
  stat_count(mapping = aes(x=cut))

# stat = 'identity'

diamonds_count <- 
diamonds %>%
  group_by(cut) %>%
  summarise(count = n())

diamonds_count
ggplot(data=diamonds_count) +
  geom_bar(mapping = aes(x=cut, y=count), stat='identity')

# y as ratio
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, y= ..prop.., group=1))

# stat_summary()

ggplot(data=diamonds) +
  stat_summary(mapping = aes(x=cut, y=depth),
               fun.ymin=min,
               fun.ymax=max,
               fun.y=median)

# other stat_ functions
?stat_bin

# bar chart with aesthetic factor

# color
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, color=cut))

# fill
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=cut))

# fill with color
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=cut, color=cut))

ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=cut), color="red")

# apply fill for other variable

ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=clarity))

# apply fill for other variable using position
# with same data

ggplot(data=diamonds, mapping = aes(x=cut, color=clarity)) +
  geom_bar(fill=NA, position='identity')

# position : identity, fill, dodge, jitter

ggplot(data=diamonds) +
  geom_bar(
    mapping = aes(x=cut, fill=clarity),
    position = "fill"
  ) +
  coord_flip()


# using jitter for geom_point

ggplot(data=mpg) +
  geom_point(
    mapping = aes(x=displ, y=hwy),
    position="jitter"
  )


ggplot(data=mpg) +
  geom_point(
    mapping = aes(x=displ, y=hwy)
  )


# coordinates

# boxplot
ggplot(data=mpg, mapping = aes(x=class, y=hwy)) +
  geom_boxplot()

# boxplot with coord_flip()
ggplot(data=mpg, mapping = aes(x=class, y=hwy)) +
  geom_boxplot() +
  coord_flip()

# using coord_polar()
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=cut)) +
  coord_polar()
  
# layer concetp
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut))+
  geom_bar(mapping = aes(x=cut, fill=cut))

ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut, fill=cut)) +
  geom_bar(mapping = aes(x=cut))
  
# with different data (not useful)
ggplot() +
  geom_point(data=mpg, mapping = aes(x=displ, y=hwy)) +
  geom_point(data=diamonds, mapping = aes(x=carat, y=depth))




