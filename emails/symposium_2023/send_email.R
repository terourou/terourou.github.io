e <- paste(readLines('email.txt'), collapse = "\n")
txt <- paste(readLines('save_the_date.txt'), collapse = "\n")
html <- paste(readLines('save_the_date.min.html'), collapse = "\n")

subject <- "Save The Data - Symposium 'Our Data Sources as a Strategic National Asset' - March 9 2023"

CONFIRM <- Sys.getenv("CONFIRM")
if (CONFIRM == "TRUE") {

    library(dotenv)
    invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
    email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = "Attendees") |>
        dplyr::filter(!is.na(Email) & Email != "" & Type %in% c("Organiser", "Attendee"))

    # email_list <- data.frame(Email = c("tom.elliott@auckland.ac.nz"))


    message(sprintf("You are about to send this email to %i people. Are you sure? (y/n)", nrow(email_list)))

    if (tolower(readline()) == "y") {
        emails <- paste(email_listEmail, collapse = ",")
    } else {
        email <- ""
        stop()
    }
} else {
    message("This is a test run. Set CONFIRM=TRUE to send emails to the list.")
    subject <- paste("[TEST EMAIL]", subject)

    emails <- paste(
        c(
            "tom.elliott@auckland.ac.nz"
        )
    )
}

e <- gsub("%EMAILS%", emails, e, fixed = TRUE)
e <- gsub("%SUBJECT%", subject, e, fixed = TRUE)
e <- gsub("%TEXT%", txt, e, fixed = TRUE)
e <- gsub("%HTML%", html, e, fixed = TRUE)
cat(e, "\n", file = "tosend.txt")

message("Sending mail ...")
system('cat tosend.txt | sendmail -t')
message("Done!")
