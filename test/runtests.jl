using SpatialPreferentialAttachment
using SparseArrays
using Statistics
using Graphs
using Random
using Test
using Memento
logger = getlogger("SpatialPreferentialAttachment")

@testset "creategraph.jl" begin
    g, nodepositions, edgeweights = creategraph(20; d=2, m0=2, rmin=1.0)
    @test nv(g) == 2
    @test ne(g) == 1
    nrows, ncols = findnz(edgeweights)
    @test length(nrows) == length(ncols) == 2 * ne(g)
    for (i, j) in zip(nrows, ncols)
        @test edgeweights[i, j] == edgeweights[j, i]
    end
end

@testset "add_node.jl" begin
    g, nodepositions, edgeweights = creategraph(20; d=2, m0=2, rmin=1.0)

    nn, ee = add_node!(g, nodepositions, edgeweights, 2)
    nn, ee = add_node!(g, nodepositions, edgeweights, 2)
    nn, ee = add_node!(g, nodepositions, edgeweights, 2)
    nn, ee = add_node!(g, nodepositions, edgeweights, 2)
    nn, ee = add_node!(g, nodepositions, edgeweights, 2)
    @test nv(g) == 7
    @test ne(g) == 2 * (nv(g) - 2) + 1
    @test length(nodepositions) == nv(g)
    nrows, ncols = findnz(edgeweights)
    @test length(nrows) == length(ncols) == 2 * ne(g)
    for (i, j) in zip(nrows, ncols)
        @test edgeweights[i, j] == edgeweights[j, i]
    end
end

@testset "create_spa_graph.jl" begin
    g, nodepositions, edgeweights = create_spa_graph(20,2; 
        γ=1.0, 
        d=2,
        αA=2.0,
        αG=2.0,
        rmin=1.0,
        rmax=1000.0,
        rng=Random.default_rng())
    @test nv(g) == 20
    @test ne(g) == 2 * (nv(g) - 2) + 1
    @test length(nodepositions) == nv(g)
    nrows, ncols = findnz(edgeweights)
    @test length(nrows) == length(ncols) == 2 * ne(g)
    for (i, j) in zip(nrows, ncols)
        @test edgeweights[i, j] == edgeweights[j, i]
    end
end

