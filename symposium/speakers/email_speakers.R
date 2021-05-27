content <- paste(readLines("email.txt"), collapse = "\n")
content <- paste(content, "\n\n")

authors <- list.files(pattern = "*\\.md")
authors <- authors[!grepl("template", authors)]
get_file <- function(f) {
    md <- readLines(f)
    yaml <- grep("^---", md)
    d <- yaml::read_yaml(text = md[(yaml[1]+1):(yaml[2]-1)])
    d$summary <-
        gsub("^[\n]*", "", paste(md[-(1:yaml[2])], collapse = "\n"))
    d
}
files <- lapply(authors, get_file)

subject <- "Programme Update for Speakers - Innovations in Applied Data Symposium"
emails <- paste(do.call(c, lapply(files, function(x) x$email)), collapse = ",")
from <- "tom.elliott@vuw.ac.nz"
cc <- "nicky@tomdickandharry.org.nz"

system(glue::glue("thunderbird -compose \"subject='{subject}',from='{from}',cc='{cc}',bcc='{emails}',body='{content}'\""))
