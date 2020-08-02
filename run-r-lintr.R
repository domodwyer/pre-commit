#!/usr/bin/env Rscript

files <- commandArgs(trailingOnly=TRUE)
tryCatch(
  {
    for (f in files) {
      lintr::lint(f)
    }
  }, 
  warning = function(w) stop(conditionMessage(w), call. = FALSE)
)