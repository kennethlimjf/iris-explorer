library(shiny)

shinyUI(pageWithSidebar(
  # Iris Dataset Application
  headerPanel("Iris Dataset Explorer"),
  
  sidebarPanel(
    
    h3("Graph of Iris Dataset"),
    
    p("Select which species you like to show below:"),
    
    checkboxInput(inputId = "setosa",
                  label = "Setosa",
                  value = TRUE),
    
    checkboxInput(inputId = "versicolor",
                  label = "Versicolor",
                  value = TRUE),
    
    checkboxInput(inputId = "virginica",
                  label = "Virginica",
                  value = TRUE),
    
    br(),
    
    h3("Iris Species Prediction"),
    
    p("Simply slide the sliders for the different properties to predict the Species:"),
    
    sliderInput(inputId="sepal_length",
                label="Sepal Length",
                min=max(0, min(iris$Sepal.Length) - 2),
                max=max(iris$Sepal.Length) + 2,
                step=0.1,
                value=mean(iris$Sepal.Length)),
    
    sliderInput(inputId="sepal_width",
                label="Sepal Width",
                min=max(0, min(iris$Sepal.Width) - 2),
                max=max(iris$Sepal.Width) + 2,
                step=0.1,
                value=mean(iris$Sepal.Width)),
    
    sliderInput(inputId="petal_length",
                label="Petal Length",
                min=max(0, min(iris$Petal.Length) - 2),
                max=max(iris$Petal.Length) + 2,
                step=0.1,
                value=mean(iris$Petal.Length)),
    
    sliderInput(inputId="petal_width",
                label="Petal Width",
                min=max(0, min(iris$Petal.Width) - 2),
                max=max(iris$Petal.Width) + 2,
                step=0.1,
                value=mean(iris$Petal.Width)),
    h4("Predicted Species: "),
    textOutput("species")
  ),
    
  # Main
  mainPanel(
    p("Welcome to Iris dataset explorer. This application allows you study the different properties of the Iris species.
      A summary of the dataset is printed below:"),
    
    verbatimTextOutput("summary"),
    
    br(),
    
    p("The graph below shows a 6 different plots from the Iris dataset. You use the controls on the left to update the
      plots to view the Species you like to see. The red triangle point indicates the current prediction input values on the left."),
    
    plotOutput(outputId = "main_plot", height = "500px"),
    
    br(),
    
    p("You can use the data table below to explore the dataset."),
    
    dataTableOutput("irisTable")
  )
))