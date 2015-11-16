
#==========Set-up==========#

#Used igraph, as suggested from class and in the materials posted on the web.
library(igraph)

#Change the root to the location of the repository in order to run the program.
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")

#Location of the Network Analysis folder within the repository
#This is where output will be saved.
netRepo <- "part2_exploratory_analysis/Network Analysis/"




#==========Load data==========#

#Load the data that will be subset for the network analysis.
baseData <- read.csv(paste0(root,
                            "part2_exploratory_analysis/PoldataSPIndustries.csv"),
                     stringsAsFactors = FALSE)

#Reduce data to information that will be fed to the network.
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

#Used a strategy from someone else in order to perform the conversion from 
#bimodal data to unimodal data.
#Source: https://solomonmessing.wordpress.com/2012/09/30/working-with-bipartite
#affiliation-network-data-in-r/
#Used this to learn about the difference between bimodal and unimodal networks:
#http://www.scottbot.net/HIAL/?p=41158

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

#Degree without multiple edges
#Google searched for the "simplify" command in igraph
#http://www.inside-r.org/packages/cran/igraph/docs/simplify
gtemp <- g1
gtemp <- simplify(g1, remove.multiple = TRUE)
V(g1)$degreeNoMulti <- degree(gtemp)
g1$meanDegreeNoMulti <- mean(V(g1)$degreeNoMulti)

#Degree with multiple edges
V(g1)$degree <- degree(g1)
g1$meanDegree <- mean(V(g1)$degree)
#Distribution of degree
#Source for output method: http://www.stat.berkeley.edu/~s133/saving.html
#Source used to learn what a degree distribution is:
#http://mathinsight.org/degree_distribution
png(paste0(root,netRepo,"Degree_Distribution.png"))
  plot(table(V(g1)$degree)/vcount(g1),
       main="Degree Distribution", xlab="Degree", ylab="Fraction of Nodes")
dev.off()

#Betweenness
V(g1)$betweeness <- betweenness(g1, directed = FALSE)
g1$meanBetweeness <- mean(V(g1)$betweeness)

#Clustering coefficient
V(g1)$clusteringCoef <- transitivity(g1, type="local")
g1$meanClusteringCoef <- mean(V(g1)$clusteringCoef)

#Graph Density
#Command Source: 
#http://www.inside-r.org/packages/cran/igraph/docs/graph.density
g1$density <- graph.density(g1)

#Graph diameter
g1$diameter <- diameter(g1)

#Number of components
#Command Source: http://igraph.org/r/doc/components.html
g1$components <- count_components(g1,mode="strong")

#Size of the largest k-core
#Command source: 
#http://www.inside-r.org/packages/cran/igraph/docs/graph.coreness
g1$largestKcore <- max(graph.coreness(g1))


#=====Output above information to the output file

#Open file to store output
sink(paste0(root,netRepo,"NetworkInfo.txt"))

cat("DEGREE VECTOR:")
V(g1)$degree
cat("The degree mean is:",g1$meanDegree,"\n","\n")
cat("DEGREE VECTOR WITHOUT MULTIPLE EDGES:")
V(g1)$degreeNoMulti
cat("The degree mean without multiple edges is:",g1$meanDegreeNoMulti,"\n","\n")
cat("BETWEENNESS VECTOR:")
V(g1)$betweeness
cat("The betweenness mean is:",g1$meanBetweeness,"\n","\n")
cat("CLUSTERING COEFFICIENT VECTOR:")
V(g1)$clusteringCoef
cat("The clustering coefficient mean is:",g1$meanClusteringCoef,"\n","\n")
cat("The graph density is:",g1$density,"\n","\n")
cat("The graph diameter is:",g1$diameter,"\n","\n")
cat("The number of components is:",g1$components,"\n","\n")
cat("The size of the largest k-core is:",g1$largestKcore,"\n","\n")

#Close file collecting output
sink()



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

#Create and Output network plot with labels
png(paste0(root,netRepo,"Labeled_Edge_Betweenness_Network.png"))
plot(g1)
dev.off()

#Create and Output network plot without labels
png(paste0(root,netRepo,"No_Labels_Edge_Betweenness_Network.png"))
plot(g1, vertex.label=NA)
dev.off()


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

#Set layout
g1 <- set.graph.attribute(g1, "layout", layout.fruchterman.reingold(g1))

#Create and Output network plot with labels
png(paste0(root,netRepo,"Labeled_Modularity_Network.png"))
plot(g1)
dev.off()

#Create and Output network plot without labels
png(paste0(root,netRepo,"No_Labels_Modularity_Network.png"))
plot(g1, vertex.label=NA)
dev.off()

