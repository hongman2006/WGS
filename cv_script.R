cv <- read.table("cv.list")
library(ggplot2)
p <- ggplot(cv)+geom_line(aes(x=V5,y=V4))+geom_point(aes(x=V5,y=V4))+theme_bw()
ggsave(filename="cv.png")
