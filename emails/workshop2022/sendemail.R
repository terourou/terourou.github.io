e <- paste(readLines('email.txt'), collapse = "\n")
txt <- paste(readLines('index.txt'), collapse = "\n")
html <- paste(readLines('index.html'), collapse = "\n")

e <- gsub("%TEXT%", txt, e, fixed = TRUE)
e <- gsub("%HTML%", html, e, fixed = TRUE)
cat(e, "\n", file = "tosend.txt")

message("Remember to use 'https://htmlcrush.com/light/' first ...")

cat("Sending mail ...\n")
system('cat tosend.txt | sendmail -t')
cat("\nDone!\n")
