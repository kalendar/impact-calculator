library(shiny)
library(scales) 
library(ggvis)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
#  sliderValues <- reactive({
#  })
  
observe({
  val <- input$droprate
  # Control the value, min, max, and step.
  # Step size is 2 when input value is even; 1 when value is odd.
  updateSliderInput(session, "deltadrop", value = 1, min = 0, max = input$droprate, step = 0.5)
})

  output$costPlot <- renderPlot({
    costtable <- matrix(c(input$cost * input$students, input$oercost * input$students, (input$cost * input$students - input$oercost * input$students) ),nrow=1, ncol = 3)
    costtable <-as.table(costtable)
    commcost <- paste0("Commercial: $", comma(costtable[,1]))
    oercost <-  paste0("OER: $", comma(costtable[,2]))
    diffcost <- paste0("Savings: $", comma(costtable[,3]))
    colnames(costtable) <- c(commcost, oercost, diffcost)
    barplot(costtable,axes=FALSE,beside=TRUE,border=NA,col=c("#790000", "#336699", "#197b30"),space=c(0.1,0.1))
  })


  output$completePlot <- renderPlot({
    comptable <- matrix(c(100 * (input$corbetter * .01), 
                          100 * ((input$corbetter + input$deltac) * .01) + input$deltadrop, 
			 ((100 * ((input$corbetter + input$deltac) * .01) + input$deltadrop) - 100 * (input$corbetter * .01))
                          ),nrow=1, ncol = 3)
    commcomp <- paste0("Commercial: ", sprintf("%.f %%", comptable[,1]))
    oercomp <-  paste0("OER: ", sprintf("%.f %%", comptable[,2]))
    savefig <- comptable[,2] - comptable[,1]
    savecomp <-  paste0("Improvement: ", sprintf("%.f %%", savefig))
    colnames(comptable) <- c(commcomp, oercomp, savecomp)
    comptable <- as.table(comptable)
    barplot(comptable,axes=FALSE,beside=TRUE,border=NA,col=c("#790000", "#336699","#197b30"),space=c(0.1,0.1))
  })
  
reactive({    
    comptable <- matrix(c(100 * (input$corbetter * .01), 
                          100 * ((input$corbetter + input$deltac) * .01) + input$deltadrop, 
                          ((100 * ((input$corbetter + input$deltac) * .01) + input$deltadrop) - 100 * (input$corbetter * .01))
                  ),nrow=1, ncol = 3)
    y <- c(input$cost, input$oercost)
    x <- c(comptable[,1], comptable[,2])
    lopd.lab <- c(paste0("Commercial: ",comptable[,1],"% / $",input$cost), paste0("OER: ",comptable[,2],"% / $",input$oercost))
    lopd <- data.frame(x=x,y=y,lopd.lab=lopd.lab)

    lopd %>%
      ggvis(x = ~x, y = ~y) %>%
      layer_points(x = ~x, y = ~y, fill := "#336699", size := 100) %>%
      layer_text(text := ~lopd.lab, y=~y-(input$cost/14), align:="center") %>% 
      set_options(width = 500, height = 300) %>%
      add_axis("x",title="Percent Completing with a C or Better") %>%
      add_axis("y",title="Required Textbook Cost")  %>%
      scale_numeric("x", domain = c(0, 100), nice = FALSE) %>%
      scale_numeric("y", domain = c(0, input$cost+10), nice = FALSE)
}) %>% bind_shiny("p", "p_ui")
    
  output$tuitionPlot <- renderPlot({
    avgtuition <- input$inrate * (input$instate *.01) + input$outrate * (1 - (input$instate * .01))
    tuit1 <- 3 * input$students * avgtuition * input$droprate * .01
    tuit2 <- 3 * input$students * avgtuition * (input$droprate * .01 - input$deltadrop * .01)
    tuit3 <- tuit1 - tuit2                                       
    tuitiontable <- matrix(c(tuit1, tuit2, tuit3),nrow=1, ncol=3)
    commtuition <- paste0("Commercial: $", comma(tuitiontable[,1]))
    oertuition <-  paste0("OER: $", comma(tuitiontable[,2]))
    difftuition <-  paste0("Retained: $", comma(tuitiontable[,3]))
        colnames(tuitiontable) <- c(commtuition, oertuition, difftuition)
    tuitiontable <-as.table(tuitiontable)
    barplot(tuitiontable,axes=FALSE,border=NA,beside=TRUE,col=c("#790000","#336699","#197b30"),space=c(0.1,0.1))
  })
  

  output$intensity <- renderText({
	input$intensity
  })  


  output$intensityPlot <- renderText({
    avgtuition <- input$inrate * (input$instate *.01) + input$outrate * (1 - (input$instate * .01))
    intensityRev <- comma(input$students * input$intensity * avgtuition)
    intensityRev
    })
  
  output$netchangePlot <- renderPlot({
    avgtuition <- input$inrate * (input$instate *.01) + input$outrate * (1 - (input$instate * .01))
    intensityRev <- (input$students * input$intensity * avgtuition)
    tuit1 <- 3 * input$students * avgtuition * input$droprate * .01
    tuit2 <- 3 * input$students * avgtuition * (input$droprate * .01 - input$deltadrop * .01)
    tuit3 <- tuit1 - tuit2
    netchangetable <- matrix(c(input$cost * input$students * input$bookstore * .01, tuit3 + intensityRev, (tuit3 + intensityRev) - input$cost * input$students * input$bookstore * .01),nrow=1, ncol = 3)
    netchangetable <-as.table(netchangetable)
    commcost <- paste0("Bookstore: -$", comma(netchangetable[,1]))
    oercost <-  paste0("OER: $", comma(netchangetable[,2]))
    diffcost <- paste0("Net Change: $", comma(netchangetable[,3]))
    colnames(netchangetable) <- c(commcost, oercost, diffcost)
    barplot(netchangetable,axes=FALSE,beside=TRUE,border=NA,col=c("#790000", "#336699", "#197b30"),space=c(0.1,0.1))
  })


  
  })
