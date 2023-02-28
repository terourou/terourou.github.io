library(dotenv)

invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
attendee_list_csv <- Sys.getenv("GOOGLE_SHEET_ATTENDEES")
symposium_list <-
    googlesheets4::read_sheet(
        invite_list_csv,
        sheet = "Registrations"
    ) |>
    dplyr::mutate(
        first_name = `First Name`,
        surname = Surname,
        email = tolower(Email),
        organisation = `Organisation or Affiliation`,
        contact_number = `Mobile number`,
        dietary_requirements = `Dietary requirements`,
        special_requirements = `Special requirements`,
        symposium = TRUE
    ) |>
    dplyr::select(
        first_name, surname, email, organisation, contact_number,
        dietary_requirements, special_requirements
    ) |>
    # remove duplicate email
    dplyr::distinct(first_name, surname, .keep_all = TRUE)

workshop_list <-
    googlesheets4::read_sheet(
        invite_list_csv,
        sheet = "Workshop Attendees"
    ) |>
    dplyr::mutate(
        name = Name,
        email = tolower(Email),
        organisation = `Organisation / affiliation`,
        invite = Invite,
        symposium = `Attending\nSymposium`,
        invited = `Invited to \nWorkshop`,
        accepted = `Accepted`
    ) |>
    dplyr::filter(invited) |>
    dplyr::select(
        name, email, organisation
    ) |>
    dplyr::filter(is.na(email) | !email %in% symposium_list$email)

attendee_list <-
    googlesheets4::read_sheet(
        attendee_list_csv,
        sheet = "attendee_list",
        skip = 1L
    )

# find duplicate attendees
n <- attendee_list$email |> table()
n[n > 1]

# find missing attendees
sym_att <- attendee_list |> dplyr::filter(symposium)
ws_att <- attendee_list |> dplyr::filter(workshop)

symposium_list[!symposium_list$email %in% sym_att$email, ]
workshop_list[!workshop_list$email %in% ws_att$email, ]

# any incorrect
symo_list <- sym_att |> dplyr::filter(!workshop)
wso_list <- ws_att |> dplyr::filter(!symposium)
symo_list[!symo_list$email %in% symposium_list$email, ]
wso_list[!wso_list$email %in% workshop_list$email, ]
