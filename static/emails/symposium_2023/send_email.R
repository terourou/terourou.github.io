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
        sheet = "Attendees") |>
        dplyr::filter(!is.na(Email) & Email != "") |>
        # filter Type Attendee
        dplyr::filter(Type == "Attendee") |>
        # create name from First name and Surname
        dplyr::mutate(name = paste0(`First Name`, " ", Surname))

    registered <- googlesheets4::read_sheet(invite_list_csv,
        sheet = "Registrations of Interest")
    bad_emails <- googlesheets4::read_sheet(invite_list_csv,
        sheet = "Bad emails")

    # remove registered from email_list
    email_list <- email_list[!(email_list$Email %in% registered$Email),]
    email_list <- email_list[!(email_list$name %in% registered$Name),]

    # remove bad emails
    email_list <- email_list[!(email_list$Email %in% bad_emails[["Bad email"]]),]

    # find column starting with 'Invite?' and select all rows where value is TRUE
    invite_col <- grep("Invite?", names(email_list))
    email_list <- email_list[email_list[[invite_col]], ]

    message(sprintf("You are about to send this email to %i people. Are you sure? (y/N)", nrow(email_list)))

    if (tolower(readline()) == "y") {
        # emails <- email_list$Email
        emails <- "tom.elliott@auckland.ac.nz"
    } else {
        email <- ""
        stop()
    }
} else {
    message("This is a test run. Set CONFIRM=TRUE to send emails to the list.")
    subject <- paste("[TEST]", subject)

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



## This is needed for SENDGRID
# # Send the email
json_template <- list(
    to = list(list(
            email = jsonlite::unbox("terourounz@gmail.com"),
            name = jsonlite::unbox("Te Rourou Tātaritanga")
        )),
    bcc = lapply(emails, \(e) list(email = jsonlite::unbox(e))),
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


## THIS IS NEEDED FOR MAILGUN
# cmd <- sprintf(
#     paste(
#         "curl -s --user 'api:%s'",
#         "https://api.mailgun.net/v3/%s/messages",
#         "-F from='Te Rourou Tātaritanga <contact@terourou.org>'",
#         # "-F h:Reply-To='Te Rourou Tātaritanga <terourounz@gmail.com>'",
#         "-F to='Te Rourou Tātaritanga <contact@terourou.org>'",
#         "-F bcc=\"%s\"",
#         "-F subject=\"%s\"",
#         "-F text=\"%s\"",
#         "--form-string html=\"$(cat save_the_date.min.html)\""
#     ),
#     Sys.getenv("MAILGUN_API_KEY"),
#     "terourou.org",
#     paste(emails, collapse = ","),
#     subject,
#     txt
# )

message("Sending email...")
system(cmd)
message("Email sent.")
