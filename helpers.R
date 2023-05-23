default_record <- function() {
  data.frame(ID = "", field_a = 0, field_b = "class_1")
}

update_inputs <- function(data, session) {
  updateTextInput(session, "ID", value = data$ID)
  updateSliderInput(session, "field_a", value = data$field_a)
  updateRadioButtons(session, "field_b", selected = data$field_b)
}
