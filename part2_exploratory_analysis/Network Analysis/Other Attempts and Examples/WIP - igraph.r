#https://solomonmessing.wordpress.com/2012/09/30/working-with-bipartiteaffiliation-network-data-in-r/

#==========Set-up==========#

#Used igraph, as suggested from class and in the materials posted on the web.
library(igraph)

#Change the root to the location of the repository in order to run the program.
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")




#==========Load data==========#

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

#Create Incidence matrix - this is bimodal with candidate and industry
matInc <- as.matrix(table(candIndOnly))

#Convert bimodal incidence matrix to unimodal adjacency matrix
adjacency <- tcrossprod(matInc)
stopifnot(nrow(adjacency)==ncol(adjacency))
for (i in 1:nrow(adjacency)) {
  adjacency[i,i] <- 0
}

#Generate graph object from the adjacency matrix.
#This graph object will have candidate nodes connected by industry edges.
g1 <- graph.adjacency(adjacency,mode="undirected")




#==========Calculate requested stats==========#

#Many items in this section were lifted from the SNA code that Lisa posted.

#Degree
V(g1)$degree <- degree(g1)
V(g1)$meanDegree <- mean(V(g1)$degree)
#Distribution of degree
hist(V(g1)$degree)

#Betweenness
V(g1)$betweeness <- betweenness(g1, directed = FALSE)
V(g1)$meanBetweeness <- mean(V(g1)$betweeness)

#Clustering coefficient
V(g1)$clusteringCoef <- transitivity(g1, type="local")
V(g1)$meanClusteringCoef <- mean(V(g1)$clusteringCoef)

#Graph Density
#Command Source: 
#http://www.inside-r.org/packages/cran/igraph/docs/graph.density
g1$density <- graph.density(g1)

#Graph diameter
g1$diameter <- diameter(g1)

#Number of components
#Command Source: http://igraph.org/r/doc/components.html
g1$components <- components(g1,mode="strong")

#Size of the largest k-core
#Command source: 
#http://www.inside-r.org/packages/cran/igraph/docs/graph.coreness
g1$largestKcore <- max(graph.coreness(g1))




#==========Create clustered plots==========#


#=====Edge-betweenness

#Use edge-betweeness algorithm to generate clusters
g1Clusters <- edge.betweenness.community(g1)

#Create a color attribute value for each vertex that assigns the cluster number
#plus 1 to the color attribute
V(g1)$color <- g1Clusters$membership+1

#Select a layout. Plot the clusters with labels. Plot the clusters
#without labels (second one).
g1 <- set.graph.attribute(g1, "layout", layout.fruchterman.reingold(g1))
plot(g1)
plot(g1, vertex.label=NA)


#=====Modularity

#Greedy algorithm will only work if the graph does not have multiple edges.  
#Unfortunately, our graph does not conform to that.  Due to what we are looking 
#at (Candidates connected by industries), this means they share both industries.  
#Keep in mind that this will be left out of the modular plot.

#Remove multi-edges
g1 <- simplify(g1, remove.multiple = TRUE)

#Using modularity to generate clusters - options mimicked from Lisa's code.
#Command in Lisa's code did not exist in my installation of igraph,
#Command Source: http://igraph.org/r/doc/cluster_fast_greedy.html
fgreedy <- cluster_fast_greedy(g1,merges=TRUE, modularity=TRUE)

#According to stack overflow, the command in Lisa's demo was deprecated 
#(Source: http://stackoverflow.com/questions/14066700/about-community-to-
#membership-function).  They suggest that cut_at is comparable.
#Used R help to learn about cut_at
g1ModClusters <- cut_at(fgreedy, steps=which.max(fgreedy$modularity)-1)

#Set vertex color variable to cluster number plus 1.
V(g1)$color <- g1ModClusters+1

#Plot
g1 <- set.graph.attribute(g1, "layout", layout.fruchterman.reingold(g1))
plot(g1)
plot(g1, vertex.label=NA)
