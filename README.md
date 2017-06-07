BOSSArrays.jl
========
[![Build Status](https://travis-ci.org/seung-lab/BOSSArrays.jl.svg?branch=master)](https://travis-ci.org/seung-lab/BOSSArrays.jl)

Julia interface to [BOSS](https://github.com/jhuapl-boss/boss) for large scale image cutout and chunk saving.

- Blosc compression to speed up data transer
- error handling for writting

# Installation

    Pkg.clone("git@github.com:seung-lab/BOSSArrays.jl.git")
## set BOSS token 
setup the enviroment variable
 - add these line to `~/.bashrc` file
```
export INTERN_PROTOCOL=https
export INTERN_HOST=api.theboss.io
export INTERN_TOKEN=98d060b8ecd983842bb0f105ea3ee91f75796306
```
- `source ~/.bashrc`

# Usage
use it as a normal Julia Array
```
using BOSSArrays
ba = BOSSArray( collectionName  = "YourCollectionName",
                experimentName  = "YourExperimentName",
                channelName     = "YourChannelName")
a = rand(UInt8, 200,200,3)
ba[10001:10200, 10001:10200, 1:3] = a
b = ba[10001:10200, 10001:10200, 1:3]
@assert all(a.==b)
```
