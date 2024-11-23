config_load <- function() {
  library(yaml)
  library(here)

  # Locate env.yml (the default configurations)
  config_file <- here::here("env.yml")

  if (file.exists(config_file)) {
    load_vars(config_file)

    # user_config_file is used by users to replace or supplement default configuration
    user_config_file <- here::here("config.yml")
    if (file.exists(user_config_file)) { # optionally load the user config_file
      load_vars(user_config_file)
    }
  } else {
    warning("The env config file does not exist. Please check the file path.")
    warning(config_file)
    # rcmdcheck test
    config_file <- here::here("../../env.yml")
    if (file.exists(config_file)) {
      load_vars(config_file)
    } else {
    warning("The env config file REALLY doesn't exist. Please check the file path.")
    warning(config_file)
  }
}

load_vars <- function(config_file_path) {
  # Load the YAML file
  config <- yaml.load_file(config_file_path)

  # Set environment variables
  set_env_vars <- function(config_list, prefix = "") {
    for (name in names(config_list)) {
      value <- config_list[[name]]
      var_name <- paste0(prefix, toupper(name))
      if (is.list(value)) {
        set_env_vars(value, paste0(var_name, "_"))
      } else {
        # Resolve relative paths to absolute
        if (grepl("^tests/", value)) {
          value <- here::here(value)
        }
        do.call(Sys.setenv, setNames(list(value), var_name))
      }
    }
  }
  set_env_vars(config)
}
