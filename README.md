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
    │   │   ├── input-000.jpg             # Example input image
    │   │   └── result.png                # Example result image
    │   ├── index.html                    # Github pages writeup
    │   └── starter-template.css          # Github pages writeup CSS
    ├── fancyfilter-app                   # Fancy filter starter app
    │   ├── fancyfilter-app
    │   │   ├── AppDelegate.h
    │   │   ├── AppDelegate.m
    │   │   ├── Assets.xcassets
    │   │   ├── Base.lproj
    │   │   ├── Info.plist
    │   │   ├── UIImage+Image3u.h         # Helper category for UIImage <-> Image3u conversion
    │   │   ├── UIImage+Image3u.mm        # Helper category for UIImage <-> Image3u conversion
    │   │   ├── ViewController.h
    │   │   ├── ViewController.m
    │   │   └── main.m
    │   └── fancyfilter-app.xcodeproj     # fancyfilter starter app Xcode project
    ├── include
    │   └── fancyfilter
    │       └── fancyfilter.hpp           # Fancy filter header
    └── lib
        └── libff.a                       # Fancy filter static lib (arm64, armv7, armv7s, i386, x86_64)


Fancy Filter Library
--------------------

The Fancy Filter library is written in C++. It defines a custom [Image3u](https://iansachs.github.io/fancyfilter/doxygen/html/classfancyfilter_1_1_image.html) image class, as well an [applyFilter](https://iansachs.github.io/fancyfilter/doxygen/html/namespacefancyfilter.html#aec6ef14ffb390cc64820a81dad1073e2) function
which takes an input `Image3u` and generates an output `Image3u`. It also requires a `numCells` which determines how many clusters the filter should generate, as well as a progress callback, which allows `applyFilter` to report progress.

#### C++ Usage Example

```c++
// Include the header file
#include "fancyfilter/fancyfilter.hpp"

// Convert from some existing image format to the Image3u type expected
// by the filter call
fancyfilter::Image3u input = ... // Create Image3u from input image here
fancyfilter::Image3u output;     // Placeholder for output

// Set the number of cells to use for the filter (controls the "resolution")
int numCells = 128;

// Call the API
fancyfilter::applyFilter(input, output, numCells, [&](float progress){
    // This is a C++ lambda which is called by applyFilter to communicate 
    // progress in the range [0, 1]. Respond to progress callbacks here.
    // e.g.) 
    std::cout << "progress: " << (progress * 100) << " percent complete" << std::endl;
});

// Do something with the result. e.g.)
return output; 
```


Starter Project
---------------

The `fancyfilter-app` directory provides a simple Xcode project to start from. It should build a Single View Application which presents a `UIImageView` a long with a "Choose Image" button. Pressing the button launches a `UIImagePickerController` which allows you to select images from you camera roll. Upon selection, the displayed image is shown in the `UIImageView`.

The Xcode project also includes a `UIImage+Image3u` helper category for converting from a `UIImage` to an `Image3u` and back.

#### Build Settings

The important build settings are already set in the project. They look like this:

* `/path/to/fancyfilter/include` is in your **Build Setting -> Header Search Paths**
* `/path/to/fancyfilter/lib` is in your **Build Setting -> Library Search Paths**
* `libff.a` is in your **Build Phases->Link Binary With Libraries** list
* **Build Settings->Enable Bitcode** is Yes



Notes
-----

* Data in `fancyfilter::MatBase` and its derivatives is stored in [row-major](https://en.wikipedia.org/wiki/Row-major_order) order.
* In this case, you can't make any assumptions about the error checking performed by the provided library
* The provided binary has been compiled in "Release" mode (i.e. without debug symbols and with -O3 optimization)


