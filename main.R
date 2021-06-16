# Load libraries
library("networkD3")
library("dplyr")
library("tibble")
library("webshot")

links <-
  tribble(
    ~ source, ~ target, ~ value,
    "Jobs applied to", "Initial reply", 10,
    "Jobs applied to", "Rejected", 12,
    "Jobs applied to", "No response", 23,
    "Initial reply", "First interview", 9,
    "Initial reply", "Coding task", 1,
    "First interview", "Coding task", 4,
    "First interview", "Rejected", 2,
    "First interview", "Job postponed", 1,
    "First interview", "Second interview", 2,
    "Coding task", "Rejected", 2,
    "Coding task", "First interview", 1,
    "Coding task", "Panel/Presentation", 4,
    "Panel/Presentation", "Second interview", 2,
    "Panel/Presentation", "Rejected", 1,
    "Panel/Presentation", "Offer recieved", 1,
    "Second interview", "Offer recieved", 1,
    "Second interview", "Coding task", 1,
    "Networking", "First interview", 2,
    "Networking", "Recruiter", 3,
    "Networking", "Offer recieved", 1,
    "Recruiter", "Coding task", 1,
    "Recruiter", "Rejected", 3,
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
