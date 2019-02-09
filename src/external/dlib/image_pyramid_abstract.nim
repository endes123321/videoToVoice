##  Copyright (C) 2010  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

when defined(DLIB_IMAGE_PYRaMID_ABSTRACT_Hh_):
  import
    ../pixel, ../array2d, ../geometry, ../image_processing/generic_image

  type
    pyramid_down* {.importcpp: "dlib::pyramid_down",
                   header: "image_pyramid_abstract.h", bycopy.}[N: static[cuint]] = object of noncopyable ## !
                                                                                                  ##             REQUIREMENTS ON N
                                                                                                  ##                 N > 0
                                                                                                  ## 
                                                                                                  ##             WHAT THIS OBJECT REPRESENTS
                                                                                                  ##                 This is a simple functor to help create image pyramids.  In particular, it
                                                                                                  ##                 downsamples images at a ratio of N to N-1.
                                                                                                  ## 
                                                                                                  ##                 Note that setting N to 1 means that this object functions like
                                                                                                  ##                 pyramid_disable (defined at the bottom of this file).  
                                                                                                  ## 
                                                                                                  ##                 WARNING, when mapping rectangles from one layer of a pyramid
                                                                                                  ##                 to another you might end up with rectangles which extend slightly 
                                                                                                  ##                 outside your images.  This is because points on the border of an 
                                                                                                  ##                 image at a higher pyramid layer might correspond to points outside 
                                                                                                  ##                 images at lower layers.  So just keep this in mind.  Note also
                                                                                                  ##                 that it's easy to deal with.  Just say something like this:
                                                                                                  ##                     rect = rect.intersect(get_rect(my_image)); // keep rect inside my_image 
                                                                                                  ##         !
    
  proc `()`*[N: static[cuint]; in_image_type; out_image_type](this: pyramid_down[N];
      original: in_image_type; down: var out_image_type) {.noSideEffect,
      importcpp: "#(@)", dynlib: dlibdll.}
  proc `()`*[N: static[cuint]; image_type](this: pyramid_down[N]; img: var image_type) {.
      noSideEffect, importcpp: "#(@)", dynlib: dlibdll.}
  proc point_down*[N: static[cuint]; T](this: pyramid_down[N]; p: vector[T, 2]): vector[
      cdouble, 2] {.noSideEffect, importcpp: "point_down", dynlib: dlibdll.}
  proc point_up*[N: static[cuint]; T](this: pyramid_down[N]; p: vector[T, 2]): vector[
      cdouble, 2] {.noSideEffect, importcpp: "point_up", dynlib: dlibdll.}
  proc rect_down*[N: static[cuint]](this: pyramid_down[N]; rect: drectangle): drectangle {.
      noSideEffect, importcpp: "rect_down", dynlib: dlibdll.}
  proc rect_up*[N: static[cuint]](this: pyramid_down[N]; rect: drectangle): drectangle {.
      noSideEffect, importcpp: "rect_up", dynlib: dlibdll.}
  proc point_down*[N: static[cuint]; T](this: pyramid_down[N]; p: vector[T, 2];
                                     levels: cuint): vector[cdouble, 2] {.
      noSideEffect, importcpp: "point_down", dynlib: dlibdll.}
  proc point_up*[N: static[cuint]; T](this: pyramid_down[N]; p: vector[T, 2];
                                   levels: cuint): vector[cdouble, 2] {.
      noSideEffect, importcpp: "point_up", dynlib: dlibdll.}
  proc rect_down*[N: static[cuint]](this: pyramid_down[N]; rect: drectangle;
                                  levels: cuint): drectangle {.noSideEffect,
      importcpp: "rect_down", dynlib: dlibdll.}
  proc rect_up*[N: static[cuint]](this: pyramid_down[N]; rect: drectangle;
                                levels: cuint): drectangle {.noSideEffect,
      importcpp: "rect_up", dynlib: dlibdll.}


  ##  ----------------------------------------------------------------------------------------
  type
    pyramid_disable* {.importcpp: "dlib::pyramid_disable",
                      header: "image_pyramid_abstract.h", bycopy.} = object of noncopyable ## !
                                                                                    ##             WHAT THIS OBJECT REPRESENTS
                                                                                    ##                 This is a function object with an interface identical to pyramid_down (defined
                                                                                    ##                 at the top of this file) except that it downsamples images at a ratio of infinity
                                                                                    ##                 to 1.  That means it always outputs images of size 0 regardless of the size
                                                                                    ##                 of the inputs.  
                                                                                    ##                 
                                                                                    ##                 This is useful because it can be supplied to routines which take a pyramid_down 
                                                                                    ##                 function object and it will essentially disable pyramid processing.  This way, 
                                                                                    ##                 a pyramid oriented function can be turned into a regular routine which processes
                                                                                    ##                 just the original undownsampled image.
                                                                                    ##         !
    


  ##  ----------------------------------------------------------------------------------------
  proc pyramid_rate*[N: static[cuint]](pyr: pyramid_down[N]): cdouble {.
      importcpp: "dlib::pyramid_rate(@)", dynlib: dlibdll.}
  ## !
  ##         ensures
  ##             - returns (N-1.0)/N
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc find_pyramid_down_output_image_size*[N: static[cuint]](
      pyr: pyramid_down[N]; nr: var clong; nc: var clong) {.
      importcpp: "dlib::find_pyramid_down_output_image_size(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - nr >= 0
  ##             - nc >= 0
  ##         ensures
  ##             - If pyr() were called on an image with nr by nc rows and columns, what would
  ##               be the size of the output image?  This function finds the size of the output
  ##               image and stores it back into #nr and #nc.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc create_tiled_pyramid*[pyramid_type; image_type1; image_type2](
      img: image_type1; out_img: var image_type2; rects: var vector[rectangle];
      padding: culong = 10; outer_padding: culong = 0) {.
      importcpp: "dlib::create_tiled_pyramid(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - pyramid_type == one of the dlib::pyramid_down template instances defined above.
  ##             - is_same_object(img, out_img) == false
  ##             - image_type1 == an image object that implements the interface defined in
  ##               dlib/image_processing/generic_image.h 
  ##             - image_type2 == an image object that implements the interface defined in
  ##               dlib/image_processing/generic_image.h 
  ##             - for both pixel types P in the input and output images, we require:
  ##                 - pixel_traits<P>::has_alpha == false
  ##         ensures
  ##             - Creates an image pyramid from the input image img.  The pyramid is made using
  ##               pyramid_type.  The highest resolution image is img and then all further
  ##               pyramid levels are generated from pyramid_type's downsampling.  The entire
  ##               resulting pyramid is packed into a single image and stored in out_img.
  ##             - When packing pyramid levels into out_img, there will be padding pixels of
  ##               space between each sub-image.  There will also be outer_padding pixels of
  ##               padding around the edge of the image.  All padding pixels have a value of 0.
  ##             - The resulting pyramid will be composed of #rects.size() images packed into
  ##               out_img.  Moreover, #rects[i] is the location inside out_img of the i-th
  ##               pyramid level. 
  ##             - #rects.size() > 0
  ##             - #rects[0] == get_rect(img).  I.e. the first rectangle is the highest
  ##               resolution pyramid layer.  Subsequent elements of #rects correspond to
  ##               smaller and smaller pyramid layers inside out_img.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc image_to_tiled_pyramid*[pyramid_type](rects: vector[rectangle];
      scale: cdouble; p: dpoint): dpoint {.importcpp: "dlib::image_to_tiled_pyramid(@)",
                                      dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - pyramid_type == one of the dlib::pyramid_down template instances defined above.
  ##             - 0 < scale <= 1
  ##             - rects.size() > 0
  ##         ensures
  ##             - The function create_tiled_pyramid() converts an image, img, to a "tiled
  ##               pyramid" called out_img.  It also outputs a vector of rectangles, rect, that
  ##               show where each pyramid layer appears in out_img.   Therefore,
  ##               image_to_tiled_pyramid() allows you to map from coordinates in img (i.e. p)
  ##               to coordinates in the tiled pyramid out_img, when given the rects metadata.  
  ## 
  ##               So given a point p in img, you can ask, what coordinate in out_img
  ##               corresponds to img[p.y()][p.x()] when things are scale times smaller?  This
  ##               new coordinate is a location in out_img and is what is returned by this
  ##               function.
  ##             - A scale of 1 means we don't move anywhere in the pyramid scale space relative
  ##               to the input image while smaller values of scale mean we move down the
  ##               pyramid.
  ##             - Assumes pyramid_type is the pyramid class used to produce the tiled image.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc image_to_tiled_pyramid*[pyramid_type](rects: vector[rectangle];
      scale: cdouble; r: drectangle): drectangle {.
      importcpp: "dlib::image_to_tiled_pyramid(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - pyramid_type == one of the dlib::pyramid_down template instances defined above.
  ##             - 0 < scale <= 1
  ##             - rects.size() > 0
  ##         ensures
  ##             - This function maps from input image space to tiled pyramid coordinate space
  ##               just as the above image_to_tiled_pyramid() does, except it operates on
  ##               rectangle objects instead of points.
  ##             - Assumes pyramid_type is the pyramid class used to produce the tiled image.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc tiled_pyramid_to_image*[pyramid_type](rects: vector[rectangle]; p: dpoint): dpoint {.
      importcpp: "dlib::tiled_pyramid_to_image(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - pyramid_type == one of the dlib::pyramid_down template instances defined above.
  ##             - rects.size() > 0
  ##         ensures
  ##             - This function maps from a coordinate in a tiled pyramid to the corresponding
  ##               input image coordinate.  Therefore, it is essentially the inverse of
  ##               image_to_tiled_pyramid().
  ##             - It should be noted that this function isn't always an inverse of
  ##               image_to_tiled_pyramid().  This is because you can ask
  ##               image_to_tiled_pyramid() for the coordinates of points outside the input
  ##               image and they will be mapped to somewhere that doesn't have an inverse.  But
  ##               for points actually inside the image this function performs an approximate
  ##               inverse mapping.
  ##             - Assumes pyramid_type is the pyramid class used to produce the tiled image.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc tiled_pyramid_to_image*[pyramid_type](rects: vector[rectangle];
      r: drectangle): drectangle {.importcpp: "dlib::tiled_pyramid_to_image(@)",
                                dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - pyramid_type == one of the dlib::pyramid_down template instances defined above.
  ##             - rects.size() > 0
  ##         ensures
  ##             - This function maps from a coordinate in a tiled pyramid to the corresponding
  ##               input image coordinate.  Therefore, it is essentially the inverse of
  ##               image_to_tiled_pyramid().
  ##             - It should be noted that this function isn't always an inverse of
  ##               image_to_tiled_pyramid().  This is because you can ask
  ##               image_to_tiled_pyramid() for the coordinates of points outside the input
  ##               image and they will be mapped to somewhere that doesn't have an inverse.  But
  ##               for points actually inside the image this function performs an approximate
  ##               inverse mapping.
  ##             - Assumes pyramid_type is the pyramid class used to produce the tiled image.
  ##     !
  ##  ----------------------------------------------------------------------------------------