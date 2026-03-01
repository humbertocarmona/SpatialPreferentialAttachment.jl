"""
    creategraph(; d=2, m0=1, r=1.0, rng=Random.default_rng()) -> (SimpleWeightedGraph, Vector{Vector{Float64}})

	Create an initial graph to seed the growth model.

	The graph is initialized with `n_nodes = max(2, m0)` nodes. The nodes are placed on the
	surface of a `d`-dimensional sphere of radius `r`. They are connected sequentially
	(1-2, 2-3, etc.), and if there are more than two nodes, the last node is connected
	to the first to form a cycle. The edge weights are set to the Euclidean distance
	between the connected nodes.

	# Keyword Arguments
    - `N::Int64`: The total number of nodes (after growth) in the graph.
	- `d::Int=2`: The dimension of the embedding space.
	- `m0::Int=2`: The initial number of nodes. The graph will have at least 2 nodes.
	- `r::Float64=1.0`: The radius of the sphere on which nodes are placed.
	- `rng::AbstractRNG=Random.default_rng()`: The random number generator to use.

	# Returns
	- `G::Graph`: The initial graph.
	- `nodepositions::Vector{Vector{Float64}}`: A vector containing the coordinates of each node.
    - `edgeweights::SparseMatrixCSC{Float64}`: A sparse (NxN) matrix containing the edge weights.   
"""
function creategraph(N::Int64; d::Int=2,
    m0=2,
    rmin=1.0,
    rng=Random.default_rng())

    # start with at least m0 nodes

    G = Graph(m0) # empty undirected graph

    # place m0 on the surface of a d-dimensional sphere of radius r
    nodepositions = [zeros(d) for _ in 1:m0]
    for i in 1:m0
        pos = rmin * rand_hypersphere(d)
        nodepositions[i] = pos
    end

    # completely connected initial graph
    edgeweights = spzeros(N, N)
    for i in 1:(m0-1)
        for j in i+1:m0
            rij = norm(nodepositions[i] - nodepositions[j])
            e = add_edge!(G, i, j)
            if e
                edgeweights[i, j] = rij
                edgeweights[j, i] = rij
            end
        end
    end
    return G, nodepositions, edgeweights
end