library(shiny)

source("crud.R")
source("helpers.R")

shinyApp(

  ui = fluidPage(

    #data table
    DT::dataTableOutput("responses", width = 400),

    #input fields
    tags$hr(),
    textInput("ID", "ID", ""),
    sliderInput("field_a", "field_a", -0.5, 0.5, 0, 0.1, ticks = FALSE),
    radioButtons("field_b", "field_b", list("class_1", "class_2", "class_3")),

    #action buttons
    actionButton("submit", "Submit"),
    actionButton("delete", "Delete")
  ),

  server = function(input, output, session) {

    # input fields are treated as a group
    form_data <- reactive({
      data.frame(ID = input$ID, field_a = input$field_a, field_b = input$field_b)
    })

    # Submit button saves form data
    observeEvent(input$submit, {
      # if record exists, update it
      if (input$ID %in% responses$ID) {
        update_data(form_data())
      } else {
        # if record doesn't exist, create it, and reset form
        create_data(form_data())
        update_inputs(default_record(), session)
      }
    })

    # Delete button deletes selected row from responses
    observeEvent(input$delete, {
      delete_data(form_data())
      update_inputs(default_record(), session)
    })

    # Click a row in the response table to show the values in the form
    observeEvent(input$responses_rows_selected, {
      if (length(input$responses_rows_selected) > 0) {
        data <- read_data()[input$responses_rows_selected, ]
        update_inputs(data, session)
      }

    })

    # display responses table
    output$responses <- DT::renderDataTable(
      {
        #update after submit is clicked
        input$submit
        #update after delete is clicked
        input$delete
        read_data()
      },
      server = TRUE,
      selection = "single"
    )

  }

)
