split_test_train <- function(x, y = NULL, classes = c(1,2)){
  # Set seed to ensure reproducibility
  set.seed(4685)
  
  # Set x_bin (x binary) to the unnormalised x dataframe
  x_bin <- x
  
  # Attach the classes (y) to x_bin if seperated
  if (!is.null(y)){
    print('attaching')
    x_bin$y <- y
  }
  # Only keep desired classes
  x_bin = subset(x_bin, as.numeric(y) %in% classes)
  
  # Make sure y is a factor
  x_bin$y <- factor(x_bin$y)
  
  # Order the rows on the y column
  #x_bin <- arrange(x_bin, y)

  # Split data in training and test set
  # Specifyin the strata ensures the same ratio of classes between the test and train set
  data_split <- initial_split(x_bin, p = 0.9, strata = 'y')
  x_bin_train <- training(data_split)
  x_bin_test <- testing(data_split)
  
  return(list("train" = x_bin_train, "test" = x_bin_test))
}


gridsearch_svm_rbf <- function(x, y = NULL, SVM_recipe, parallel = T){
  # This function performs a gridsearch to optimise the hyperparameters for a radial basis function svm model.
  
  
  # Create SVM model with hyperparameter tuning capabilities
  svm <-
    svm_rbf(cost = tune(), rbf_sigma = tune()) %>%
    set_mode("classification") %>%
    set_engine("kernlab")
  
  # Setup bootstrapping resample data x_bin_rs
  x_bin_rs <- bootstraps(x, times = 100)
  
  if(parallel == TRUE){
    # Setup parallel computing
    # Detect number of available threads (to use number of cores set logical to FALSE)
    all_cores <- parallel::detectCores(logical = TRUE)
    # Generate one R process for each core
    cl <- makePSOCKcluster(all_cores)
    # Register the paralel backedn for the cluster of processes
    registerDoParallel(cl)
  }
  
  # Prepare the recipe on the training data so it can also be applied to other data
  SVM_recipe <- prep(SVM_recipe, x)
  
  # Set options for the grid search
  ctrl <- control_grid(verbose = TRUE)
  
  # Define the search space for the hyperparameters
  search_grid <- expand_grid(cost = 10^(-2:1), rbf_sigma = 10^(-4:0))
  
  # Set the metric to optimise
  metric <- metric_set(accuracy)
  
  # Start timer
  tic()
  
  recipe_res <-
    svm %>% 
    tune_grid(
      SVM_recipe,
      resamples = x_bin_rs,
      grid = search_grid,
      metrics = metric,
      control = ctrl
    )
  
  # show how long it took to optimise the svm model
  toc()
  
  
  
  if(parallel == TRUE){
    # Stop the parallelisation
    stopCluster(cl)
    }
  
  # Print gridsearch results
  show_best(recipe_res, metric = "accuracy")
  
  return(recipe_res)
}