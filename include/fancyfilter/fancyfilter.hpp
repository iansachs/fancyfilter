/** \file fancyfilter.hpp
 * Fancy Filter interface.
 */
#pragma once
#ifndef __FANCY_FILTER_INCLUDED__
#define __FANCY_FILTER_INCLUDED__

#include <vector>
#include <functional>

/** \namespace fancyfilter
 * Only class and functions from this toplevel namespace (not the detail namespace) 
 * are required for the exercise
 */
namespace fancyfilter {

namespace detail {

/**
 * Base class for matrices and images. Storage is row-major.
 */
template <typename T, typename DerivedT>
class MatBase {
    typedef std::vector<T> storage_type;

public:
    typedef T value_type;
    typedef typename storage_type::iterator iterator;
    typedef typename storage_type::const_iterator const_iterator;

    MatBase() {}

    /**
     * Construct a new matrix with r rows and c columns
     *
     * \param r   new number of matrix rows
     * \param c   new number of matrix columns
     */
    MatBase(int r, int c) {
        resize(r, c);
    }

    /**
     * Resizes the matrix to new dimensions r rows and c columns
     * 
     * \param r   new number of matrix rows
     * \param c   new number of matrix columns
     */
    void resize(int r, int c) {
        // Call the derived class (for example, Images also incorporate
        // the number of channels)
        derived().resize(r, c);
    }
    
    /**
     * Access the matrix element at row i and column j
     *
     * \param i   matrix row index
     * \param j   matrix col index
     *
     * \return The matrix element at index (i, j)
     */
    T& operator()(int i, int j) { return data_[stride_[0] * j + stride_[1] * i]; }
    T operator()(int i, int j) const { return data_[stride_[0] * j + stride_[1] * i]; }

    /**
     * Access a pointer to the matrix element at row i and column j.
     *
     * This can be useful in the case of Image3u, where we are typically interested
     * in an RGB triplet of values at index (i, j)
     *
     * \param i   matrix row index
     * \param j   matrix col index
     *
     * \return Pointer to matrix element at index (i, j)
     */
    T* ptr(int i, int j) { return &(data_[stride_[0] * j + stride_[1] * i]); }
    const T* ptr(int i, int j) const { return &(data_[stride_[0] * j + stride_[1] * i]); }
 
    /**
     * Access a pointer to the first element of matrix row i. This is 
     * equaivalent to calling ptr(i, 0)
     *
     * \param i   matrix row index
     *
     * \return Pointer to first matrix element in row i
     */
    T* row(int i) { return &(data_[stride_[1] * i]); }
    const T* row(int i) const { return &(data_[stride_[1] * i]); }

    /**
     * Return an iterator pointing to the first element of the matrix.
     * Incrementing the iterator traverses the matrix values in row-major
     * order.
     */
    iterator begin() { return data_.begin(); }
    const_iterator begin() const { return data_.begin(); }

    /**
     * Return an iterator pointing to one element after the last element 
     * of the matrix.
     */
    iterator end() { return data_.end(); }
    const_iterator end() const { return data_.end(); }

    /**
     * Matrix dimensions
     */
    int rows() const { return dims_[0]; }
    int cols() const { return dims_[1]; }

protected:
    // Access the derived type for static polymorphism
    DerivedT& derived() { return static_cast<DerivedT&>(*this); }
    const DerivedT& derived() const { return static_cast<DerivedT&>(*this); }

    storage_type data_;  //!< matrix element values (row-major order)
    int dims_[2];        //!< matrix dimensions
    int stride_[2];      //!< strides for converting 2D index to 1D idnex into data_

}; // MatBase
} // detail

/**
 * Simple Image class.
 * 
 * Implemented as a matrix subclass where rows represent the image's 
 * vertical axis and columns are the image horizontal access.
 *
 * \tparam T   the data type for a single channel of a pixel
 * \tparam C   the number of image channels (e.g. RGB image has C = 3)
 */
template <typename T, int C>
class Image : public detail::MatBase<T, Image<T, C> > {
    typedef detail::MatBase<T, Image<T, C> > base;

    using base::dims_;
    using base::stride_;
    using base::data_;

public:
    static const int kChannels = C;

    Image() : base() {}

    /**
     * Construct new image with width w and height h.
     *
     * Width and height map to matrix columns and rows respectively, but
     * are more intuitive to think about when considering images. The elements
     * are not initialized. Initialize with STL. e.g.:
     *
     * \code{.cpp}
     * // Create an image 200 pixels wide x 100 pixels tall.
     * Image<unsigned char, 3> image(200, 100);
     *
     * // Set values to 0
     * std::fill(image.begin(), image.end(), 0);
     * \endcode
     *
     * \param w   width of image
     * \param h   height of image
     */
    Image(int w, int h) {
        resize(w, h);
    }

    /**
     * Resize image to width w and height h.
     *
     * \param w   width of image
     * \param h   height of image
     */
    void resize(int w, int h) {
        dims_[0] = h;
        dims_[1] = w;
        stride_[0] = kChannels;
        stride_[1] = stride_[0] * dims_[1];
        data_.resize(dims_[0] * dims_[1] * C);
    }
    
    /**
     * Image dimensions
     */
    int width() const { return dims_[1]; }
    int height() const { return dims_[0]; }
    int channels() const { return kChannels; }    

};

/** \typedef Image3u
 * This is the specific image type that will be used in the coding
 * exercise.
 */
typedef Image<unsigned char, 3> Image3u;

/** \fn bool applyFilter(const Image3u& imgIn, Image3u& imgOut, int numCells, std::function<void(float)> progressCB)
 * Applies the fancy filter to imgIn, and saves the results to imgOut.
 *
 * No range checking is done to determine if imgIn is of reasonable size,
 * or if numCells is a valid value
 *
 * \param imgIn         image to apply the filter to
 * \param[out] imgOut   filtered result
 * \param numCells      number of cells for the filter effect. Valid range [1, 2048]
 * \param progressCB    callback function for communicating progress. progressCB 
 *                      takes a float in the range [0, 1] with 1 being 100% complete
 *
 * \return true on success, false otherwise
 */
bool applyFilter(const Image3u& imgIn, Image3u& imgOut, int numCells, std::function<void(float)> progressCB);

} // fancyfilter

#endif // __FANCY_FILTER_INCLUDED__
