function create_spa_graph(N::Int64, m::Int64;
    γ::Float64=1.0,
    d::Int64=2,
    αA::Float64=2.0,
    αG::Float64=2.0,
    rmin::Float64=1.0,
    rmax::Float64=1000.0,
    rng=Random.default_rng())

    g, nodepositions, edgeweights = creategraph(N;d=d, m0=m, rmin=rmin, rng=rng)
    info(logger, "created graph")
    while nv(g) < N
        nn, nl =add_node!(g, nodepositions, edgeweights, m;
            γ=γ,
            d=d,
            αA=αA,
            αG=αG,
            rng=rng,
            cm=false,
            rmin=rmin,
            rmax=rmax,
        )
        if (nn % 1000) == 0
            info(logger, "create_spa_graph:added node nn: $nn, ne: $nl")  
        end
    end
    info(logger, "finished adding nodes to graph")
    return g, nodepositions, edgeweights
end