# fancyfilter

Dependency-free header and iphoneos/iphonesimulator FAT static library implementing the hypothetical **Fancy Filter**. It is small part of the (hopefully) fun coding challenge described [here](http://iansachs.github.io/fancyfilter).

About
-----

The **Fancy Filter** is a simple C++ filter. It uses some C++11 features, but has no external dependencies. It is based on [SLIC Superpixels](http://www.kev-smith.com/papers/SLIC_Superpixels.pdf) which clusters the image (RGBXY) features using a variant of [k-means](https://en.wikipedia.org/wiki/K-means_clustering). An example can be seen here:

| ![Input](/docs/images/input-000.jpg?raw=true "Input") | ![1024 cells](/docs/images/result.png?raw=true "1024 Cells") |
|:-----------------------------------------------------:|:------------------------------------------------------------:|
| Input                                                 |  1024 Cells                                                  |


#### Documentation

Online API documentation can be found [here](https://iansachs.github.io/fancyfilter/doxygen/html/index.html). These pages are automatically generated from the `fancyfilter/fancyfilter.hpp` header file using [Doxygen](http://www.stack.nl/~dimitri/doxygen/).

Contents
--------

    .
    ├── README.md
    ├── docs
    │   ├── doxygen
    │   ├── images
    │   │   ├── input-000.jpg         # Example input image
    │   │   └── result.png            # Example result
    │   ├── index.html                # Github pages writeup
    │   └── starter-template.css      # Github pages writeup CSS
    ├── include
    │   └── fancyfilter
    │       └── fancyfilter.hpp       # Fancy filter header
    └── lib
        └── libff.a                   # Fancy filter static lib (arm64, armv7, armv7s, i386, x86_64)


Build Options
-------------

To build against **Fancy Filter** you should just need to ensure that:

* `/path/to/fancyfilter/include` is in your **Build Setting -> Header Search Paths**
* `/path/to/fancyfilter/lib` is in your **Build Setting -> Library Search Paths**
* `libff.a` is in your **Build Phases->Link Binary With Libraries** list
* **Build Settings->Enable Bitcode** is Yes


Usage Example
-------------

```c++
// Include the header file
#include "fancyfilter/fancyfilter.hpp"

// Convert from some existing image format to the Image3u type expected
// by the filter call
fancyfilter::Image3u input = ... // Create Image3u from input image here
fancyfilter::Image3u output;     // Placeholder for output

// Call the API
fancyfilter::applyFilter(input, output, 128, [&](float progress){
    // This is a C++ lambda which is called by applyFilter to communicate 
    // progress in the range [0, 1]. Respond to progress callbacks here.
    // e.g.) 
    std::cout << "progress: " << (progress * 100) << " percent complete" << std::endl;
});

// Do something with the result. e.g.)
return output; 
```


Notes
-----

* Data in `fancyfilter::MatBase` and its derivatives is stored in [row-major](https://en.wikipedia.org/wiki/Row-major_order) order.
* In this case, you can't make any assumptions about the error checking performed by the provided library
* The provided binary has been compiled in "Release" mode (i.e. without debug symbols and with -O3 optimization)


