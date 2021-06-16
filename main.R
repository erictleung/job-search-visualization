# Load libraries
library("networkD3")
library("dplyr")
library("tibble")
library("webshot")

links <-
  tribble(
    ~ source, ~ target, ~ value,
    "Jobs applied to", "Initial reply", 11,
    "Jobs applied to", "Rejected", 11,
    "Jobs applied to", "No response", 24,
    "Initial reply", "Coding task", 2,
    "Initial reply", "First interview", 0,
    "First interview", "Coding task", 3,
    "First interview", "Second interview", 4,
    "First interview", "Job postponed", 1,
    "Coding task", "First interview", 1,
    "Second interview", "Third interview", 3,
    "Second interview", "Offer recieved", 1,
    "Third interview", "Offer recieved", 1,
    "Networking", "First interview", 2,
    "Networking", "Recruiter", 2,
    "Recruiter", "Coding task", 1,
    "Recruiter", "Rejected", 1,
    "Offer recieved", "Offer accepted", 1
  )

# From these flows we need to create a node data frame: it lists every entities
# involved in the flow
nodes <- data.frame(name = c(as.character(links$source),
                             as.character(links$target)) %>% unique())

# With networkD3, connection must be provided using id, not using real name like
# in the links dataframe. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name) - 1
links$IDtarget <- match(links$target, nodes$name) - 1

# Make the Network
p <-
  sankeyNetwork(
    Links = links,
    Nodes = nodes,
    Source = "IDsource",
    Target = "IDtarget",
    Value = "value",
    NodeID = "name",
    fontSize = 12,
    sinksRight = FALSE
  )
p

# Save out results
saveNetwork(p, "sankey-job-search.html")
webshot("sankey-job-search.html",
        file = "sankey-job-search.png",
        delay = 2)
