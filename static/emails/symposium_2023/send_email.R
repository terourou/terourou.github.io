# e <- paste(readLines('email.txt'), collapse = "\n")

library(dotenv)

EMAIL <- Sys.getenv("EMAIL")
if (EMAIL == "") {
    stop("NO EMAIL SET. Set EMAIL=registration_invitation or EMAIL=confirmation")
}

txt <- paste(readLines(sprintf('%s.txt', EMAIL)), collapse = "\n")
html <- paste(readLines(sprintf('%s.min.html', EMAIL)), collapse = "\n")
subject <- "Invitation to 'Our Data Sources as a Strategic National Asset' Symposium in Wellington on March 9 2023"

CONFIRM <- Sys.getenv("CONFIRM")
if (CONFIRM == "TRUE") {
    invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
    attendee_list_csv <- Sys.getenv("GOOGLE_SHEET_ATTENDEES")

    if (EMAIL == "registration_invitation") {
        # # our list of attendees
        # attendee_list <- googlesheets4::read_sheet(invite_list_csv,
        #     sheet = "Attendees") |>
        #     dplyr::mutate(
        #         name = paste(`First Name`, Surname, sep = " "),
        #         email = tolower(Email)
        #     )
        # invite_col <- grep("Invite?", names(attendee_list))
        # invited <- sapply(attendee_list[[invite_col]], isTRUE)
        # attendee_list <- attendee_list[invited, ]

        # email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = "Blocked emails") |>
        #     dplyr::filter(!is.na(Email) & Email != "")

        registered <- googlesheets4::read_sheet(invite_list_csv,
            sheet = "Registrations") |>
            dplyr::mutate(
                name = paste(`First Name`, Surname, sep = " "),
                email = tolower(Email)
            )

        # remove registered and invited from attendee_list
        # backup_list <- attendee_list[!(attendee_list$email %in% registered$email),]
        # backup_list <- backup_list[!(backup_list$name %in% registered$name),]

        # backup_list <- dplyr::mutate(backup_list,
        #     invited = email %in% invite_list$email | name %in% invite_list$Name
        # )

        # # bad_emails <- googlesheets4::read_sheet(invite_list_csv,
        # #     sheet = "Bad emails")


        # # already sent
        sent <- readr::read_csv("email_results.csv") |>
            dplyr::filter(sent)

        # email_list <- email_list[email_list$Email %in% sent$email, ]

        # # remove registered from email_list
        email_list <- invite_list
        email_list <- email_list[!(email_list$email %in% registered$email),]
        email_list <- email_list[!(email_list$Name %in% registered$name),]

        # remove bad emails
        # email_list <- email_list[!(email_list$Email %in% bad_emails[["Bad email"]]),]

        # find column starting with 'Invite?' and select all rows where value is TRUE
        # invite_col <- grep("Invite?", names(email_list))
        # email_list <- email_list[email_list[[invite_col]], ]

        ## Invite from 'Individuals to invite' sheet
        # email_list <- googlesheets4::read_sheet(invite_list_csv,
        #     sheet = "Individuals to invite") |>
        #     dplyr::mutate(email = tolower(Email), invited = `Invite sent`) |>
        #     dplyr::filter(!invited)
    } else if (EMAIL == "individual_invite") {
        ## Invite from 'Individuals to invite' sheet
        # email_list <- googlesheets4::read_sheet(invite_list_csv,
        #     sheet = "Individuals to invite") |>
        #     dplyr::mutate(email = tolower(Email), invited = `Invite sent`) |>
        #     dplyr::filter(!invited & !is.na(Email))

        invite_list <- googlesheets4::read_sheet(invite_list_csv,
            sheet = "Workshop Attendees") |>
            dplyr::select(1:3) |>
            dplyr::filter(!is.na(Email)) |>
            dplyr::mutate(
                email = tolower(Email),
                invite = ifelse(is.na(Invite), "yes", Invite)
            ) |>
            dplyr::filter(invite != "No")

        registered <- googlesheets4::read_sheet(invite_list_csv,
            sheet = "Registrations") |>
            dplyr::mutate(
                first_name = `First Name`,
                email = tolower(Email),
                name = paste(first_name, Surname, sep = " ")
            ) |>
            dplyr::filter(!is.na(email))

        email_list <- invite_list
        email_list <- email_list[!(email_list$email %in% registered$email),]
        email_list <- email_list[!(email_list$Name %in% registered$name),]
    } else if (EMAIL == "confirmation") {
        subject <- "Registration Confirmation - Symposium March 9 2023"
        registered_list <- googlesheets4::read_sheet(invite_list_csv,
            sheet = "Registrations") |>
            dplyr::mutate(
                first_name = `First Name`,
                email = tolower(Email)
            ) |>
            dplyr::filter(!is.na(email))


        # email results
        confirmed_emails  <- list.files(".", "email_results_.+.csv") |>
            purrr::map(readr::read_csv) |>
            purrr::map_dfr(~ .x |>
                dplyr::select(email)) |>
                dplyr::pull(email) |> unique() |> tolower()

        email_list <- registered_list |>
            dplyr::select(first_name, Email, email) |>
            dplyr::filter(!email %in% confirmed_emails)
    } else if (EMAIL == "guest_info") {
        subject <- "Important information for upcoming symposium - 9th March 2023"
        registered_list <- googlesheets4::read_sheet(
                attendee_list_csv,
                sheet = "attendee_list",
                skip = 1L
            ) |>
            dplyr::filter(!is.na(email) & symposium) |>
            dplyr::mutate(email = tolower(email)) |>
            dplyr::select(
                first_name, surname, email, organisation, contact_number,
                dietary_requirements, special_requirements
            )

        sent_emails  <- list.files(".", "email_guestinfo_.+.csv") |>
            purrr::map(readr::read_csv) |>
            purrr::map_dfr(~ .x |>
                dplyr::select(email)) |>
                dplyr::pull(email) |> unique() |> tolower()

        email_list <- registered_list |>
            dplyr::filter(!email %in% sent_emails)

        # email_list <- registered_list

        # email_list <- email_list |>
            # dplyr::filter(email == "tom.elliott@auckland.ac.nz")
    }

    # subject <- gsub("Invitation to Register", "Registration reminder", subject)

    cat(email_list$email, sep = ", ")
    message(sprintf("\nYou are about to send this email to %i people. Are you sure? (y/N)", nrow(email_list)))

    if (tolower(readline()) == "y") {
        emails <- email_list$email
        # emails <- "tom.elliott@auckland.ac.nz"
    } else {
        email <- ""
        stop()
    }
} else {
    message("This is a test run. Set CONFIRM=TRUE to send emails to the list.")
    subject <- paste("[Testing mailer]", subject)

    if (EMAIL == "confirmation") {
        subject <- "Registration Confirmation - Symposium March 9 2023"
        email_list <- tibble::tribble(
            ~first_name, ~email,
            # "Colin", "colin.simpson@vuw.ac.nz"
            # "a.sporle@auckland.ac.nz",
            # "b.milne@auckland.ac.nz",
            # "robin.blythe@qut.edu.au",
            # "Louise.Pirini@swa.govt.nz",
            "Tom NZ", "tomelliottnz@gmail.com",
            "Tom", "tom.elliott@auckland.ac.nz"
        )
        emails <- email_list$email
    } else {
        emails <- c("tom.elliott@auckland.ac.nz")
    }

    message("Sending to: ", paste(emails, collapse = ", "))
}

send_email_to <- function(email, vars = NULL) {

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
    if (!is.null(vars)) {
        json_template$variables <- list(
            list(
                email = jsonlite::unbox(email),
                substitutions =
                    lapply(names(vars),
                        \(x) list(
                            var = jsonlite::unbox(x),
                            value = jsonlite::unbox(vars[[x]])
                        )
                    )

            )
        )
    }

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

if (EMAIL == "guest_info") {
    res <- sapply(seq_along(email_list$email),
        \(i) send_email_to(
            email_list$email[i],
            vars = list(
                first_name = email_list$first_name[i],
                last_name = email_list$surname[i],
                organisation = gsub("\\n", "<br/>", email_list$organisation[i]),
                contact_number = ifelse(
                    is.na(email_list$contact_number[i]),
                    "Not supplied",
                    email_list$contact_number[i]
                ),
                dietary_requirements = ifelse(
                    is.na(email_list$dietary_requirements[i]),
                    "None",
                    email_list$dietary_requirements[i]
                ),
                special_requirements = ifelse(
                    is.na(email_list$special_requirements[i]),
                    "None",
                    email_list$special_requirements[i]
                )
            )
        )
    )
    res <- data.frame(email = email_list$email, sent = res)
    readr::write_csv(res, sprintf("email_guestinfo_%s.csv", Sys.time()))
} else if (EMAIL == "confirmation") {
    res <- sapply(seq_along(email_list$email),
        \(i) send_email_to(
            email_list$email[i],
            vars = list(first_name = email_list$first_name[i])
        )
    )
    res <- data.frame(email = email_list$email, sent = res)
    readr::write_csv(res, sprintf("email_results_%s.csv", Sys.time()))
} else if (EMAIL == "registration_invitation") {
    res <- sapply(emails, send_email_to)
    res <- data.frame(email = emails, sent = res)
    if (exists("sent") && nrow(sent))
        res <- dplyr::bind_rows(sent, res)
    readr::write_csv(res, "email_results.csv")
} else {
    sapply(emails, send_email_to)
}
