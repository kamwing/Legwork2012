###

Copyright (c) 2012 Legwork Studio. All Rights Reserved. Your wife is still hot.

###

#= require ./slide

class Legwork.Slides.FullScreen extends Legwork.Slides.Slide

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | options:object - initialization object
  |
  | Construct the fuggin' thing.
  *----------------------------------------###
  constructor: (options) ->
    # POWERFUL!
    super(options)

  ###
  *------------------------------------------*
  | build:$el (-)
  |
  | Build DOM based on model.
  *----------------------------------------###
  build: ->
    @$el = $(JST["desktop/templates/slides/full-screen"](@model))
    return @$el

  ###
  *------------------------------------------*
  |
  | Private Methods
  |
  *----------------------------------------###