# Linear regression + MAE and RMES 

original <- abundance_100secs$individual__count
original_2 <- abundance_100secs$manual_cumulative_no
original_3 <- abundance_100secs$manual_cumulative

predicted <- abundance_100secs$V3TS_count
predicted_2 <- abundance_100secs$predicted_cumulative_no
predicted_3 <- abundance_100secs$predicted_cumulative

library(tidyverse)
library(caret)
library(ggplot2)
library(ggpubr)
library("ie2misc")

model <- lm(predicted~original, data = abundance_100secs)
summary(model)

model_2 <- lm(original_2~predicted_2, data = abundance_100secs)
summary(model_2)

model_3 <- lm(original_3~predicted_3, data = abundance_100secs)
summary(model_3)


plot(x=predicted, y= original,
     xlab = 'Detections',
     ylab = 'Manual Observations')
abline(lm(original~predicted, data = abundance_100secs), col = "blue")
abline(0,1)

ggplot(data=abundance_100secs, aes(x=predicted, y=original)) + xlab("Detections") + ylab("Manual Observations") + geom_count() + geom_smooth(method="lm") + geom_point() + stat_cor(aes(label = paste(..rr.label.., if_else(readr::parse_number(..p.label..) < 0.001, "p<0.001", ..p.label..), sep = "~`,`~")), label.y = 6.5, size=5) + stat_regline_equation(aes(label = paste(..eq.label.., sep = "~")),label.y = 7, size =5) + annotate("text", x = 0.8, y = 6, label= "RMSE = 0.97 ", size = 5)+ theme_bw() + theme(text=element_text(size=15))

ggplot(data=abundance_100secs, aes(x=predicted_2, y=original_2)) + xlab("Detections") + ylab("Manual Observations") + geom_count() + geom_smooth(method="lm") + geom_point() + stat_cor(aes(label = paste(..rr.label.., if_else(readr::parse_number(..p.label..) < 0.001, "p<0.001", ..p.label..), sep = "~`,`~")), label.x = 10, label.y = 125, size=5) + stat_regline_equation(aes(label = paste(..eq.label.., sep = "~")),label.x = 10, label.y = 130, size =5) + annotate("text", x = 33, y = 120, label= "RMSE = 24 ", size = 5)

mae(original_2, predicted_2)
rmse(original_2, predicted_2)

      
