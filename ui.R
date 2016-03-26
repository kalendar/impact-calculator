library(shiny)
library(shinythemes)
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("flatly"),
  
tags$head(
#  includeScript("ga.js"),
  tags$style("#intensityPlot{color: #197b30;font-weight: bold;text-decoration: underline;}")
),


  # Application title
  titlePanel("What Are the Impacts of Adopting OER?"),
  helpText("The ", tags$i("OER Adoption Impact Explorer"), " helps you understand some of the impacts of adopting OER instead of commercial textbooks.", tags$br(),
  "Change the values below to match data from your institution to see how OER adoption can benefit your students and institution.", tags$br(),
  "Charts, graphs, and language will update in real time as you make changes."),

  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
    
      
    tags$h2("Institutional Settings"),
    sliderInput("cost", "Average Textbook Cost:",
                  min = 0, max = 250, value = 90),

    sliderInput("students", "Number of Student Enrollments Using OER:",
                min = 0, max = 50000, value = 500, step = 100),
    
    sliderInput("oercost", "Student Fee Supporting OER Program ($ per enrollment):",
                min = 0, max = 25, value = 5),

    sliderInput("instate", "% of Students Paying In-State Tuition:",
                min = 0, max = 100, value = 75),
    
    sliderInput("inrate", "Cost Per Credit Hour (In-state):",
                min = 0, max = 750, value = 175),
    
    sliderInput("outrate", "Cost Per Credit Hour (Out-of-state):",
                min = 0, max = 750, value = 350),
  
    sliderInput("corbetter", "% of Students Historically Receiving a C or Better:",
                min = 0, max = 100, value = 65),

    sliderInput("droprate", "% of Students Historically Dropping:",
                min = 0, max = 40, value = 4),

    sliderInput("bookstore", "% of Bookstore Textbook Costs Returned to Institution as Income:",
              min = 2, max = 10, value = 4.0, step = 0.5),

    tags$h2("Research-based Settings"),
        
    sliderInput("deltac", "% Increase in C or Better Among OER Users:",
              min = 0, max = 30, value = 3, step= 1),
  
    sliderInput("deltadrop", "% Decrease in Drop Rate among OER Users:",
                min = 0, max = 10, value = 1, step= 0.5),

    sliderInput("intensity", "Additional Credits Taken by OER Users:",
              min = 0, max = 9, value = 1.0, step = 0.5),


    helpText(tags$i("The default values for these Research-based Settings are taken from research conducted by the", 
    tags$a(href="http://openedgroup.org/", "Open Education Group.")," The articles reporting these studies, which included over 40,000 students at 11 institutions, 
	  are currently under review for publication in peer-reviewed journals. Tinker with the values to explore the various impacts OER can have on your students and campus."))
  
  ),
     
    # Show a plot of the generated distribution
    mainPanel(
      tags$hr(),
      tags$h2("Total Textbook Cost to Students"),
      plotOutput("costPlot", height="200px", width="80%"),
      
      tags$hr(),
      tags$h2("% of Day One Students Earning a C or Better"),
      plotOutput("completePlot", height="200px", width="80%"),
      
      tags$hr(),
      tags$h2("Student Success Per Required Textbook Dollar"),
      uiOutput("p_ui"),
      ggvisOutput("p"),
      
      tags$hr(),
      tags$h2("Tuition Revenue Refunded to Students Who Drop"),
      plotOutput("tuitionPlot", height="200px", width="80%"),

      tags$hr(),
      tags$h2("Tuition Revenue from Increased Enrollment Intensity"),
      br(),
      p("Students whose faculty assign OER can reinvest their textbook savings in taking additional courses. 
      If the average OER user enrolls in an additional",  
      textOutput("intensity", inline= TRUE), 
      " credit(s), the institution stands to receive an additional $", 
      textOutput("intensityPlot", inline = TRUE), " in tuition revenue."),

      tags$hr(),
      tags$h2("Net Institutional Revenue Change"),
      br(),
      plotOutput("netchangePlot", height="200px", width="80%"),
      p("Net institutional revenue change is calculated as (tuition revenue not refunded) + (tuition revenue from increased enrollment intensity) - (lost bookstore revenue)."),

      tags$hr(),
      tags$h2("Acknowledgments"),
      br(),
      p("The ", tags$i("OER Adoption Impact Explorer,")," version 0.8, is a joint project of the", tags$a(href="http://openedgroup.org/", "Open Education Group"), 
      " and ", tags$a(href="http://lumenlearning.com/", "Lumen Learning."), "Figures provided by the Explorer are estimates. The OER Adoption Impact
      Explorer is written in", tags$a(href="http://www.r-project.org/", "R"), " and delivered by ", tags$a(href="http://shiny.rstudio.com/", "Shiny.")),
      br(),
      br()
  )
 )
))
