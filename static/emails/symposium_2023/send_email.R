# e <- paste(readLines('email.txt'), collapse = "\n")

library(dotenv)

EMAIL <- "registration_invitation"

txt <- paste(readLines(sprintf('%s.txt', EMAIL)), collapse = "\n")
html <- paste(readLines(sprintf('%s.min.html', EMAIL)), collapse = "\n")
subject <- "Invitation to Register - Symposium 'Our Data Sources as a Strategic National Asset' - March 9 2023"

CONFIRM <- Sys.getenv("CONFIRM")
if (CONFIRM == "TRUE") {
    invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
    # email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = "Blocked emails") |>
    #     dplyr::filter(!is.na(Email) & Email != "")
    email_list <- googlesheets4::read_sheet(invite_list_csv,
        sheet = "Registrations of Interest")

    registered <- googlesheets4::read_sheet(invite_list_csv,
        sheet = "Registrations") |>
        dplyr::mutate(name = paste(`First Name`, Surname, sep = " "))
    # bad_emails <- googlesheets4::read_sheet(invite_list_csv,
    #     sheet = "Bad emails")

    # remove registered from email_list
    email_list <- email_list[!(email_list$Email %in% registered$Email),]
    email_list <- email_list[!(email_list$Name %in% registered$name),]

    # remove bad emails
    # email_list <- email_list[!(email_list$Email %in% bad_emails[["Bad email"]]),]

    # find column starting with 'Invite?' and select all rows where value is TRUE
    # invite_col <- grep("Invite?", names(email_list))
    # email_list <- email_list[email_list[[invite_col]], ]

    message(sprintf("You are about to send this email to %i people. Are you sure? (y/N)", nrow(email_list)))

    if (tolower(readline()) == "y") {
        emails <- email_list$Email
        # emails <- "tom.elliott@auckland.ac.nz"
    } else {
        email <- ""
        stop()
    }
} else {
    message("This is a test run. Set CONFIRM=TRUE to send emails to the list.")
    subject <- paste("[Testing mailer - any last minute feedback?]", subject)

    emails <- c(
        # "tomelliottnz@gmail.com",
        "tom.elliott@auckland.ac.nz",
        # "colin.simpson@vuw.ac.nz",
        # "a.sporle@auckland.ac.nz",
        # "b.milne@auckland.ac.nz",
        # "robin.blythe@qut.edu.au",
        # "Louise.Pirini@swa.govt.nz",
        NULL
    )

    message("Sending to: ", paste(emails, collapse = ", "))
}

send_email_to <- function(email) {

    ## This is needed for SENDGRID
    # # Send the email
    json_template <- list(
        to = list(list(
                email = jsonlite::unbox(email)
            )),
        from = list(
            # email = jsonlite::unbox("noreply@terourou.org"),
            email = jsonlite::unbox("contact@terourou.org"),
            name = jsonlite::unbox("Te Rourou Tātaritanga")
        ),
        subject = jsonlite::unbox(subject),
        text = jsonlite::unbox(txt),
        html = jsonlite::unbox(html)
    )

    cat(jsonlite::toJSON(json_template, pretty = TRUE), file = "email.json")
    on.exit(unlink("email.json"))

    cmd <- sprintf(
            paste(
                "curl -s --request POST",
                "--url https://api.mailersend.com/v1/email",
                "--header \"Authorization: Bearer %s\"",
                "--header 'Content-Type: application/json'",
                "--data \"$(cat email.json)\""
            ),
            Sys.getenv("MAILERSEND_API_KEY")
        )

    sent <- try(system(cmd), silent = TRUE)
    if (inherits(sent, "try-error")) {
        message(sprintf("Error sending to %s", email))
        return(FALSE)
    } else {
        message(sprintf("Sent to %s", email))
        return(TRUE)
    }
}

res <- sapply(emails, send_email_to)
readr::write_csv(
    data.frame(email = emails, sent = res),
    "email_results.csv"
)
