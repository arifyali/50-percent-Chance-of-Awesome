#https://solomonmessing.wordpress.com/2012/09/30/working-with-bipartiteaffiliation-network-data-in-r/

#Used igraph, as suggested from class and in the materials posted on the web.
library(igraph)

#Change the root to the location of the repository in order to run the program.
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")

#Load the data that will be subset for the network analysis.
baseData <- read.csv(paste0(root,
                            "part2_exploratory_analysis/PoldataSPIndustries.csv"),
                     stringsAsFactors = FALSE)

#Reduce data to iformation that will be fed to the network.
#Since we should try to make a small network, and the cluster command wll stall 
#with too many nodes, we decided to analyze a logical subset of the data that 
#had the potential to show interesting results.
#
#Subset for only winners of senate elections in 2014 and the top two industries 
#that supported them.
candIndOnly <- baseData[baseData$WINNER==1 & 
                          (baseData$indrank %in% c(1,2)) &
                          baseData$YEAR==2014 & 
                          baseData$DISTRICT=="S",
                        c("CANDIDATE","PRIMARY.INDUSTRY")]

#THESE COMMENTED OUT COMMANDS ARE OTHER NETWORKS THAT WERE TRIED
# #Test original data set
# openRepo <- "part2_exploratory_analysis/openSecrets/"
# 
# openS <- read.csv(paste0(root,openRepo,"FundingCongress_cleaned.csv"),
#                   stringsAsFactors=FALSE,
#                   strip.white=TRUE)
# 
# names(openS)[names(openS)=="Industry"] <- "PRIMARY.INDUSTRY"
# names(openS)[names(openS)=="Name"] <- "CANDIDATE"
# 
# topIndPer <- aggregate(openS$industrypercent,
#                        list(openS$State, 
#                             openS$District, 
#                             openS$Year, 
#                             openS$CANDIDATE),
#                        max)
# names(topIndPer) <- c("State","District","Year","CANDIDATE","industrypercent")
# candIndOnly1st <- merge(openS,topIndPer,by=c("State","District","Year","CANDIDATE","industrypercent"),all.y=TRUE)
# candIndOnly1st <- candIndOnly1st[!(duplicated(candIndOnly1st[,c("State","District","Year","CANDIDATE")])),]
# 
# candIndOnly <- merge(openS,topIndPer,by=c("State","District","Year","CANDIDATE","industrypercent"),all.x=TRUE)
# topIndPer <- aggregate(candIndOnly$industrypercent,
#                        list(candIndOnly$State, 
#                             candIndOnly$District, 
#                             candIndOnly$Year, 
#                             candIndOnly$CANDIDATE),
#                        max)
# names(topIndPer) <- c("State","District","Year","CANDIDATE","industrypercent")
# candIndOnly <- merge(candIndOnly,topIndPer,by=c("State","District","Year","CANDIDATE","industrypercent"),all.y=TRUE)
# candIndOnly <- candIndOnly[!(duplicated(candIndOnly[,c("State","District","Year","CANDIDATE")])),]
# candIndOnly <- rbind(candIndOnly1st,candIndOnly)
# 
# 
# candIndOnly <- candIndOnly[candIndOnly$Year==2014 & candIndOnly$District %in% c("S1","S2"),
#                      c("CANDIDATE","PRIMARY.INDUSTRY")]
# 
# candIndOnly <- candIndOnly

#Try binning the stock data items and then using those with candidates.
# stockVersion <- read.csv(paste0(root,"part2_exploratory_analysis/PoldataSPIndustriesStockData no outliers.csv"),
#                 stringsAsFactors=FALSE,
#                 strip.white=TRUE)
# #Bin it
# stockVersion$YrPercentBin <- 0
# stockVersion$YrPercentBin[stockVersion$YrPercentChange >= 0.6] <- 4
# stockVersion$YrPercentBin[stockVersion$YrPercentChange >= 0.3 & stockVersion$YrPercentChange < 0.6] <- 3
# stockVersion$YrPercentBin[stockVersion$YrPercentChange >= 0 & stockVersion$YrPercentChange < 0.3] <- 2
# stockVersion$YrPercentBin[stockVersion$YrPercentChange < 0] <- 1
# stopifnot(stockVersion$YrPercentBin!=0)
# 
# candIndOnly <- stockVersion[stockVersion$WINNER==1 & 
#                               stockVersion$YEAR==2012 & 
#                               stockVersion$DISTRICT!="S",
#                             c("CANDIDATE","YrPercentBin","CANDTOTAL")]
# candIndOnly <- candIndOnly[candIndOnly$CANDTOTAL > median(candIndOnly$CANDTOTAL),]
# candIndOnly <- candIndOnly[candIndOnly$CANDTOTAL > median(candIndOnly$CANDTOTAL),]
# candIndOnly <- candIndOnly[candIndOnly$CANDTOTAL > median(candIndOnly$CANDTOTAL),]
# candIndOnly <- candIndOnly[,c("CANDIDATE","YrPercentBin")]


#Create Incidence matrix
matInc <- as.matrix(table(candIndOnly))

#Convert bimodal incidence matrix to unimodal adjacency matrix
adjacency <- tcrossprod(matInc)
stopifnot(nrow(adjacency)==ncol(adjacency))
for (i in 1:nrow(adjacency)) {
  adjacency[i,i] <- 0
}

#Generate graph object from the adjacency matrix.
g1 <- graph.adjacency(adjacency,mode="undirected")


# Degree
degree = degree(g1, mode="out")
V(g1)$degree <- degree
V(g1)$meanDegree <- mean(V(g1)$degree)
hist(V(g1)$degree)

# Betweenness
betweeness = betweenness(g1, directed = FALSE)
V(g1)$betweeness <- betweeness
V(g1)$meanBetweeness <- mean(V(g1)$betweeness)

# Clustering coefficient
clusteringCoef = transitivity(g1, type=c("local"))
V(g1)$clusteringCoef <- clusteringCoef
V(g1)$meanClusteringCoef <- mean(V(g1)$clusteringCoef)

# Graph Density
g1$density <- graph.density(g1)

# Graph diameter
g1$diameter = diameter(g1)

# number of components
g1$components <- components(g1,mode="strong")

# the size of the largest k-core
g1$largestKcore <- max(graph.coreness(g1))

# Use edge-betweeness algorithm to generate clusters
myClusters <- edge.betweenness.community(g1)

# Print cluster number for each vertex
myClusters

# Create a color attribute value for each vertex that assigns the cluster number
# plus 1 to the color attribute
V(g1)$color <- myClusters$membership+1

# Select a layout. Plot the clusters with labels. Plot the clusters
# without labels (second one).
g1 <- set.graph.attribute(g1, "layout", layout.fruchterman.reingold(g1))
plot(g1)
plot(g1, vertex.label=NA)

# Using modularity to generate clusters
g1 <- simplify(g1, remove.multiple = TRUE)
fgreedy<-cluster_fast_greedy(g1,merges=TRUE, modularity=TRUE)
myModClusters <-cut_at(fgreedy, steps=which.max(fgreedy$modularity)-1)

# Print cluster information
myModClusters

# Make print outs nicer
print(paste('Number of detected communities=',length(myModClusters)))
# Community sizes:
print(myModClusters)
# modularity:
max(fgreedy$modularity)

# Set vertex variable to cluster number plus 1.
V(g1)$color <- myModClusters+1

# Plot
g1 <- set.graph.attribute(g1, "layout", layout.kamada.kawai(g1))
plot(g1)
plot(g1, vertex.label=NA)
