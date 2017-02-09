using PyCall
PyCall.@pyimport intern.remote.boss as mb
PyCall.@pyimport intern.resource.boss as sb
PyCall.@pyimport numpy

module BOSS

export BOSSArray

const DEFAULT_COLL_NAME = "team2_waypoint"
const DEFAULT_EXP_NAME = "pinky10"
const DEFAULT_CHAN_NAME = "em"
const DEFAULT_DATASET_NAME  = "image"
const DEFAULT_DATA_TYPE = "uint16"
const DEFAULT_RESOLUTION_LEVEL = 0

immutable BOSSArray <: AbstractArray
    rmt     :: PyObject
    chan    :: PyObject
end

function BOSSArray( collectionName  = DEFAULT_COLL_NAME,
                    experimentName  = DEFAULT_EXP_NAME,
                    channelName     = DEFAULT_CHAN_NAME )
    rmt = mb.BossRemote()
    chan = sb.ChannelResource( channelName, collectionName,
                                experimentName,
                                DEFAULT_DATASET_NAME,
                                datatype = DEFAULT_DATA_TYPE)
    chan = rmt[:get_project](chan)
    BOSSArray( rmt, chan )
end

function Base.UnitRange( idx::Int )
    return idx:idx
end

function Base.getindex(ba::BOSSArray, idxes::Union{UnitRange, Int} ...)
    # switch to 0-based coordinate system
    idxes = map(x->Base.UnitRange(x-1), idxes)

    x_rng = [idxes[1].start, idxes[1].stop]
    y_rng = [idxes[2].start, idxes[2].stop]
    z_rng = [idxes[3].start, idxes[3].stop]

    return rmt[:get_cutout](chan, DEFAULT_RESOLUTION_LEVEL,
                x_rng, y_rng, z_rng)
end
