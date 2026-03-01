module SpatialPreferentialAttachment
using CSV
using DataFrames, DataFramesMeta
using Graphs
using Makie
using Memento
using Random
using SparseArrays
using CodecBzip2

import LinearAlgebra: norm
import Statistics: mean

include("utils.jl")
include("circular_layout.jl")
include("creategraph.jl")
include("attach_list.jl")
include("add_node.jl")
include("create_spa_graph.jl")
include("degree_distribution.jl")
include("plotgraph.jl")

const logger = getlogger(@__MODULE__)
function __init__()
    Memento.config!("debug"; fmt="{level}: {msg}")
    setlevel!(logger, "debug")
    Memento.register(logger)
end


export add_node!,
    circular,
    creategraph,
    create_spa_graph,
    degree_distribution,
    expq,
    lnq,
    load_bz2_csv,
    map_to_interval,
    plotgraph,
    position_layout,
    save_bz2_csv
end
