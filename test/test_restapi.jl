using Requests
# import Requests: get

const BOSS_TOKEN = ENV["INTERN_TOKEN"]

headers = Dict("Authorization"          => "Token $(BOSS_TOKEN)",
                        "content-type"  => "application/blosc",
                        "Accept"        => "application/blosc")

resp = Requests.get(URI("https://api.theboss.io/v0.7/cutout/team2_waypoint"*
                "/pinky10/em/0/10000:10005/10000:10006/0:1/");
                headers = headers)

fieldnames(resp)
data = resp.data

readbytes(resp)
using Blosc
Blosc.set_num_threads(div(Sys.CPU_CORES,2))
data = Blosc.decompress(UInt8, data)

# data = reshape(data,(5,6,4))

length(data)

@show resp
