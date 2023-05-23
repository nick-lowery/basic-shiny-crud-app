
# Responses here a just being stored as a variable in the local session
# See https://shiny.posit.co/r/articles/build/persistent-data-storage/
# for other backend storage mechanisms

# Create = add new records to the table
create_data <- function(new_row) {
  responses <<- rbind(responses, new_row)
}

# Read = populate table with records
read_data <- function() {
  # if the data doesn't exist in the current environment, simulate it
  # (this will run on initial load of the server)
  if (!exists("responses")) {
    responses <<- data.frame(
      ID = seq(1e5) |> as.character(),
      field_a = rnorm(1e5, sd = 0.1) |> round(digits = 1),
      field_b = sample(c("class_1", "class_2", "class_3"), size = 1e5, replace = TRUE)
    )
  }
  responses
}

# Update = modify the selected row with form data
update_data <- function(changed_row) {
  responses[responses$ID == changed_row$ID, ] <<- changed_row
}

# Delete = remove the selected row
delete_data <- function(row_to_delete) {
  responses <<- responses[responses$ID != row_to_delete$ID, ]
}
