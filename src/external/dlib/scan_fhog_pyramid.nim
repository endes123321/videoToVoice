##  Copyright (C) 2013  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  scan_fhog_pyramid_abstract, ../matrix, ../image_transforms, ../array, ../array2d,
  object_detector

##  ----------------------------------------------------------------------------------------

type
  default_fhog_feature_extractor* {.importcpp: "dlib::default_fhog_feature_extractor",
                                   header: "scan_fhog_pyramid.hnim", bycopy.} = object
  

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
##  ----------------------------------------------------------------------------------------

type
  scan_fhog_pyramid* {.importcpp: "dlib::scan_fhog_pyramid",
                      header: "scan_fhog_pyramid.hnim", bycopy.}[Pyramid_type;
      Feature_extractor_type] = object of noncopyable
  
  feature_vector_type* = matrix[cdouble, 0, 1]
  pyramid_type* = Pyramid_type
  feature_extractor_type* = Feature_extractor_type

proc constructscan_fhog_pyramid*[Pyramid_type; Feature_extractor_type](): scan_fhog_pyramid[
    Pyramid_type, Feature_extractor_type] {.constructor,
    importcpp: "dlib::scan_fhog_pyramid(@)", dynlib: dlibdll.}
proc constructscan_fhog_pyramid*[Pyramid_type; Feature_extractor_type](
    fe_: feature_extractor_type): scan_fhog_pyramid[Pyramid_type,
    Feature_extractor_type] {.constructor,
                             importcpp: "dlib::scan_fhog_pyramid(@)",
                             dynlib: dlibdll.}
proc load*[Pyramid_type; Feature_extractor_type; image_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    img: image_type) {.importcpp: "load", dynlib: dlibdll.}
proc is_loaded_with_image*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): bool {.
    noSideEffect, importcpp: "is_loaded_with_image", dynlib: dlibdll.}
proc copy_configuration*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    item: scan_fhog_pyramid) {.importcpp: "copy_configuration", dynlib: dlibdll.}
proc set_detection_window_size*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    width: culong; height: culong) {.importcpp: "set_detection_window_size",
                                 dynlib: dlibdll.}
proc get_detection_window_width*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_detection_window_width", dynlib: dlibdll.}
proc get_detection_window_height*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_detection_window_height", dynlib: dlibdll.}
proc get_num_detection_templates*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_num_detection_templates", dynlib: dlibdll.}
proc get_num_movable_components_per_detection_template*[Pyramid_type;
    Feature_extractor_type](this: scan_fhog_pyramid[Pyramid_type,
    Feature_extractor_type]): culong {.noSideEffect, importcpp: "get_num_movable_components_per_detection_template",
                                     dynlib: dlibdll.}
proc set_padding*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    new_padding: culong) {.importcpp: "set_padding", dynlib: dlibdll.}
proc get_padding*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_padding", dynlib: dlibdll.}
proc set_cell_size*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    new_cell_size: culong) {.importcpp: "set_cell_size", dynlib: dlibdll.}
proc get_cell_size*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_cell_size", dynlib: dlibdll.}
proc get_num_dimensions*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): clong {.
    noSideEffect, importcpp: "get_num_dimensions", dynlib: dlibdll.}
proc get_max_pyramid_levels*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_max_pyramid_levels", dynlib: dlibdll.}
proc get_feature_extractor*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): feature_extractor_type {.
    noSideEffect, importcpp: "get_feature_extractor", dynlib: dlibdll.}
proc set_max_pyramid_levels*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    max_levels: culong) {.importcpp: "set_max_pyramid_levels", dynlib: dlibdll.}
proc set_min_pyramid_layer_size*[Pyramid_type; Feature_extractor_type](
    this: var scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    width: culong; height: culong) {.importcpp: "set_min_pyramid_layer_size",
                                 dynlib: dlibdll.}
proc get_min_pyramid_layer_width*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_min_pyramid_layer_width", dynlib: dlibdll.}
proc get_min_pyramid_layer_height*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_min_pyramid_layer_height", dynlib: dlibdll.}
proc detect*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    w: feature_vector_type; dets: var vector[pair[cdouble, rectangle]];
    thresh: cdouble) {.noSideEffect, importcpp: "detect", dynlib: dlibdll.}
type
  fhog_filterbank* {.importcpp: "dlib::fhog_filterbank",
                    header: "scan_fhog_pyramid.hnim", bycopy.}[Pyramid_type;
      Feature_extractor_type] = object
    filters* {.importc: "filters".}: vector[matrix[cfloat]]
    row_filters* {.importc: "row_filters".}: vector[vector[matrix[cfloat, 0, 1]]]
    col_filters* {.importc: "col_filters".}: vector[vector[matrix[cfloat, 0, 1]]]


proc get_num_dimensions*[Pyramid_type; Feature_extractor_type](
    this: fhog_filterbank[Pyramid_type, Feature_extractor_type]): clong {.
    noSideEffect, importcpp: "get_num_dimensions", dynlib: dlibdll.}
proc get_filters*[Pyramid_type; Feature_extractor_type](
    this: fhog_filterbank[Pyramid_type, Feature_extractor_type]): vector[
    matrix[cfloat]] {.noSideEffect, importcpp: "get_filters", dynlib: dlibdll.}
proc num_separable_filters*[Pyramid_type; Feature_extractor_type](
    this: fhog_filterbank[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "num_separable_filters", dynlib: dlibdll.}
proc build_fhog_filterbank*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    weights: feature_vector_type): fhog_filterbank {.noSideEffect,
    importcpp: "build_fhog_filterbank", dynlib: dlibdll.}
proc detect*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    w: fhog_filterbank; dets: var vector[pair[cdouble, rectangle]]; thresh: cdouble) {.
    noSideEffect, importcpp: "detect", dynlib: dlibdll.}
proc get_feature_vector*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type];
    obj: full_object_detection; psi: var feature_vector_type) {.noSideEffect,
    importcpp: "get_feature_vector", dynlib: dlibdll.}
proc get_full_object_detection*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]; rect: rectangle;
    w: feature_vector_type): full_object_detection {.noSideEffect,
    importcpp: "get_full_object_detection", dynlib: dlibdll.}
proc get_best_matching_rect*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]; rect: rectangle): rectangle {.
    noSideEffect, importcpp: "get_best_matching_rect", dynlib: dlibdll.}
proc get_nuclear_norm_regularization_strength*[Pyramid_type;
    Feature_extractor_type](this: scan_fhog_pyramid[Pyramid_type,
    Feature_extractor_type]): cdouble {.noSideEffect, importcpp: "get_nuclear_norm_regularization_strength",
                                      dynlib: dlibdll.}
proc set_nuclear_norm_regularization_strength*[Pyramid_type;
    Feature_extractor_type](this: var scan_fhog_pyramid[Pyramid_type,
    Feature_extractor_type]; strength: cdouble) {.
    importcpp: "set_nuclear_norm_regularization_strength", dynlib: dlibdll.}
proc get_fhog_window_width*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_fhog_window_width", dynlib: dlibdll.}
proc get_fhog_window_height*[Pyramid_type; Feature_extractor_type](
    this: scan_fhog_pyramid[Pyramid_type, Feature_extractor_type]): culong {.
    noSideEffect, importcpp: "get_fhog_window_height", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc apply_filters_to_fhog*[fhog_filterbank](w: fhog_filterbank;
    feats: array[array2d[cfloat]]; saliency_image: var array2d[cfloat]): rectangle
##  ----------------------------------------------------------------------------------------

proc serialize*[T; U](item: scan_fhog_pyramid[T, U]; `out`: var ostream)
##  ----------------------------------------------------------------------------------------

proc deserialize*[T; U](item: var scan_fhog_pyramid[T, U]; `in`: var istream)
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##                          scan_fhog_pyramid member functions
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------

proc scan_fhog_pyramid*[Pyramid_type; feature_extractor_type](): scan_fhog_pyramid[
    Pyramid_type, feature_extractor_type]
##  ----------------------------------------------------------------------------------------

proc scan_fhog_pyramid*[Pyramid_type; feature_extractor_type](
    fe_: feature_extractor_type): scan_fhog_pyramid[Pyramid_type,
    feature_extractor_type]
##  ----------------------------------------------------------------------------------------

proc create_fhog_pyramid*[pyramid_type; image_type; feature_extractor_type](
    img: image_type; fe: feature_extractor_type;
    feats: var array[array[array2d[cfloat]]]; cell_size: cint;
    filter_rows_padding: cint; filter_cols_padding: cint;
    min_pyramid_layer_width: culong; min_pyramid_layer_height: culong;
    max_pyramid_levels: culong)
##  ----------------------------------------------------------------------------------------

proc scan_fhog_pyramid*[Pyramid_type; feature_extractor_type](img: image_type)
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------

proc compare_pair_rect*(a: pair[cdouble, rectangle]; b: pair[cdouble, rectangle]): bool
proc detect_from_fhog_pyramid*[pyramid_type; feature_extractor_type;
                              fhog_filterbank](
    feats: array[array[array2d[cfloat]]]; fe: feature_extractor_type;
    w: fhog_filterbank; thresh: cdouble; det_box_height: culong;
    det_box_width: culong; cell_size: cint; filter_rows_padding: cint;
    filter_cols_padding: cint; dets: var vector[pair[cdouble, rectangle]])
proc overlaps_any_box*(tester: test_box_overlap; rects: vector[rect_detection];
                      rect: rect_detection): bool
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------

proc configure_nuclear_norm_regularizer*[Pyramid_type; feature_extractor_type;
                                        svm_struct_prob_type](
    scanner: scan_fhog_pyramid[Pyramid_type, feature_extractor_type];
    prob: var svm_struct_prob_type)
##  ----------------------------------------------------------------------------------------

type
  processed_weight_vector* {.importcpp: "processed_weight_vector",
                            header: "scan_fhog_pyramid.hnim", bycopy.}[
      Pyramid_type; feature_extractor_type] = object
    w* {.importc: "w".}: feature_vector_type
    fb* {.importc: "fb".}: fhog_filterbank


proc constructprocessed_weight_vector*[Pyramid_type; feature_extractor_type](): processed_weight_vector[
    Pyramid_type, feature_extractor_type] {.constructor,
    importcpp: "processed_weight_vector(@)", dynlib: dlibdll.}
type
  feature_vector_type* = matrix[cdouble, 0, 1]

proc init*[Pyramid_type; feature_extractor_type](
    this: var processed_weight_vector[Pyramid_type, feature_extractor_type];
    scanner: scan_fhog_pyramid[Pyramid_type, feature_extractor_type]) {.
    importcpp: "init", dynlib: dlibdll.}
proc get_detect_argument*[Pyramid_type; feature_extractor_type](
    this: processed_weight_vector[Pyramid_type, feature_extractor_type]): fhog_filterbank {.
    noSideEffect, importcpp: "get_detect_argument", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------

proc evaluate_detectors*[pyramid_type; image_type](
    detectors: vector[object_detector[scan_fhog_pyramid[pyramid_type]]];
    img: image_type; dets: var vector[rect_detection]; adjust_threshold: cdouble = 0)
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
