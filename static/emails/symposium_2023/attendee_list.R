library(dotenv)

invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
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

attendees <- dplyr::bind_rows(symposium_list, workshop_list)

readr::write_csv(attendees,
    "~/Downloads/attendee_list.csv",
    na = ""
)
