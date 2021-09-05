url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSN-4DS9lMPsGT5G7Tk9poHDepLaI2g7u5uWsLj6vzBBY9ht6TMYJpe_cbS0NBEhKvujRleDOz8Zus4/pub?gid=2114638384&single=true&output=csv"

outcomes <- readr::read_csv(url, show_col_types = FALSE)[,1:9] |>
    setNames(c("type", "report_year", "date", "authors", "title", "where", "link", "comments", "added")) |>
    dplyr::filter(is.na(added) & !is.na(date)) |>
    dplyr::mutate(date = lubridate::dmy(date))

matches <- list(
    "andrew" = "Sporle",
    "barry" = "Milne",
    "colin" = "Simpson",
    "binh" = "Nguyen B"
)
slugify <- function(x, alphanum_replace="", space_replace="-", tolower=TRUE) {
  x <- gsub("[^[:alnum:] ]", alphanum_replace, x)
  x <- gsub(" ", space_replace, x)
  if(tolower) { x <- tolower(x) }

  return(x)
}
template <- readLines("scripts/template.md")
for (i in seq_len(nrow(outcomes))) {
    oi <- outcomes[i,]
    title <- oi$title
    date <- as.character(oi$date)
    team <- gsub("\\.", "", strsplit(oi$authors, ",")[[1]] |> trimws())
    for (j in seq_along(matches)) {
        m <- grep(matches[[j]], team)
        if (length(m)) team[[m]] <- names(matches)[j]
    }
    team[!team %in% names(matches)] <- sprintf("\"%s\"", team[!team %in% names(matches)])
    team <- paste("-", team, collapse = "\n")
    link <- oi$link
    description <- oi$where
    writeLines(
        glue::glue(paste(template, collapse = "\n")),
        file.path(
            "content",
            "outputs",
            paste0(slugify(strsplit(tolower(title), "\\,|:")[[1]][[1]]), ".md")
        )
    )
}
