#!/usr/bin/env Rscript

files <- commandArgs(trailingOnly=TRUE)
stop <- FALSE
tryCatch(
  {
    for (f in files) {
      errors <- lintr::lint(f)
      if (length(errors) > 0) {
        print(errors)
        stop <- TRUE
      } 
    }
  }, 
  warning = function(w) stop(conditionMessage(w), call. = FALSE)
)
if (stop) {
  stop("lintr failures found")
}