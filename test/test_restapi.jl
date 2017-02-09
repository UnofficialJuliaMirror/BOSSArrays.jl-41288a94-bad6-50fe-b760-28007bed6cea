using Requests
import Requests: get

const BOSS_TOKEN = ENV["INTERN_TOKEN"]

headers = Dict("Authorization" => "Token $(BOSS_TOKEN)",
                        "Content-Type"  => "application/json")

resp = get(URI("https://api.theboss.io/v0.7/cutout/team2_waypoint/pinky10/em/0/0:5/0:6/0:4/"); headers = headers)

data = resp.data
@show data
