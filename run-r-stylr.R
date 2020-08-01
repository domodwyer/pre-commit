#!/usr/bin/env Rscript

files <- commandArgs(trailingOnly=TRUE)
tryCatch(
  {
    styler::style_file(files)
  }, 
  warning = function(w) stop(conditionMessage(w), call. = FALSE)
)