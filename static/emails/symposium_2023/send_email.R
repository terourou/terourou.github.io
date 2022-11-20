# e <- paste(readLines('email.txt'), collapse = "\n")

library(dotenv)

txt <- paste(readLines('save_the_date.txt'), collapse = "\n")
html <- paste(readLines('save_the_date.min.html'), collapse = "\n")
subject <- "Save The Date - Symposium 'Our Data Sources as a Strategic National Asset' - March 9 2023"

CONFIRM <- Sys.getenv("CONFIRM")
if (CONFIRM == "TRUE") {
    invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
    email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = "Attendees") |>
        dplyr::filter(!is.na(Email) & Email != "")

    # find column starting with 'Invite?' and select all rows where value is TRUE
    email_list <- email_list[email_list[[6]], ]

    message(sprintf("You are about to send this email to %i people. Are you sure? (y/N)", nrow(email_list)))

    if (tolower(readline()) == "y") {
        emails <- email_list$Email
    } else {
        email <- ""
        stop()
    }
} else {
    message("This is a test run. Set CONFIRM=TRUE to send emails to the list.")
    subject <- paste("[FINAL DRAFT - sending just after lunch]", subject)

    emails <- paste(
        c(
            "tom.elliott@auckland.ac.nz",
            # "colin.simpson@vuw.ac.nz",
            # "a.sporle@auckland.ac.nz",
            # "b.milne@auckland.ac.nz",
            # "robin.blythe@qut.edu.au",
            # "Louise.Pirini@swa.govt.nz",
            NULL
        )
    )
    message("Sending to: ", paste(emails, collapse = ", "))
}

# Send the email
json_template <- list(
    personalizations = list(list(
        to = list(list(
            email = jsonlite::unbox("terourounz@gmail.com"),
            name = jsonlite::unbox("Te Rourou Tātaritanga")
        )),
        bcc = lapply(emails, \(e) list(email = jsonlite::unbox(e)))
    )),
    from = list(
        email = jsonlite::unbox("terourounz@gmail.com"),
        name = jsonlite::unbox("Te Rourou Tātaritanga")
    ),
    subject = jsonlite::unbox(subject),
    content = list(
        list(
            type = jsonlite::unbox("text/plain"),
            value = jsonlite::unbox(txt)
        ),
        list(
            type = jsonlite::unbox("text/html"),
            value = jsonlite::unbox(html)
        )
    )
)

cat(jsonlite::toJSON(json_template, pretty = TRUE), file = "email.json")

cmd <- sprintf(
        paste(
            "curl -s --request POST",
            "--url https://api.sendgrid.com/v3/mail/send",
            "--header \"Authorization: Bearer %s\"",
            "--header 'Content-Type: application/json'",
            "--data \"$(cat email.json)\""
        ),
        Sys.getenv("SENDGRID_API_KEY")
    )

message("Sending email...")
system(cmd)
message("Email sent.")
