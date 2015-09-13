library(ggplot2)
library(dplyr)
library(caret)
library(randomForest)
library(e1071)

modRF = train(Species ~ ., data=iris, method='rf')

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

shinyServer(function(input, output) {
  
  title = reactive({ input$title })
  
  setosa = reactive({ input$setosa })
  versicolor = reactive({ input$versicolor })
  virginica = reactive({ input$virginica })
  
  petal_length = reactive({ input$petal_length })
  petal_width = reactive({ input$petal_width })
  sepal_length = reactive({ input$sepal_length })
  sepal_width = reactive({ input$sepal_width })
  
  output$main_plot = renderPlot({  
    dataset = iris
    if(!(setosa())) { dataset = dataset %>% filter(Species != "setosa") }
    if(!(versicolor())) { dataset = dataset %>% filter(Species != "versicolor") }
    if(!(virginica())) { dataset = dataset %>% filter(Species != "virginica") }
    
    p1 = qplot(Sepal.Width, Sepal.Length, data=dataset, col=Species) + geom_point(aes(x=sepal_width(), y=sepal_length()), color="red", size=3, shape=17)
    p2 = qplot(Sepal.Width, Petal.Length, data=dataset, col=Species) + geom_point(aes(x=sepal_width(), y=petal_length()), color="red", size=3, shape=17)
    p3 = qplot(Sepal.Width, Petal.Width, data=dataset, col=Species) + geom_point(aes(x=sepal_width(), y=petal_width()), color="red", size=3, shape=17)
    p4 = qplot(Sepal.Length, Petal.Length, data=dataset, col=Species) + geom_point(aes(x=sepal_length(), y=petal_length()), color="red", size=3, shape=17)
    p5 = qplot(Sepal.Length, Petal.Width, data=dataset, col=Species) + geom_point(aes(x=sepal_length(), y=petal_width()), color="red", size=3, shape=17)
    p6 = qplot(Sepal.Length, Sepal.Width, data=dataset, col=Species) + geom_point(aes(x=sepal_length(), y=sepal_width()), color="red", size=3, shape=17)
    
    multiplot(p1, p2, p3, p4, p5, p6, cols=2)
  })
  
  output$species = renderText({
    inputValues = data.frame(Sepal.Width = sepal_width(),
                             Sepal.Length = sepal_length(),
                             Petal.Length = petal_length(),
                             Petal.Width = petal_width())
    prediction = predict(modRF, inputValues)
    as.character(prediction)
  })
  
  output$summary = renderPrint({ summary(iris) })
  
  output$irisTable = renderDataTable({ iris })
  
})