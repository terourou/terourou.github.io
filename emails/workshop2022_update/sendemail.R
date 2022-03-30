e <- paste(readLines('email.txt'), collapse = "\n")
txt <- paste(readLines('index.txt'), collapse = "\n")
html <- paste(readLines('index.html'), collapse = "\n")

# library(dotenv)
# invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
# email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = 4L) |>
#     dplyr::filter()

# email_list <- data.frame(Email = c("a.sporle@auckland.ac.nz", "b.milne@auckland.ac.nz", "colinrsimpson@gmail.com", "tom.elliott@auckland.ac.nz", "Lucy.Nelson@swa.govt.nz"))
# email_list <- data.frame(Email = c("tom.elliott@auckland.ac.nz"))
# emails <- paste(email_list$Email, collapse = ", ")
emails <- ""

e <- gsub("%EMAILS%", emails, e, fixed = TRUE)
e <- gsub("%TEXT%", txt, e, fixed = TRUE)
e <- gsub("%HTML%", html, e, fixed = TRUE)
cat(e, "\n", file = "tosend.txt")

cat("Sending mail ...\n")
# system('cat tosend.txt | sendmail -t')
cat("\nDone!\n")
