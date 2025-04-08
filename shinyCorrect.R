library(shiny)
library(bslib)

gpt_model = "gpt-4o"
instruct.general <- "Du bist ein Biologie-Tutor und evaluierst die 
Antworten von Schülerinnen und Schülern auf biologische Fragen. Sag in deiner
prägnanten konstruktiven Rückmeldung auf die Schülerantwort, was gut war und was noch 
nicht ganz stimmt. Gib keine Antwort, wenn keine Antwort abgegeben wird. Die Frage, zu der die Antwort kommt, lautet: "
source("private.R")

# UI ----
ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),
  
  div(
    style = "max-width: 800px; margin: 50px auto;",
    
    selectInput(
      "selected_question",
      "Wählen Sie die Frage aus:",
      choices = c(
        "Kapitel 3.1: Frage 1",
        "Kapitel 3.1: Frage 2",
        "Kapitel 3.1: Frage 3",
        "Kapitel 3.2: Frage 1",
        "Kapitel 3.2: Frage 2",
        "Kapitel 3.2: Frage 3"
      )
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
    textOutput("result_output")
  )
)

# Server ----
server <- function(input, output, session) {
  
  user_text <- eventReactive(input$go_button, {
    
    if(input$selected_question == "Kapitel 3.1: Frage 1") {
      instruction = paste(instruct.general, "Erklären Sie die Formel $r=0.5^n$ in eigenen Worten. ")
    } 
    if(input$selected_question == "Kapitel 3.1: Frage 2") {
      instruction = paste(instruct.general, "Berechnen Sie den Verwandtschaftskoeffizient $r$ für Individuen 2 und 4, sowie Individuen 3 und 4. Die richtige Lösung wäre: Für Individuen 2 und 4; r wäre = 2*(0.5)^3 = 0.25, für 3 und 4: r = 2*0.5^4 = 0.125")
    } 
    if(input$selected_question == "Kapitel 3.1: Frage 3") {
      instruction = paste(instruct.general, "Berechnen Sie r für Individuen 4 und 5. Die richtige Lösung wäre: 2*0.5^3+0.5 = 0.75")
    } 
    
    if(input$selected_question == "Kapitel 3.2: Frage 1") {
      instruction = paste(instruct.general, "Die Kosten dieses der Wächterin Verhaltens könnten nicht höher sein. Erklären Sie mögliche Nutzen dieses Verhaltens im Kontext des Optimalitätsprinzips.")
    } 
    if(input$selected_question == "Kapitel 3.2: Frage 2") {
      instruction = paste(instruct.general, "Das Verhalten der Wächterin wird oft als «altruistisch» bezeichnet. Stellen Sie eine Definition für dafür auf. Beziehen Sie sich dabei auf ultimate Verhaltensursachen. ")
    } 
    if(input$selected_question == "Kapitel 3.2: Frage 3") {
      instruction = paste(instruct.general, "Überlegen Sie sich, von welchen Faktoren «Fitness» im evolutiven Kontext abhängt. Was ist der Einfluss des altruistischen Verhaltens der Arbeiterinnen auf die Fitness?")
    } 
    
    withProgress(message = 'Antwort wird evaluiert, bitte warten.', style = "notification", value = 0,  {
      incProgress(0.1)
    gpt_chat <- ellmer::chat_openai(system_prompt = instruction, api_key = apiKey, echo="text", model = gpt_model)
    reply <- gpt_chat$chat(input$text_input)
    incProgress(1)
    })
    paste0(reply)
  })
  
  output$result_output <- renderText({
    user_text()
  })
}

# App starten ----
shinyApp(ui = ui, server = server)