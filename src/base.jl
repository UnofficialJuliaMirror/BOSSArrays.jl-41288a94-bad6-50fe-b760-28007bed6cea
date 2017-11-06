function Base.size( ba::BOSSArray{T,N}) where {T,N}
    ([typemax(Int64) for i in 1:N]...)
end

function Base.eltype( ba::BOSSArray{T,N} ) where {T,N}
    T 
end

function Base.ndims( ba::BOSSArray{T,N} ) where {T,N}
    N
end

function Base.reshape( ba::BOSSArray{T,N}, newShape ) where {T,N}
    warn("BOSSArray do not support reshaping")
end

"""
transform int to a UnitRange
"""
function idx2unitrange( idx::Union{UnitRange, Int} )
    if isa(idx, Int)
        return idx:idx
    else
        return idx 
    end
end 

function Base.getindex( ba::BOSSArray{T,3}, idxes::Union{UnitRange, Int} ... ) where T
    idxes = map(idx2unitrange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"
    resp = Requests.get(URI(urlPath); headers = ba.headers)
    data = Blosc.decompress(T, resp.data)
    data = reshape(data, map(length, idxes))
    return data
end

function Base.getindex( ba::BOSSArray{T,4}, idxes::Union{UnitRange, Int} ... ) where T
    idxes = map(idx2unitrange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"*
                    "/$(idxes[4].start-1):$(idxes[4].stop)"
    resp = Requests.get(URI(urlPath); headers = ba.headers)
    data = Blosc.decompress(T, resp.data)
    data = reshape(data, map(length, idxes))
    return data
end

function Base.setindex!(ba::BOSSArray{T,3}, buffer::AbstractArray,
                         idxes::Union{UnitRange, Int}...) where T
    @assert ndims(buffer)==3
    buffer = convert(Array{T,3}, buffer)
    idxes = map(idx2unitrange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"
    data = Blosc.compress( buffer )
    local resp 
    for i in 1:3 
        resp = Requests.post(URI(urlPath); data = data, headers = ba.headers)
        if statuscode(resp) == 201
            break
        else
            sleep(3)
        end
    end 

    if statuscode(resp) != 201
        error("writting to boss have error: $resp")
    end
    return resp
end
