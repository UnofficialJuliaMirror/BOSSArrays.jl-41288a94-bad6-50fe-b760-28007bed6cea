using PyCall
PyCall.@pyimport intern.remote.boss as mb
PyCall.@pyimport intern.resource.boss.resource as sb
PyCall.@pyimport numpy

const DEFAULT_COLL_NAME = "team2_waypoint"
const DEFAULT_EXP_NAME = "pinky10"
const DEFAULT_CHAN_NAME = "em"
const DEFAULT_DATASET_NAME  = "image"
const DEFAULT_DATA_TYPE = "uint16"

rmt = mb.BossRemote()
chan = sb.ChannelResource( DEFAULT_CHAN_NAME, DEFAULT_COLL_NAME,
                            DEFAULT_EXP_NAME,
                            DEFAULT_DATASET_NAME,
                            datatype = DEFAULT_DATA_TYPE);
chan = rmt[:get_project](chan)

x_rng = [10000, 10008]
y_rng = [10000, 10004]
z_rng = [0, 5]

# Use native resolution.
res = 0

@show rmt

data = rmt[:get_cutout](chan, res, x_rng, y_rng, z_rng)

@show typeof(data)
@show data
