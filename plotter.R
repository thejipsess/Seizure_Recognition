plot_pca <- function(pca, type = 'regular', PC_x = 1, PC_y = 2){
  # This function take the pca variable generetad by prcomp() and visualises it.
  # By default it plots a histogram of the variance percentage of the PCs
  # Also, it plots a PCA plot of the two specified PCs.
  
  if (type == 'distance'){
    
  }
  
  # Compute the variance (percentage) of the PCs
  pca.var <- pca$sdev^2
  pca.var.per <- round(pca.var/sum(pca.var)*100, 1)
  
  # Plot histograms of the PCs and their variance percentage
  barplot(pca.var.per, main="PCA plot", xlab="Principal component", ylab='Percent variation')
  
  # Extrapolate the PCs of interest
  pca.data <- data.frame(Sample=y, X = pca$x[,PC_x], Y = pca$x[,PC_y])
  
  # Plot the PCs of interest
  ggplot(data = pca.data, aes(x=X, y=Y, label = Sample, color = factor(Sample))) +
    geom_point() +
    xlab(paste(colnames(pca$x)[PC_x], " - ", pca.var.per[PC_x], "%", sep="")) +
    ylab(paste(colnames(pca$x)[PC_y], " - ", pca.var.per[PC_y], "%", sep="")) +
    theme_bw() +
    ggtitle("PCA plot")
  
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


calc_dist <- function(x){
  
}


test <- function(x){
  time = seq(1, 178)
  x_t <- data.frame(t(x))
  x_t$time = time
  col = floor(runif(1, min=1, max = 179))
  
  plt1 <- ggplot(x_t, aes(x=time, y=x_t[,col]))+
    geom_line(colour = 'dodgerblue', size = 1)
  
  col = floor(runif(1, min=1, max = 179))
  
  plt2 <- ggplot(x_t, aes(x=time, y=x_t[,col]))+
    geom_line(colour = 'dodgerblue', size = 1)

  print(plt1)
  print(plt2)
}