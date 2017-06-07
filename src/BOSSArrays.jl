module BOSSArrays

using Requests
using Blosc

export BOSSArray

function __init__()
    Blosc.set_num_threads(div(Sys.CPU_CORES,2))
end

include("types.jl")
include("base.jl")

end # end of module
