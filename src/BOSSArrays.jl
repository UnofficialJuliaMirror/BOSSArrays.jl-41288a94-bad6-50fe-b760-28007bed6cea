module BOSSArrays

using Requests
using Blosc

export BOSSArray

function __init__()
    Blosc.set_num_threads(div(Sys.CPU_CORES,2))
end

const DEFAULT_COLL_NAME = "team2_waypoint"
const DEFAULT_EXP_NAME = "pinky10"
const DEFAULT_CHAN_NAME = "em"
const DEFAULT_DATA_TYPE = UInt8
const DEFAULT_RESOLUTION_LEVEL = 0
const DEFAULT_BOSSAPI_VERSION = "v0.7"
const DEFAULT_ARRAY_DIMENSION = 3

immutable BOSSArray{T, N} <: AbstractArray
    urlPrefix       :: String
    collectionName  :: String
    experimentName  :: String
    channelName     :: String
    resolutionLevel :: Int
    headers         :: Dict{String, String}
end

function (::Type{BOSSArray}){T}(
            foo             ::Type{T},
            N               ::Int,
            urlPrefix       ::String,
            collectionName  ::String,
            experimentName  ::String,
            channelName     ::String,
            resolutionLevel ::Int,
            headers         ::Dict{String, String} )
    BOSSArray{T,N}(   urlPrefix, collectionName, experimentName,
                channelName, resolutionLevel, headers)
end

# @generated function (::Type{BOSSArray{T,N}}){T,N}(
#                         T               ::DataType,
#                         N               ::Int,
#                         urlPrefix       ::String,
#                         collectionName  ::String,
#                         experimentName  ::String,
#                         channelName     ::String,
#                         resolutionLevel ::Int,
#                         headers         ::Dict{String, String} )
#     return quote
#         $(Expr(:meta, :inline))
#         BOSSArray{T,N}( urlPrefix, collectionName, experimentName,
#                         channelName, resolutionLevel, headers )
#     end
# end


function BOSSArray(
                    T               ::DataType  = DEFAULT_DATA_TYPE,
                    N               ::Int       = DEFAULT_ARRAY_DIMENSION,
                    collectionName  ::String    = DEFAULT_COLL_NAME,
                    experimentName  ::String    = DEFAULT_EXP_NAME,
                    channelName     ::String    = DEFAULT_CHAN_NAME,
                    resolutionLevel ::Int       = DEFAULT_RESOLUTION_LEVEL)
    urlPrefix = "$(ENV["INTERN_PROTOCOL"])://$(ENV["INTERN_HOST"])"*
                    "/$(DEFAULT_BOSSAPI_VERSION)"
    headers = Dict("Authorization"  => "Token $(ENV["INTERN_TOKEN"])",
                    "content-type"  => "application/blosc",
                    "Accept"        => "application/blosc")

    BOSSArray{T,N}( urlPrefix, collectionName, experimentName, channelName,
                resolutionLevel, headers )
end

function Base.UnitRange( idx::Int )
    idx:idx
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

end # end of module
