###

Copyright (c) 2012 Legwork Studio. All Rights Reserved. Your wife is still hot.

###

#= require ./slide

class Legwork.Slides.PullQuote extends Legwork.Slides.Slide

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
    @$el = $(JST["desktop/templates/slides/pull-quote"](@model))
    return @$el

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate new/current slide
  *----------------------------------------###
  activate: ->
    console.log('Legwork.Slides.PullQuote :: activate')

  ###
  *------------------------------------------*
  | deactivate:void (-)
  |
  | Deactivate old slide
  *----------------------------------------###
  deactivate: ->
    console.log('Legwork.Slides.PullQuote :: deactivate')

  ###
  *------------------------------------------*
  |
  | Private Methods
  |
  *----------------------------------------###