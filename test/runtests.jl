
using BOSSArrays

ba = BOSSArray()


arr = ba[10001:10200, 10001:10200, 1]
# @show arr


# using Images
# img = Image(arr)
using ImageView
using FixedPointNumbers
ImageView.imshow( reinterpret(N0f8, arr) )

# ImageView.imshow(rand(UInt8, 200,200))


sleep(60)
