# test RESTful API first
#include("test_restapi_read.jl")
#include("test_restapi_write.jl")


using BOSSArrays

ba = BOSSArray( collectionName  = "jingpengw_test",
                experimentName  = "test",
                channelName     = "em")


a = rand(UInt8, 200,200,1)

# the boss will overwrite zeros in the database, so make sure that all the value was overwritten by avoid zeros. 
for i in eachindex(a)
    if a[i]== UInt8(0)
        a[i] = UInt8(1)
    end 
end 

ba[10001:10200, 10001:10200, 101] = a

b = ba[10001:10200, 10001:10200, 101]

#@show a
#@show b

@assert all(a.==b)

# @show arr


# using Images
# # img = Image(arr)
# using ImageView
# using FixedPointNumbers
# ImageView.imshow( reinterpret(N0f8, arr) )
#
# # ImageView.imshow(rand(UInt8, 200,200))
#
#
# sleep(60)
