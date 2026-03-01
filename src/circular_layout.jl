function circular(df::DataFrame; sortby=nothing, R=1.0)::NamedTuple
    if ~isnothing(sortby)
        @assert String(sortby) in names(df) "$sortby must be a column in df"
    end

    n = nrow(df)
    layout = circular(n; R=R)

    # keep the original df intact
    dfc = copy(df)
    dfc[!, :id] = collect(1:n)

    if ~isnothing(sortby)
        dfc = @orderby(dfc, -sortby)
    end

    dfc[!, :x] = layout.x
    dfc[!, :y] = layout.y

    # sort back
    dfc = @orderby(dfc, :id)

    return (x=dfc[:, :x], y=dfc[:, :y])
end


function circular(n::Int64; R=1.0)::NamedTuple
    θ = LinRange(0, 2π, n)
    x = R * cos.(θ)
    y = R * sin.(θ)

    return (x=x, y=y)
end

function position_layout(df::DataFrame; sortby=nothing)::NamedTuple
    if ~isnothing(sortby)
        @assert String(sortby) in names(df) "$sortby must be a column in df"
    end

    dfc = copy(df)
    if ~isnothing(sortby)
        dfc = @orderby(df, -sortby)
    end
    x = dfc[!, :x]
    y = dfc[!, :y]

    return (x=x, y=y)
end
