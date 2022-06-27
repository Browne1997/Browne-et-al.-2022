# Threshold and computer vision metrics for P-A
# Note: replace threshold_1 or violin_1 with your relevant .csv data files 
# Install required libaries 

library(PresenceAbsence)
library(ggplot2)

#----------------------------------------------------------------------------------------------------
# Calculating optimal threshold for CIoU to be set (-thresh) using thresold optimisation methods for P-A analysis 
# Error threshold plot 
error.threshold.plot(threshold_1,
                     threshold = 101,
                     which.model = 1,
                     opt.thresholds = TRUE,
                     #smoothing = 1,
                     opt.methods = c("PredPrev=Obs", "MinROCdist", "MaxSens+Spec"),
                     add.legend = TRUE,
                     add.opt.legend = TRUE,
                     legend.cex=0.8,
                     main = " ",
                     color = c("darkorchid1", "darkolivegreen3", "black", "black"),
                     lwd = 1,
                     pch = c(17, 0, 1))
                     


# Calculate optimal thresholds - this is incorporated in graph above
optimal.thresholds(DATA = threshold, threshold = 101, which.model = 1:(ncol(DATA)-2),
                   model.names = NULL, na.rm = FALSE, opt.methods = NULL, req.sens, 
                   req.spec, obs.prev = NULL, smoothing = 1, FPC, FNC)

optimal.thresholds(threshold_1, which.model = 1)



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     axis.ticks.length=unit(0.2,"cm"), legend.position = c(0.92, 0.85))
#----------------------------------------------------------------------------------------------------
# Create and calculating tracking threshold 

# Install required libaries
library(ggbeeswarm)
library(ggpubr)
library(rstatix)

# take 100 example randomly from violin_plot - if required
FP <- violin_1[sample(which(violin_15$detection != "TP"), 100),]
TP <- violin_1[sample(which(violin_15$detection != "FP"), 100),]
violin_15 <- rbind(TP,FP)

# Calculate statistics - if significant there is a differences between the distribution of the data 
df <- violin_1
df$detection <- as.factor(df$detection)
head(df,2)

stat.test <- violin_1 %>%
  group_by() %>%
  t_test(frame ~ detection) %>%
  adjust_pvalue(method = "bonferroni") %>%
  add_significance("p.adj")
stat.test

# stat.test <- compare_means(
#   frame ~ detection, data = violin_1,
#   method = "t.test"
# )
# stat.test

# ---------Create threshold_2 plot----------

ggplot(data = violin_1,aes(x = detection, y = frame))+
  geom_violin(alpha=0.75, position = position_dodge(width = .75),size=0.65, color="black",
              draw_quantiles = c(.25, .75), linetype = "dashed")+
  geom_violin(alpha=0.75, position = position_dodge(width = .75),size=0.65, color="black",
              draw_quantiles = c(.5), aes(fill = detection)) + scale_fill_viridis_d(option = "D", begin = 0.50, end = 0.10 )+
  #geom_boxplot(notch = TRUE,  outlier.size = -1, color="black",lwd=1, alpha = 0.7,show.legend = F)+
  stat_pvalue_manual(stat.test,  label = " t = {round(statistic, 2)}, df = {round(df, 1)}, p = {p.adj}",
                     y.position = 29, fontface = "italic", size = 5)+
  # stat_quantile(mapping = NULL, data = NULL, geom = "quantile",
  #               quantiles = c(0,0.25,0.5,0.75,1),  inherit.aes = TRUE)+
  #geom_point( shape = 21,size=.5, position = position_jitterdodge(), color="black",alpha=1)+
  #ggbeeswarm::geom_quasirandom(shape = 21,size=2, dodge.width = .75, color="black",alpha=.5,show.legend = F)+
  #ggbetweenstats()+
  theme_minimal()+
  ylab(  c("Number of frames per second")  )  +
  xlab(  c("Detections")  )  +
  rremove("legend.title")+
  theme(#panel.border = element_rect(colour = "black", fill=NA, size=2),
    axis.line = element_line(colour = "black",size=1),
    axis.ticks = element_line(size=1,color="black"),
    axis.text = element_text(color="black"),
    axis.ticks.length=unit(0.2,"cm"),
    legend.position = c(0.95, 0.5))+
  font("xylab",size=15)+  
  font("xy",size=15)+ 
  font("xy.text", size = 15) +  
  font("legend.text",size = 15)+
  guides(fill = guide_legend(override.aes = list(alpha = 0.5,color="black")))

# stat <- stat_quantile(mapping = NULL, data = violin_1, geom = "quantile",
#               position = "identity", quantiles = c(0.25, 0.5, 0.75), formula = NULL,
#               method = "rq", na.rm = FALSE)
# ---------------------------------------------------------------------------------

# Confusion matrix 
library(cvms)
library(tibble) 
library(caret)

# -----Plot Confusion Matrix------

confusion_matrix <- confusion_matrix_15Q2
set.seed(1)
d_binomial <- tibble("target" = as.integer(confusion_matrix$observed),
                     "prediction" = as.integer(confusion_matrix$predicted_01))
print(d_binomial)
basic_table <- table(d_binomial)
basic_table

cfm <- as_tibble(basic_table)
cfm

plot_confusion_matrix(cfm, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n",
                      palette = "Greens"
                      )

# --------Calculate metrics-------
confusion_matrix <- confusion_matrix_15Q2
confusionMatrix(as.factor(confusion_matrix$predicted_01), 
                as.factor(confusion_matrix$observed), positive = "1")
d_binomial <- tibble("target" = as.integer(confusion_matrix$observed),
                     "prediction" = as.integer(confusion_matrix$predicted_01))
print(d_binomial)
basic_table <- table(d_binomial)
basic_table
eval2 <- evaluate(d_binomial,
                  target_col = "target",
                  prediction_cols = "prediction",
                  type = "binomial")
print(eval2)
