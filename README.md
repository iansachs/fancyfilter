# fancyfilter

Dependency-free header and static library implementing the hypothetical **Fancy Filter**. It is small part of the (hopefully) fun coding challenge described [here](http://iansachs.github.io/fancyfilter).

About
-----

The **Fancy Filter** is a simple C++ filter. It uses some C++11 features, but has no external dependencies. It is based on [SLIC Superpixels]() which clusters the image (RGBXY) features into `numCells` clusters, with larger values of `numCells`. An example can be seen here:

| ![Input](/docs/images/input-000.jpg?raw=true "Input") | ![1024 cells](/docs/images/result.jpg?raw=true "1024 Cells") |
|:--------------:|:--------------:|
| Input          |  1024 Cells    |

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


Usage Example
-------------

```c++
// Include the header file
#include "fancyfilter/fancyfilter.hpp"

// Convert from some existing image format to the Image3u type expected
// by the filter call
fancyfilter::Image3u input = ... // Create Image3u here
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




