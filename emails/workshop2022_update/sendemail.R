e <- paste(readLines('email.txt'), collapse = "\n")
txt <- paste(readLines('index.txt'), collapse = "\n")
html <- paste(readLines('index.html'), collapse = "\n")

# library(dotenv)
# invite_list_csv <- Sys.getenv("GOOGLE_SHEET")
# email_list <- googlesheets4::read_sheet(invite_list_csv, sheet = 4L) |>
#     dplyr::filter(!Sent & Email != "")

email_list <- data.frame(Email = c("tom.elliott@auckland.ac.nz"))
emails <- paste(email_list$Email, collapse = ", ")
# emails <- ""

message("MAKE SURE YOU DO THE TEXT VERSION ONCE FINALISED!!")

e <- gsub("%EMAILS%", emails, e, fixed = TRUE)
e <- gsub("%TEXT%", txt, e, fixed = TRUE)
e <- gsub("%HTML%", html, e, fixed = TRUE)
cat(e, "\n", file = "tosend.txt")

cat("Sending mail ...\n")
# system('cat tosend.txt | sendmail -t')
cat("\nDone!\n")
