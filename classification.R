split_test_train <- function(x, y = NULL, classes = c(1,2)){
  print(classes)

  # Set x_bin (x binary) to the unnormalised x dataframe
  x_bin <- x
  
  # Attach the classes (y) to x_bin if seperated
  if (!is.null(y)){
    x_bin$y <- y
  }
  
  # Make sure y is a factor
  x_bin$y <- factor(x_bin$y)
  
  # Only keep desired classes
  x_bin = subset(x_bin, y %in% classes)
  
  # Order the rows on the y column
  #x_bin <- arrange(x_bin, y)

  # Split data in training and test set
  # Specifyin the strata ensures the same ratio of classes between the test and train set
  data_split <- initial_split(x_bin, p = 0.9, strata = 'y')
  x_bin_train <- training(data_split)
  x_bin_test <- testing(data_split)
  
  return(list("train" = x_bin_train, "test" = x_bin_test))
}


gridsearch_svm <- function(x, y = NULL, SVM_recipe){
  # This function performs a gridsearch to optimise the hyperparameters for an svm model.
  
  
  
  
  
  # Create SVM model with hyperparameter tuning capabilities
  svm <-
    svm_rbf(cost = tune(), rbf_sigma = tune()) %>%
    set_mode("classification") %>%
    set_engine("kernlab")
  
  # Setup bootstrapping resample data x_bin_rs
  x_bin_rs <- bootstraps(x, times = 100)
  
  # Setup parallel computing
  # Detect number of available threads (to use number of cores set logical to FALSE)
  all_cores <- parallel::detectCores(logical = TRUE)
  # Generate one R process for each core
  cl <- makePSOCKcluster(all_cores)
  # Register the paralel backedn for the cluster of processes
  registerDoParallel(cl)
  
  SVM_recipe <-
    # Specify the recipe function, here the variable you want to predict should be put the left of the ~ sign,
    # and the predictor variables go to the right of the ~ symbol, since we want to use all other variables we use a dot (y ~ .)
    # We also specify data = x_bin_train such that the recipe will be based on the training data and we can apply an identical
    # transformation to the test set later on, and thus also to any other future data the model shoul be run on.
    recipe(y ~ ., data = x) %>%
    # Set the mean of all predictor variables to 0
    step_center(all_predictors()) %>%
    # Here we fix the range of all the predictor variables of 0 to 1. (min-max normalisation)
    step_range(all_predictors(), min = 0, max = 1)
  
  # Prepare the recipe on the training data so it can also be applied to other data
  SVM_recipe <- prep(SVM_recipe, x)
  
  # Set options for the grid search
  ctrl <- control_grid(verbose = TRUE)
  
  # Set the metric to optimise
  metric <- metric_set(accuracy)
  
  # Start timer
  tic()
  
  recipe_res <-
    svm %>% 
    tune_grid(
      SVM_recipe,
      resamples = x_bin_rs,
      grid = 10,
      metrics = metric,
      control = ctrl
    )
  
  # show how long it took to optimise the svm model
  toc()
  
  recipe_res
  
  # Stop the parallelisation
  stopCluster(cl)
  
  
  show_best(recipe_res, metric = "accuracy")
}