# helper_config.R
library(here)

# Locate env.yml (the default configurations)
config_file <- here::here("env.yml")

if (!file.exists(config_file)) { # this would be the case of rcmdcheck in Github pipeline
  # Define the source file path two levels up
  print("env.yml is not found in")
  print(config_file)
  source_file <- file.path("..", "..", "env.yml")

  if (file.exists(source_file)) { # this would be the case of rcmdcheck in Github pipeline
    # Define the destination file path in the current directory
    destination_file <- file.path(".", "env.yml")

    # Copy the file from the source path to the destination path
    # file.copy(source_file, destination_file, overwrite = TRUE)
    success <- file.copy(source_file, config_file, overwrite = TRUE)
    if (success && file.exists(config_file)) {
      # Print a message indicating the copy was successful
      cat("env.yml has been successfully copied to testthat directory.\n")
    } else {
      print("File copy failed.")
    }
  }
}
config_load()

# Print a message to indicate the setup file has been executed
print("helper_config.R has been executed")

cat("TEST_FF_PREP_COUNTRY is ")
cat(Sys.getenv("TEST_FF_PREP_COUNTRY"))
