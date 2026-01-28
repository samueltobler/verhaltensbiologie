library(shiny)
library(bslib)
library(readxl)
library(ellmer)
library(dplyr)


# Daten einlesen
#data <- read_xlsx(path = "SHINY_APPS/Musterloesungen.xlsx")
#data <- data[which(data$Musterlösung != "Aufgabe ohne Musterlösung."), ]
#saveRDS(data, "SHINY_APPS/musterloesungen.rds")
#data <- readRDS("SHINY_APPS/musterloesungen.rds")

data <- readRDS("musterloesungen.rds")
possible_combinations <- paste(data$Kapitel, as.character(data$Aufgabe))

# System-Prompt vorbereiten
gpt_model <- "gpt-4o"
instruct.general <- "Du bist ein Biologie-Tutor und bewertest die Antworten von Schülerinnen und Schülern auf biologische Aufgaben. 
Deine Aufgabe ist es, die Schülerantwort genau mit der ursprünglichen Fragestellung sowie der offiziellen Musterlösung zu vergleichen. 
Beziehe dich konkret auf fachliche Übereinstimmungen und Abweichungen. 

Lobe, was korrekt ist und auf die Musterlösung passt, aber benenne auch klar, was fehlt oder falsch ist. 
Wenn keine Antwort gegeben wurde, gib keine Rückmeldung.

Bewerte die Schülerantwort also ausschliesslich im Hinblick auf die gestellte Frage und die Musterlösung. Die zu bewertende Frage lautet:"

# API-Key laden (aus externer Datei)
source("private.R")  # definiert: apiKey

# UI ----
ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),
  
  div(
    style = "max-width: 800px; margin: 50px auto;",
    
    selectInput(
      "selected_chapter", label = NULL,
      choices = c("Kapitel auswählen...", unique(data$Kapitel))
    ),
    
    selectInput(
      "selected_question", label = NULL,
      choices = c("Aufgabe auswählen...", 1:11)
    ),
    
    textAreaInput(
      "text_input", 
      "Geben Sie Ihre Antwort auf die gewählte Frage ein.", 
      "", 
      width = "100%", 
      rows = 6
    ),
    
    actionButton("go_button", "Antwort überprüfen"),
    
    br(), br(),
    p("Hinweis: Die Antworten werden automatisiert mithilfe von OpenAIs GPT-4o-Modell ausgewertet. Keine Daten werden gespeichert oder zu Trainingszwecken weiterverwendet.",
      style = "color: lightgrey; font-size: .7em"),
    
    br(), br(),
    uiOutput("result_output")  # wichtig für HTML mit <pre>
  )
)

# Server ----
server <- function(input, output, session) {
  
  user_text <- eventReactive(input$go_button, {
    
    if (input$selected_chapter == "Kapitel auswählen...") {
      return("Bitte wähle zuerst ein Kapitel aus.")
    }
    
    if (input$selected_question == "Aufgabe auswählen...") {
      return("Bitte wähle eine Aufgabe aus.")
    }
    
    if (trimws(input$text_input) == "") {
      return("Bitte gib zuerst eine Antwort ein.")
    }
    
    combo <- paste(input$selected_chapter, as.character(input$selected_question))
    
    if (!(combo %in% possible_combinations)) {
      return("Diese Frage ist in diesem Kapitel nicht verfügbar.")
    }
    
    frage <- data[data$Kapitel == input$selected_chapter & as.character(data$Aufgabe) == as.character(input$selected_question), ]$Fragestellung
    muster <- data[data$Kapitel == input$selected_chapter & as.character(data$Aufgabe) == as.character(input$selected_question), ]$Musterlösung
    
    instruction <- paste(instruct.general, frage, "Die Musterlösung ist:", muster)
    
    withProgress(message = "Antwort wird evaluiert, bitte warten.", style = "notification", value = 0, {
      incProgress(0.1)
      gpt_chat <- ellmer::chat_openai(system_prompt = instruction, api_key = apiKey, echo = "text", model = gpt_model)
      reply <- gpt_chat$chat(input$text_input)
      incProgress(1)
      reply
    })
  })
  
  output$result_output <- renderUI({
    HTML(paste0("<pre style='white-space: pre-wrap;'>", user_text(), "</pre>"))
  })
}

# App starten ----
shinyApp(ui = ui, server = server)
