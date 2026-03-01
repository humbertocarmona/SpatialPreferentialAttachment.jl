"""
	attach_list(r::Int, positions::Vector{Vector{Float64}}, degrees::Vector{Int}, α::Float64; rng=Random.default_rng()) -> Vector{Vector{Float64}}
	Attach `r` new nodes to existing nodes at `positions` with `degrees` using preferential
	attachment with spatial decay controlled by exponent `α`.

	 Πij = k_i^γ / rij^α

    Args:
    newpos: vector with the coordinates with the new node position
    nodepositions: vector with all previous node positions
    nodegegrees: vector with all previous node degress
    m: number of old nodes to attach to 
    γ=1...
    rng=Random.default_rng()
    ε=0.01

     return:
        list of vertices to attach
	
"""
function attach_list(newpos::Vector{Float64},
    nodepositions::Vector{Vector{Float64}},
    nodedegrees::Vector{Int},
    α::Float64,
    m::Int;
    γ=1.0,
    rng=Random.default_rng(),
    ε=0.01)


	N_previous = length(nodepositions)
    @assert length(nodedegrees) == N_previous
    @assert α >= 0
    @assert γ <= 1
    @assert length(newpos) == length(nodepositions[1]) # dimension check

    # vector with N newpos
    pr = fill(newpos, N_previous)
    # vector with all displacements
    dr = pr .- nodepositions
    #vector with all distances
    rij = norm.(dr)

    # numerator Πij = k_i^γ / rij^α
    num = nodedegrees .^ γ
    den = rij .^ α
    weights = num ./ den

    total_weight = sum(weights)
    Π = weights ./ total_weight
    ΣΠ = cumsum(Π)

    # if ΣΠ[2] > (1 - ε)
    #     warn(logger, "ΣΠ[$m] = $(ΣΠ[m]): too dense")
	# 	debug(logger, "ΣΠ: $ΣΠ")
    # end

    # list with the index of the old nodes
    v_list = zeros(Int, m)
    t = 1
    count = 0
    while t <= m
        # generate random number ∈ [0,1]
        r = rand(rng)  
        # locate the node for Π_ij matching r
        v = findfirst(x -> x >= r, ΣΠ)
        # add to the list
        if v ∉ v_list
            v_list[t] = v
            t += 1
        end
        
        if count > 5000 * m && t <= m
            warn(logger, "$t reached maximum tries: adding a random edge.")
            v = rand(1:N_previous)
            v_list[t] = v
            t += 1
        end
        count += 1
    end
    return v_list
end