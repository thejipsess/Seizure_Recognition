plot_pca <- function(pca, y, type = 'regular', PC_x = 1, PC_y = 2, PC_z=3, title = "",
                     save=FALSE, include_3D = FALSE, alpha = 1, legend_title = 'legend'){
  # This function take the pca variable generetad by prcomp() and visualises it.
  # By default it plots a histogram of the variance percentage of the PCs
  # Also, it plots a PCA plot of the specified PCs.
  
  
  
  # Compute the variance (percentage) of the PCs
  pca.var <- pca$sdev^2
  pca.var.per <- round(pca.var/sum(pca.var)*100, 1)
  
  # Plot histograms of the PCs and their variance percentage
  barplot(pca.var.per, main=paste("PCA barplot", title), xlab="Principal component", ylab='Percent variation')
  
  # Extrapolate the PCs of interest
  pca.data <- data.frame(Sample=y, X = pca$x[,PC_x], Y = pca$x[,PC_y])
  
  # Plot the PCs of interest
  PCA_score_plot <- ggplot(data = pca.data, aes(x=X, y=Y, label = Sample, colour = factor(Sample))) +
                            geom_point(alpha = alpha) +
                            xlab(paste(colnames(pca$x)[PC_x], " - ", pca.var.per[PC_x], "%", sep="")) +
                            ylab(paste(colnames(pca$x)[PC_y], " - ", pca.var.per[PC_y], "%", sep="")) +
                            theme_bw() +
                            coord_fixed(1) +
                            ggtitle(paste("PCA score plot: ", title))
  
  # Add legend title
  PCA_score_plot <- PCA_score_plot + scale_colour_discrete(name = legend_title)
  
  print(PCA_score_plot)
  
  if(save)
    ggsave(paste("Figures/PCA_score_plot_", title, ".png"), plot = PCA_score_plot, device = 'png', dpi=1200)
  
  if (include_3D){
    pca3d(pca, group=pca.data$Sample, components = c(PC_x, PC_y, PC_z))
  }
  
}

plot_dens <- function(x, title = "Density plot"){
  # This function plots a density plot of x with specified title.
  
  long = melt(x, id.vars = 0)
  
  ggplot(long, aes (value)) +
    geom_density() +
    ggtitle(title)
}

plot_rand_sample <- function(x){
  # this function plots a random sample over time.
  
  time = seq(1, 178)
  x_t <- data.frame(t(x))
  x_t$time = time
  col = floor(runif(1, min=1, max = 179))
  ggplot(x_t, aes(x=time, y=x_t[,col]))+
    geom_line(colour = 'dodgerblue', size = 1)
}

plot_violin <-function(x, y, title = "violin plot for all classes"){
  # This function plots a violin plot of x, grouped by the classes in y.
  data_full <- x
  data_full$y <- y
  res <- melt(data_full, id.vars='y')
  
  # create The violin plots
  ggplot(res, aes(x = y, y = value, group = y))+
    geom_violin()+
    ggtitle("Violin plot of the different classes")
}

plot_boxplot <- function(x, y=NULL, type = "all"){
  # This function creates boxplots, either of all variables, or for all classes.
  # The default value for type is 'all', which results in both variables and class plots.
  
  if(type == 'entire' || type =='all'){
    # PLot the boxplot of the entire data
    long = melt(x, id.vars = 0)
    bp_entire <- ggplot(long, aes(x = variable, y = value))+
                        geom_boxplot()+
                        ggtitle("Boxplot of entire data set")
  }
  
  
  if(type == 'class' || type =='all'){
    # plot the boxplots per class
    data_full <- x
    data_full$y <- y
    res <- melt(data_full, id.vars='y')
    
    bp_class <- ggplot(res, aes(x = y, y = value, group=y))+
                      geom_boxplot()+
                      ggtitle("boxplot of the different classes")+
                      xlim(0.5, 5.5)
    
  }
  
  print(bp_entire)
  print(bp_class)
}


plot_heatmap <- function(x, title = "Heatmap", save = FALSE){
  # PLots a heatmap op matrix x, can also locally save the figure.
  
  # Generate heatmap
  hm <- heatmap(x, Rowv = NA, Colv = NA, labRow = z$y, labCol = z$y, scale="none", main = title)
  
  if(save){
    # save heatmap
    png(file = paste("Figures/", title, ".png"), antialias = "cleartype", width = 6, height = 6, units = 'in', res = 600)
    hm <- heatmap(x, Rowv = NA, Colv = NA, labRow = z$y, labCol = z$y, scale="none", main = title)
    dev.off()
  }
  
}


pca_projection <- function(train, test, recipe){
  # This function performs pca on a training set, plots it, and projects the set set on top of the PCA
  # Prepare the recipe
  SVM_recipe <- prep(SVM_recipe)
  
  test_norm <- bake(SVM_recipe, x_bin_test)
  train_norm <- bake(SVM_recipe, x_bin_train)
  
  # Perform PCA on training set
  pca <- prcomp(subset(train_norm, select = -y), center = FALSE, scale=FALSE)
  train_scores <- data.frame(pca$x)
  train_scores$type <- rep('train', nrow(pca$x))
  
  # Project test set onto the PCA of the training set
  test_proj <- data.frame(as.matrix(subset(test_norm, select = -y)) %*% pca$rotation)
  test_proj$type <- rep('test', nrow(test_proj))
  
  # Combine PcA and projection in one variable
  pca_proj <- rbind(train_scores, test_proj)
  
  ggplot(data = data.frame(Sample=pca_proj$type, X = pca_proj[,1], Y = pca_proj[,2]), aes(x=X, y=Y, colour = factor(Sample))) +
    geom_point(alpha = 0.5) +
    theme_bw() +
    ggtitle(paste("PCA score plot of training data with projected test set", title))
  
}