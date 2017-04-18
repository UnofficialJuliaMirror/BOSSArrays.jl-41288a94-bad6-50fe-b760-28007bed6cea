function Base.size{T,N}( ba::BOSSArray{T,N})
    ([typemax(Int64) for i in 1:N]...)
end

function Base.eltype{T,N}( ba::BOSSArray{T,N} )
    T 
end

function Base.ndims{T,N}( ba::BOSSArray{T,N} )
    N
end

function Base.reshape{T,N}( ba::BOSSArray{T,N}, newShape )
    warn("BOSSArray do not support reshaping")
end

function Base.getindex{T}( ba::BOSSArray{T,3}, idxes::Union{UnitRange, Int} ... )
    idxes = map(UnitRange, idxes)
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

function Base.getindex{T}( ba::BOSSArray{T,4}, idxes::Union{UnitRange, Int} ... )
    idxes = map(UnitRange, idxes)
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

function Base.setindex!{T}(ba::BOSSArray{T,3}, buffer::AbstractArray{T,3},
                            idxes::Union{UnitRange, Int}...)
    idxes = map(UnitRange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"
    data = Blosc.compress( buffer )
    resp = Requests.post(URI(urlPath); data = data, headers = ba.headers)
    #@show resp

    if statuscode(resp) != 201
        error("writting to boss have error: $resp")
    end
        
    return resp
end
