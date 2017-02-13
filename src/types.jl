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
