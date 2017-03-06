using Requests
using Blosc
using HttpCommon
Blosc.set_num_threads(div(Sys.CPU_CORES,2))
# import Requests: get

const BOSS_TOKEN = ENV["INTERN_TOKEN"]

headers = Dict("Authorization"          => "Token $(BOSS_TOKEN)",
                        "content-type"  => "application/blosc",
                        "Accept"        => "application/blosc",
                        "Date"          => Dates.format(now(Dates.UTC), Dates.RFC1123Format))

a = rand(UInt8, 16, 512,512)
data = Blosc.compress( a )

resp = Requests.post(URI("https://api.theboss.io/v0.8/cutout/jingpengw_test"*
                "/test/em/0/0:512/0:512/32:48/");
                data = data,
                headers = headers)

@show statuscode(resp)
@show resp



resp = Requests.get(URI("https://api.theboss.io/v0.8/cutout/jingpengw_test"*
                "/test/em/0/0:512/0:512/32:48/");
                headers = headers)

data = resp.data


b = Blosc.decompress(UInt8, data)
b = reshape(b, (16, 512,512))

n = 0
for i in eachindex(a)
    if a[i] != b[i]
        n+=1
    end
end

(a.==b)
@assert all(a.==b)
a==b
# data = reshape(data,(5,6,4))

length(data)

@show resp
