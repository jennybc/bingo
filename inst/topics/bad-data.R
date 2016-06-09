# Inspired by the \href{https://github.com/Quartz/bad-data-guide}{Quartz Guide
# to Bad Data}. Identifies bad data smells that should make you extremely
# vigilant in your cleaning and sanity checks.
c(
  "Blank/null values aren't explained",
  "Data that \"must exist\" does not, in fact, exist",
  "Data that \"cannot exist\" does, in fact, exist",
  "Duplicate rows",
  "Metric? Imperial? Ask the dust ...",
  "65,535 or 2,147,483,647 or 4,294,967,295",
  "555-3485 or 867-5309",
  "1970-01-01\nT00:00:00Z or 1969-12-31\nT23:59:59Z",
  "January 1st, 1900 or January 1st, 1904",
  "Data is \"helpfully\" pre-aggregated",
  "Aggregates and computed totals don't match",
  "Line ending chaos ... \\n vs \\r\\n vs \\r",
  "Yo, I hear you like metadata mixed with your data",
  "Spreadsheet has exactly 65,536 rows",
  "Missing data that passes for real data, eg 0 or 99",
  "Leading zeroes stripped to convert text to numbers",
  "Inexplicable outliers",
  ## this does not work well with grid and PDF
  ## http://stackoverflow.com/questions/28746938/ggsave-losing-unicode-charaters-from-ggplotgridextra
  #"\uFFFD\uFFFD\uFFFD Mojibake \uFFFD\uFFFD\uFFFD",
  "Garbled text suggests encoding problems",
  "Data disguised as formatting",
  "Ambiguous American date formats, eg 03/04/16",
  "\"Virgin Birth\", ie no provenance",
  "Location of 0\u00B0N 0\u00B0E, ie \"Null Island\"",
  "Spelling mistakes that reek of hand-typed data",
  "US zip codes 12345 or 90210"
)
