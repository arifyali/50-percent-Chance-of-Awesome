###########################
# Basic Social Network Analysis
#
# Compute various metrics on political books social network
###########################

# Libraries
library(igraph)

# Set working directory
setwd('C:/Users/John/Desktop')

###########################
# Read in graph and summarize
###########################
dGraph = read.graph("polbooks.gml", format="gml")
summary(dGraph)

# If you want to make the labels another attribute
# V(dGraph)$label <- V(dGraph)$id

############################
# Compute network stats
# Avg, quartiles, std, cdf
############################
# Vertices
nbrVertices = vcount(dGraph)
dGraph$nbrVertices = nbrVertices

# Edges
nbrEdges = ecount(dGraph)
dGraph$nbrEdges = nbrEdges

# Diameter
diameter = diameter(dGraph)
dGraph$diameter = diameter

# Global clustering coefficient
globalClusteringCoef = clusteringCoef = transitivity(dGraph, type=c("global"))
dGraph$globalClusteringCoef = globalClusteringCoef

# Triad census (only works for directed graphs)
triad = triad.census(dGraph)
dGraph$triad = triad

#########################
# Other genneral stats that may not work wit large data set
#########################
# Largest Clique and a plot of it using a new graph
# (Difficult for r to do on full dolphin graph
lc <- largest.cliques(dGraph)
lc
# create a new graph of the largest clique
dGraph.lc <- subgraph(dGraph, lc[[1]])

# Create  the file that will save the plot, then create the plot. After 
# it is created, call dev.off() to make sure the complete plot is written
# to the file.
png(filename = "lc.png")
plot(dGraph.lc, layout=layout.fruchterman.reingold, vertex.color="gray60", vertex.size = 0, edge.arrow.size = 0.5, edge.color = "gray80")
dev.off()

############################
# Compute centrality stats
############################
# Betweenness
betweeness = betweenness(dGraph, directed = FALSE)
V(dGraph)$betweeness <- betweeness
V(dGraph)$rankBetweeness <- rank(V(dGraph)$betweeness, ties.method= "min")

# Closeness
closeness = closeness(dGraph, mode="out")
V(dGraph)$closeness <- closeness
V(dGraph)$rankCloseness <- rank(V(dGraph)$closeness, ties.method= "min")

# Degree
degree = degree(dGraph, mode="out")
V(dGraph)$degree <- degree
V(dGraph)$rankDegree <- rank(V(dGraph)$degree, ties.method= "min")

# Hub and authority scores (Kleinberg) will be the same for undirected graphs
hub = hub.score(dGraph)$vector
V(dGraph)$hub <- hub
V(dGraph)$rankHub <- rank(V(dGraph)$hub, ties.method= "min")

# Eigenvector centrality
eigenvector = evcent(dGraph)
x = eigenvector$vector
V(dGraph)$eigenvector <- x
V(dGraph)$rankEigenvector <- rank(x, ties.method= "min")

# Pagerank
pageRank = page.rank(dGraph)$vector
V(dGraph)$pageRank <- pageRank
V(dGraph)$rankPageRank <- rank(V(dGraph)$pageRank, ties.method= "min")

# Clustering coefficient
clusteringCoef = transitivity(dGraph, type=c("local"))
V(dGraph)$clusteringCoef <- clusteringCoef
V(dGraph)$rankClusteringCoef <- rank(V(dGraph)$clusteringCoef, ties.method= "min")

#############################
# Compute means, stds, 1st quartile, 3rd quartile, max, min, skew
############################
dGraph$meanBetweeness = mean(betweeness)
dGraph$meanCloseness = mean(closeness)
dGraph$meanDegree = mean(degree)
dGraph$meanHub = mean(hub)
dGraph$meanEigenvector = mean(eigenvector$vector)
dGraph$meanPageRank = mean(pageRank)
dGraph$meanClusteringCoef = mean(clusteringCoef)

dGraph$medianBetweeness = median(betweeness)
dGraph$medianCloseness = median(closeness)
dGraph$medianDegree = median(degree)
dGraph$medianHub = median(hub)
dGraph$medianEigenvector = median(eigenvector$vector)
dGraph$medianPageRank = median(pageRank)
dGraph$medianClusteringCoef = median(clusteringCoef)

dGraph$stdBetweeness = sd(betweeness)
dGraph$stdCloseness = sd(closeness)
dGraph$stdDegree = sd(degree)
dGraph$stdHub = sd(hub)
dGraph$stdEigenvector = sd(eigenvector$vector)
dGraph$stdPageRank = sd(pageRank)
dGraph$stdClusteringCoef = sd(clusteringCoef)

dGraph$quantileBetweeness = quantile(betweeness)
dGraph$quantileCloseness = quantile(closeness)
dGraph$quantileDegree = quantile(degree)
dGraph$quantileHub = quantile(hub)
dGraph$quantileEigenvector = quantile(eigenvector$vector)
dGraph$quantilePageRank = quantile(pageRank)
dGraph$quantileClusteringCoef = quantile(clusteringCoef)

dGraph$minBetweeness = min(betweeness)
dGraph$minCloseness = min(closeness)
dGraph$minDegree = min(degree)
dGraph$minHub = min(hub)
dGraph$minEigenvector = min(eigenvector$vector)
dGraph$minPageRank = min(pageRank)
dGraph$minClusteringCoef = min(clusteringCoef)

dGraph$maxBetweeness = max(betweeness)
dGraph$maxCloseness = max(closeness)
dGraph$maxDegree = max(degree)
dGraph$maxHub = max(hub)
dGraph$maxEigenvector = max(eigenvector$vector)
dGraph$maxPageRank = max(pageRank)
dGraph$maxClusteringCoef = max(clusteringCoef)

dGraph$IQRBetweeness = IQR(betweeness)
dGraph$IQRCloseness = IQR(closeness)
dGraph$IQRDegree = IQR(degree)
dGraph$IQRHub = IQR(hub)
dGraph$IQREigenvector = IQR(eigenvector$vector)
dGraph$IQRPageRank = IQR(pageRank)
dGraph$IQRClusteringCoef = IQR(clusteringCoef)


#############################
# Write out network stats, vertex metrics, and graphml file
#############################
vertexDat<-cbind(V(dGraph)$id, V(dGraph)$betweeness, V(dGraph)$closeness, V(dGraph)$degree, V(dGraph)$hub, V(dGraph)$eigenvector, V(dGraph)$boncich, V(dGraph)$burtConstraint, V(dGraph)$pageRank, V(dGraph)$clusteringCoef)
vertexRankDat<-cbind(V(dGraph)$id, V(dGraph)$rankBetweeness, V(dGraph)$rankCloseness, V(dGraph)$rankDegree, V(dGraph)$rankHub, V(dGraph)$rankEigenvector, V(dGraph)$rankPageRank, V(dGraph)$rankClusteringCoef)

# Write Vertext Data
write.table(vertexDat, file="dGraphVertexStats.txt", sep="\t",append=F)
write.table(vertexRankDat, file="dGraphVertexRankStats.txt", sep="\t",append=F)

# Set graph id
dGraph$id = "dGraphNetwork"

# Write network data and graph data
networkDat<-cbind(dGraph$id, dGraph$nbrVertices, dGraph$nbrEdges, dGraph$diameter, dGraph$globalClusteringCoef, dGraph$meanBetweeness, dGraph$meanCloseness, dGraph$meanDegree, dGraph$meanHub, dGraph$meanEigenvector,  dGraph$meanPageRank, dGraph$meanClusteringCoef, dGraph$medianBetweeness, dGraph$medianCloseness, dGraph$medianDegree, dGraph$medianHub,  dGraph$medianPageRank, dGraph$medianClusteringCoef, dGraph$stdBetweeness, dGraph$stdCloseness, dGraph$stdDegree, dGraph$stdHub, dGraph$stdBurtConstraint, dGraph$stdPageRank, dGraph$stdClusteringCoef, dGraph$quantileBetweeness, dGraph$quantileCloseness, dGraph$quantileDegree, dGraph$quantileHub, dGraph$quantileBoncich, dGraph$quantileBurtConstraint, dGraph$quantilePageRank, dGraph$minBetweeness, dGraph$minCloseness, dGraph$minDegree, dGraph$minHub, dGraph$medianEigenvector, dGraph$skewEigenvector, dGraph$minEigenvector, dGraph$minBoncich, dGraph$minBurtConstraint, dGraph$minPageRank, dGraph$minClusteringCoef, dGraph$maxBetweeness, dGraph$maxCloseness, dGraph$maxDegree, dGraph$maxHub, dGraph$maxEigenvector, dGraph$maxBoncich, dGraph$maxBurtConstraint, dGraph$maxPageRank, dGraph$maxClusteringCoef, dGraph$IQRBetweeness, dGraph$IQRCloseness, dGraph$IQRDegree, dGraph$IQRHub, dGraph$IQREigenvector, dGraph$IQRBoncich, dGraph$IQRBurtConstraint, dGraph$IQRPageRank, dGraph$skewBetweeness, dGraph$skewCloseness, dGraph$skewDegree, dGraph$skewHub, dGraph$skewBoncich, dGraph$skewBurtConstraint, dGraph$skewPageRank, dGraph$skewClusteringCoef)
write.table(networkDat, file="dGraphNetworkStats.txt", sep="\t",append=F)
write.graph(dGraph, "myNetwork.txt", format=c("graphml"))

# Shows the nbr of vertices and edges. It also shows all the associated attributes.
summary(dGraph)

#############################
# Clusters
#############################

# Use edge-betweeness algorithm to generate clusters
myClusters <- edge.betweenness.community(dGraph)

# Print cluster number for each vertex
myClusters

# Create a color attribute value for each vertex that assigns the cluster number
# plus 1 to the color attribute
V(dGraph)$color <- myClusters$membership+1

# Select a layout. Plot the clusters with labels. Plot the clusters
# without labels (second one).
dGraph <- set.graph.attribute(dGraph, "layout", layout.kamada.kawai(dGraph))
plot(dGraph)
plot(dGraph, vertex.label=NA)

# Using modularity to generate clusters
fgreedy<-cluster_fast_greedy(dGraph,merges=TRUE, modularity=TRUE)
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
V(dGraph)$color <- myModClusters+1

# Plot
dGraph <- set.graph.attribute(dGraph, "layout", layout.kamada.kawai(dGraph))
plot(dGraph)
plot(dGraph, vertex.label=NA)

