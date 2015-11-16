#https://solomonmessing.wordpress.com/2012/09/30/working-with-bipartiteaffiliation-network-data-in-r/

root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")

baseData <- read.csv(paste0(root,
                            "part2_exploratory_analysis/PoldataSPIndustries.csv"),
                     stringsAsFactors = FALSE)
#Remove column X
candIndOnly <- baseData[baseData$WINNER==1 & 
                          (baseData$indrank %in% c(1)) &
                          baseData$YEAR==2014 & 
                          baseData$DISTRICT=="S",
                        c("CANDIDATE","PRIMARY.INDUSTRY")]
testdata <- candIndOnly

#Create Incidence matrix
matInc <- as.matrix(table(testdata))

#Convert bimodal incidence matrix to unimodal adjacency matrix
adjacency <- tcrossprod(matInc)
stopifnot(nrow(adjacency)==ncol(adjacency))
for (i in 1:nrow(adjacency)) {
  adjacency[i,i] <- 0
}

g1 <- graph.adjacency(adjacency,mode="undirected")

# Vertices
nbrVertices = vcount(g1)
g1$nbrVertices = nbrVertices

# Edges
nbrEdges = ecount(g1)
g1$nbrEdges = nbrEdges

# Diameter
diameter = diameter(g1)
g1$diameter = diameter

# Global clustering coefficient
globalClusteringCoef = clusteringCoef = transitivity(g1, type=c("global"))
g1$globalClusteringCoef = globalClusteringCoef

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

# # Using modularity to generate clusters
# fgreedy<-cluster_fast_greedy(g1,merges=TRUE, modularity=TRUE)
# myModClusters <-cut_at(fgreedy, steps=which.max(fgreedy$modularity)-1)
# 
# # Print cluster information
# myModClusters
# 
# # Make print outs nicer
# print(paste('Number of detected communities=',length(myModClusters)))
# # Community sizes:
# print(myModClusters)
# # modularity:
# max(fgreedy$modularity)
# 
# # Set vertex variable to cluster number plus 1.
# V(g1)$color <- myModClusters+1
# 
# # Plot
# g1 <- set.graph.attribute(g1, "layout", layout.kamada.kawai(g1))
# plot(g1)
# plot(g1, vertex.label=NA)
