# test RESTful API first
include("test_restapi_read.jl")
include("test_restapi_write.jl")


using BOSSArrays

ba = BOSSArray( collectionName  = "jingpengw_test",
                experimentName  = "test",
                channelName     = "em")


a = rand(UInt8, 2,2,1)

ba[10001:10002, 10001:10002, 101:101] = a

b = ba[10001:10002, 10001:10002, 101:101]

@show a
@show b

@assert all(a==b)

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
