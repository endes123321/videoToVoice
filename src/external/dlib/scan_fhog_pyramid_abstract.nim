##  Copyright (C) 2013  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

when defined(DLIB_SCAN_fHOG_PYRAMID_ABSTRACT_Hh_):
  import
    ../image_transforms/fhog_abstract, object_detector_abstract

  ##  ----------------------------------------------------------------------------------------
  proc draw_fhog*[Pyramid_type; feature_extractor_type](detector: object_detector[
      scan_fhog_pyramid[Pyramid_type, feature_extractor_type]];
      weight_index: culong = 0; cell_draw_size: clong = 15): matrix[cuchar] {.
      importcpp: "dlib::draw_fhog(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - cell_draw_size > 0
  ##             - weight_index < detector.num_detectors()
  ##             - detector.get_w(weight_index).size() >= detector.get_scanner().get_num_dimensions()
  ##               (i.e. the detector must have been populated with a HOG filter)
  ##         ensures
  ##             - Converts the HOG filters in the given detector (specifically, the filters in
  ##               detector.get_w(weight_index)) into an image suitable for display on the
  ##               screen.  In particular, we draw all the HOG cells into a grayscale image in a
  ##               way that shows the magnitude and orientation of the gradient energy in each
  ##               cell.  The resulting image is then returned.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc num_separable_filters*[Pyramid_type; feature_extractor_type](detector: object_detector[
      scan_fhog_pyramid[Pyramid_type, feature_extractor_type]];
      weight_index: culong = 0): culong {.importcpp: "dlib::num_separable_filters(@)",
                                     dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - weight_index < detector.num_detectors()
  ##             - detector.get_w(weight_index).size() >= detector.get_scanner().get_num_dimensions()
  ##               (i.e. the detector must have been populated with a HOG filter)
  ##         ensures
  ##             - Returns the number of separable filters necessary to represent the HOG
  ##               filters in the given detector's weight_index'th filter.  This is the filter
  ##               defined by detector.get_w(weight_index).
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc threshold_filter_singular_values*[Pyramid_type; feature_extractor_type](
      detector: object_detector[scan_fhog_pyramid[Pyramid_type,
      feature_extractor_type]]; thresh: cdouble; weight_index: culong = 0): object_detector[
      scan_fhog_pyramid[Pyramid_type, feature_extractor_type]] {.
      importcpp: "dlib::threshold_filter_singular_values(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - thresh >= 0
  ##             - weight_index < detector.num_detectors()
  ##             - detector.get_w(weight_index).size() >= detector.get_scanner().get_num_dimensions()
  ##               (i.e. the detector must have been populated with a HOG filter)
  ##         ensures
  ##             - Removes all components of the filters in the given detector that have
  ##               singular values that are smaller than the given threshold.  Therefore, this
  ##               function allows you to control how many separable filters are in a detector.
  ##               In particular, as thresh gets larger the quantity
  ##               num_separable_filters(threshold_filter_singular_values(detector,thresh,weight_index),weight_index)
  ##               will generally get smaller and therefore give a faster running detector.
  ##               However, note that at some point a large enough thresh will drop too much
  ##               information from the filters and their accuracy will suffer.  
  ##             - returns the updated detector
  ##     !
  ##  ----------------------------------------------------------------------------------------
  type
    default_fhog_feature_extractor* {.importcpp: "dlib::default_fhog_feature_extractor",
                                     header: "scan_fhog_pyramid_abstract.hnim",
                                     bycopy.} = object ## !
                                                    ##             WHAT THIS OBJECT REPRESENTS
                                                    ##                 The scan_fhog_pyramid object defined below is primarily meant to be used
                                                    ##                 with the feature extraction technique implemented by extract_fhog_features().  
                                                    ##                 This technique can generally be understood as taking an input image and
                                                    ##                 outputting a multi-planed output image of floating point numbers that
                                                    ##                 somehow describe the image contents.  Since there are many ways to define
                                                    ##                 how this feature mapping is performed, the scan_fhog_pyramid allows you to
                                                    ##                 replace the extract_fhog_features() method with a customized method of your
                                                    ##                 choosing.  To do this you implement a class with the same interface as
                                                    ##                 default_fhog_feature_extractor.  
                                                    ## 
                                                    ##                 Therefore, the point of default_fhog_feature_extractor is two fold.  First,
                                                    ##                 it provides the default FHOG feature extraction method used by scan_fhog_pyramid.
                                                    ##                 Second, it serves to document the interface you need to implement to define 
                                                    ##                 your own custom HOG style feature extraction. 
                                                    ##         !
    
  proc image_to_feats*(this: default_fhog_feature_extractor; rect: rectangle;
                      cell_size: cint; filter_rows_padding: cint;
                      filter_cols_padding: cint): rectangle {.noSideEffect,
      importcpp: "image_to_feats", dynlib: dlibdll.}
  proc feats_to_image*(this: default_fhog_feature_extractor; rect: rectangle;
                      cell_size: cint; filter_rows_padding: cint;
                      filter_cols_padding: cint): rectangle {.noSideEffect,
      importcpp: "feats_to_image", dynlib: dlibdll.}
  proc `()`*[image_type](this: default_fhog_feature_extractor; img: image_type;
                        hog: var array[array2d[cfloat]]; cell_size: cint;
                        filter_rows_padding: cint; filter_cols_padding: cint) {.
      noSideEffect, importcpp: "#(@)", dynlib: dlibdll.}
  proc get_num_planes*(this: default_fhog_feature_extractor): culong {.noSideEffect,
      importcpp: "get_num_planes", dynlib: dlibdll.}
  proc serialize*(a2: default_fhog_feature_extractor; a3: var ostream)
  proc deserialize*(a2: var default_fhog_feature_extractor; a3: var istream)


  ## !
  ##         Provides serialization support.  Note that there is no state in the default hog
  ##         feature extractor so these functions do nothing.  But if you define a custom
  ##         feature extractor then make sure you remember to serialize any state in your
  ##         feature extractor.
  ##     !
  ##  -------------------------------------------------------------------------------------
  type
    scan_fhog_pyramid* {.importcpp: "dlib::scan_fhog_pyramid",
                        header: "scan_fhog_pyramid_abstract.hnim", bycopy.} = object of noncopyable ## !
                                                                                             ##             REQUIREMENTS ON Pyramid_type
                                                                                             ##                 - Must be one of the pyramid_down objects defined in
                                                                                             ##                   dlib/image_transforms/image_pyramid_abstract.h or an object with a
                                                                                             ##                   compatible interface
                                                                                             ## 
                                                                                             ##             REQUIREMENTS ON Feature_extractor_type
                                                                                             ##                 - Must be a type with an interface compatible with the
                                                                                             ##                   default_fhog_feature_extractor.
                                                                                             ## 
                                                                                             ##             INITIAL VALUE
                                                                                             ##                 - get_padding()   == 1
                                                                                             ##                 - get_cell_size() == 8
                                                                                             ##                 - get_detection_window_width()   == 64
                                                                                             ##                 - get_detection_window_height()  == 64
                                                                                             ##                 - get_max_pyramid_levels()       == 1000
                                                                                             ##                 - get_min_pyramid_layer_width()  == 64
                                                                                             ##                 - get_min_pyramid_layer_height() == 64
                                                                                             ##                 - get_nuclear_norm_regularization_strength() == 0
                                                                                             ## 
                                                                                             ##             WHAT THIS OBJECT REPRESENTS
                                                                                             ##                 This object is a tool for running a fixed sized sliding window classifier
                                                                                             ##                 over an image pyramid.  In particular,  it slides a linear classifier over
                                                                                             ##                 a HOG pyramid as discussed in the paper:  
                                                                                             ##                     Histograms of Oriented Gradients for Human Detection by Navneet Dalal
                                                                                             ##                     and Bill Triggs, CVPR 2005
                                                                                             ##                 However, we augment the method slightly to use the version of HOG features 
                                                                                             ##                 from: 
                                                                                             ##                     Object Detection with Discriminatively Trained Part Based Models by
                                                                                             ##                     P. Felzenszwalb, R. Girshick, D. McAllester, D. Ramanan
                                                                                             ##                     IEEE Transactions on Pattern Analysis and Machine Intelligence, Vol. 32, No. 9, Sep. 2010
                                                                                             ##                 Since these HOG features have been shown to give superior performance. 
                                                                                             ## 
                                                                                             ##             THREAD SAFETY
                                                                                             ##                 Concurrent access to an instance of this object is not safe and should be
                                                                                             ##                 protected by a mutex lock except for the case where you are copying the
                                                                                             ##                 configuration (via copy_configuration()) of a scan_fhog_pyramid object to
                                                                                             ##                 many other threads.  In this case, it is safe to copy the configuration of
                                                                                             ##                 a shared object so long as no other operations are performed on it.
                                                                                             ##         !
    
    feature_vector_type* = matrix[cdouble, 0, 1]
    pyramid_type* = Pyramid_type
    feature_extractor_type* = Feature_extractor_type
  proc constructscan_fhog_pyramid*(): scan_fhog_pyramid {.constructor,
      importcpp: "dlib::scan_fhog_pyramid(@)", dynlib: dlibdll.}
  proc constructscan_fhog_pyramid*(fe: feature_extractor_type): scan_fhog_pyramid {.
      constructor, importcpp: "dlib::scan_fhog_pyramid(@)", dynlib: dlibdll.}
  proc load*[image_type](this: var scan_fhog_pyramid; img: image_type) {.
      importcpp: "load", dynlib: dlibdll.}
  proc get_feature_extractor*(this: scan_fhog_pyramid): feature_extractor_type {.
      noSideEffect, importcpp: "get_feature_extractor", dynlib: dlibdll.}
  proc is_loaded_with_image*(this: scan_fhog_pyramid): bool {.noSideEffect,
      importcpp: "is_loaded_with_image", dynlib: dlibdll.}
  proc copy_configuration*(this: var scan_fhog_pyramid; item: scan_fhog_pyramid) {.
      importcpp: "copy_configuration", dynlib: dlibdll.}
  proc set_detection_window_size*(this: var scan_fhog_pyramid; window_width: culong;
                                 window_height: culong) {.
      importcpp: "set_detection_window_size", dynlib: dlibdll.}
  proc get_detection_window_width*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_detection_window_width", dynlib: dlibdll.}
  proc get_detection_window_height*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_detection_window_height", dynlib: dlibdll.}
  proc get_fhog_window_width*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_fhog_window_width", dynlib: dlibdll.}
  proc get_fhog_window_height*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_fhog_window_height", dynlib: dlibdll.}
  proc set_padding*(this: var scan_fhog_pyramid; new_padding: culong) {.
      importcpp: "set_padding", dynlib: dlibdll.}
  proc get_padding*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_padding", dynlib: dlibdll.}
  proc get_cell_size*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_cell_size", dynlib: dlibdll.}
  proc set_cell_size*(this: var scan_fhog_pyramid; new_cell_size: culong) {.
      importcpp: "set_cell_size", dynlib: dlibdll.}
  proc get_num_dimensions*(this: scan_fhog_pyramid): clong {.noSideEffect,
      importcpp: "get_num_dimensions", dynlib: dlibdll.}
  proc get_num_detection_templates*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_num_detection_templates", dynlib: dlibdll.}
  proc get_num_movable_components_per_detection_template*(this: scan_fhog_pyramid): culong {.
      noSideEffect,
      importcpp: "get_num_movable_components_per_detection_template",
      dynlib: dlibdll.}
  proc get_max_pyramid_levels*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_max_pyramid_levels", dynlib: dlibdll.}
  proc set_max_pyramid_levels*(this: var scan_fhog_pyramid; max_levels: culong) {.
      importcpp: "set_max_pyramid_levels", dynlib: dlibdll.}
  proc set_min_pyramid_layer_size*(this: var scan_fhog_pyramid; width: culong;
                                  height: culong) {.
      importcpp: "set_min_pyramid_layer_size", dynlib: dlibdll.}
  proc get_min_pyramid_layer_width*(this: scan_fhog_pyramid): culong {.noSideEffect,
      importcpp: "get_min_pyramid_layer_width", dynlib: dlibdll.}
  proc get_min_pyramid_layer_height*(this: scan_fhog_pyramid): culong {.
      noSideEffect, importcpp: "get_min_pyramid_layer_height", dynlib: dlibdll.}
  proc build_fhog_filterbank*(this: scan_fhog_pyramid; weights: feature_vector_type): fhog_filterbank {.
      noSideEffect, importcpp: "build_fhog_filterbank", dynlib: dlibdll.}
  type
    fhog_filterbank* {.importcpp: "dlib::fhog_filterbank",
                      header: "scan_fhog_pyramid_abstract.hnim", bycopy.} = object ## !
                                                                              ##                 WHAT THIS OBJECT REPRESENTS
                                                                              ##                     This object represents a HOG filter bank.  That is, the classifier that is 
                                                                              ##                     slid over a HOG pyramid is a set of get_feature_extractor().get_num_planes() 
                                                                              ##                     linear filters, each get_fhog_window_width() rows by get_fhog_window_height() 
                                                                              ##                     columns in size.  This object contains that set of filters.  
                                                                              ##             !
    
  proc get_num_dimensions*(this: fhog_filterbank): clong {.noSideEffect,
      importcpp: "get_num_dimensions", dynlib: dlibdll.}
  proc get_filters*(this: fhog_filterbank): vector[matrix[cfloat]] {.noSideEffect,
      importcpp: "get_filters", dynlib: dlibdll.}
  proc num_separable_filters*(this: fhog_filterbank): culong {.noSideEffect,
      importcpp: "num_separable_filters", dynlib: dlibdll.}
  proc detect*(this: scan_fhog_pyramid; w: fhog_filterbank;
              dets: var vector[pair[cdouble, rectangle]]; thresh: cdouble) {.
      noSideEffect, importcpp: "detect", dynlib: dlibdll.}
  proc detect*(this: scan_fhog_pyramid; w: feature_vector_type;
              dets: var vector[pair[cdouble, rectangle]]; thresh: cdouble) {.
      noSideEffect, importcpp: "detect", dynlib: dlibdll.}
  proc get_feature_vector*(this: scan_fhog_pyramid; obj: full_object_detection;
                          psi: var feature_vector_type) {.noSideEffect,
      importcpp: "get_feature_vector", dynlib: dlibdll.}
  proc get_full_object_detection*(this: scan_fhog_pyramid; rect: rectangle;
                                 w: feature_vector_type): full_object_detection {.
      noSideEffect, importcpp: "get_full_object_detection", dynlib: dlibdll.}
  proc get_best_matching_rect*(this: scan_fhog_pyramid; rect: rectangle): rectangle {.
      noSideEffect, importcpp: "get_best_matching_rect", dynlib: dlibdll.}
  proc get_nuclear_norm_regularization_strength*(this: scan_fhog_pyramid): cdouble {.
      noSideEffect, importcpp: "get_nuclear_norm_regularization_strength",
      dynlib: dlibdll.}
  proc set_nuclear_norm_regularization_strength*(this: var scan_fhog_pyramid;
      strength: cdouble) {.importcpp: "set_nuclear_norm_regularization_strength",
                         dynlib: dlibdll.}


  ##  ----------------------------------------------------------------------------------------
  proc serialize*[T](item: scan_fhog_pyramid[T]; `out`: var ostream) {.
      importcpp: "dlib::serialize(@)", dynlib: dlibdll.}
  ## !
  ##         provides serialization support 
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc deserialize*[T](item: var scan_fhog_pyramid[T]; `in`: var istream) {.
      importcpp: "dlib::deserialize(@)", dynlib: dlibdll.}
  ## !
  ##         provides deserialization support 
  ##     !
  ##  ----------------------------------------------------------------------------------------
  ##  ----------------------------------------------------------------------------------------
  proc evaluate_detectors*[pyramid_type; image_type](
      detectors: vector[object_detector[scan_fhog_pyramid[pyramid_type]]];
      img: image_type; dets: var vector[rect_detection];
      adjust_threshold: cdouble = 0) {.importcpp: "dlib::evaluate_detectors(@)",
                                   dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - image_type == is an implementation of array2d/array2d_kernel_abstract.h
  ##             - img contains some kind of pixel type. 
  ##               (i.e. pixel_traits<typename image_type::type> is defined)
  ##         ensures
  ##             - This function runs each of the provided object_detector objects over img and
  ##               stores the resulting detections into #dets.  Importantly, this function is
  ##               faster than running each detector individually because it computes the HOG
  ##               features only once and then reuses them for each detector.  However, it is
  ##               important to note that this speedup is only possible if all the detectors use
  ##               the same cell_size parameter that determines how HOG features are computed.
  ##               If different cell_size values are used then this function will not be any
  ##               faster than running the detectors individually.
  ##             - This function applies non-max suppression individually to the output of each
  ##               detector.  Therefore, the output is the same as if you ran each detector
  ##               individually and then concatenated the results. 
  ##             - To be precise, this function performs object detection on the given image and
  ##               stores the detected objects into #dets.  In particular, we will have that:
  ##                 - #dets is sorted such that the highest confidence detections come first.
  ##                   E.g. element 0 is the best detection, element 1 the next best, and so on.
  ##                 - #dets.size() == the number of detected objects.
  ##                 - #dets[i].detection_confidence == The strength of the i-th detection.
  ##                   Larger values indicate that the detector is more confident that #dets[i]
  ##                   is a correct detection rather than being a false alarm.  Moreover, the
  ##                   detection_confidence is equal to the detection value output by the
  ##                   scanner minus the threshold value stored at the end of the weight vector.
  ##                 - #dets[i].rect == the bounding box for the i-th detection.
  ##                 - The detection #dets[i].rect was produced by detectors[#dets[i].weight_index].
  ##             - The detection threshold is adjusted by having adjust_threshold added to it.
  ##               Therefore, an adjust_threshold value > 0 makes detecting objects harder while
  ##               a negative value makes it easier.  Moreover, the following will be true for
  ##               all valid i:
  ##                 - #dets[i].detection_confidence >= adjust_threshold
  ##               This means that, for example, you can obtain the maximum possible number of
  ##               detections by setting adjust_threshold equal to negative infinity.
  ##             - This function is threadsafe in the sense that multiple threads can call
  ##               evaluate_detectors() with the same instances of detectors and img without
  ##               requiring a mutex lock.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc evaluate_detectors*[pyramid_type; image_type](
      detectors: vector[object_detector[scan_fhog_pyramid[pyramid_type]]];
      img: image_type; adjust_threshold: cdouble = 0): vector[rectangle] {.
      importcpp: "dlib::evaluate_detectors(@)", dynlib: dlibdll.}
  ## !
  ##         requires
  ##             - image_type == is an implementation of array2d/array2d_kernel_abstract.h
  ##             - img contains some kind of pixel type. 
  ##               (i.e. pixel_traits<typename image_type::type> is defined)
  ##         ensures
  ##             - This function just calls the above evaluate_detectors() routine and copies
  ##               the output dets into a vector<rectangle> object and returns it.  Therefore,
  ##               this function is provided for convenience.
  ##             - This function is threadsafe in the sense that multiple threads can call
  ##               evaluate_detectors() with the same instances of detectors and img without
  ##               requiring a mutex lock.
  ##     !
  ##  ----------------------------------------------------------------------------------------