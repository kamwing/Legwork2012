###

Copyright (c) 2012 Legwork Studio. All Rights Reserved. Your wife is hot.

###
class Legwork.CaseStudyDetail extends Legwork.Controllers.BaseDetail

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | options:object - initialization object
  |
  | Construct the fuggin' thing.
  *----------------------------------------###
  constructor: (options) ->
    super(options)

    # Class vars
    @slide_views = []

  ###
  *------------------------------------------*
  | build:$el (-)
  |
  | Build DOM based on model.
  *----------------------------------------###
  build: ->
    super()

    $slides_wrap = @$el.find('.slides')
    @$next_btn = @$el.find('.next-slide-btn')
    @$current_cnt = @$el.find('.current-cnt')

    for slide in @model.slides
      slide_view = new slide.type({model: slide})
      $slides_wrap.append slide_view.build()
      @slide_views.push(slide_view)

    @$slides = @$el.find('.slide')

    return @$el

  ###
  *------------------------------------------*
  | initialize:void (-)
  |
  | Initialize slides after build
  *----------------------------------------###
  initialize: ->
    for view in @slide_views
      view.initialize()

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Shows the element
  *----------------------------------------###
  activate: ->
    super()

    @resetSlides()

    @$next_btn.on Legwork.click, @nextSlide
    Legwork.$doc.on 'keyup.slider', @handleArrowKeys

    @$el.find('.project-callouts h4').on Legwork.click, =>
      @$next_btn.trigger Legwork.click

    @onResize = _.debounce(@afterResize, 300)
    Legwork.$wn.on('resize', @onResize)

  ###
  *------------------------------------------*
  | deactivate:void (-)
  |
  | Hides the element
  *----------------------------------------###
  deactivate: ->
    super()

    @current_slide_view.deactivate()

    @$next_btn.off Legwork.click, @nextSlide
    Legwork.$doc.off 'keyup.slider', @handleArrowKeys

    Legwork.$wn.off('resize', @onResize)

  ###
  *------------------------------------------*
  | resetSlides:void (-)
  |
  | Reset the slides so that the
  | title-screen slide is first/current
  *----------------------------------------###
  resetSlides: ->
    @current_slide_view = @slide_views[0]
    @current_slide_index = 0

    @$slides.removeClass('current').css('left', '100%')
    @$slides.eq(@current_slide_index).addClass('current').css('left', '0%')

    @$current_cnt.text(@current_slide_index + 1)
    @$el.find('.total-cnt').text(@slide_views.length)

  ###
  *------------------------------------------*
  | afterResize:void (-)
  |
  | Call after resize complete
  *----------------------------------------###
  afterResize: =>
    w = Legwork.$wn.width()
    h = Legwork.$wn.height()
    @current_slide_view.resize(w, h)

  ###
  *------------------------------------------*
  | nextSlide:void (=)
  |
  | Next. Next slide.
  *----------------------------------------###
  nextSlide: =>
    @$next_btn.off Legwork.click, @nextSlide
    Legwork.$doc.off 'keyup.slider', @handleArrowKeys

    @old_slide_index = @current_slide_index
    @old_slide_view = @current_slide_view

    @current_slide_index = if @current_slide_index < @slide_views.length - 1 then @current_slide_index + 1 else 0
    @current_slide_view = @slide_views[@current_slide_index]
    @current_slide_view.activate()

    @$current_cnt.text(@current_slide_index + 1)

    @$slides.css('left','100%')
    @current_slide_view.$el.addClass('current').css({'left': '0%', 'z-index': '1'})
    @old_slide_view.$el.removeClass('current').css({'left':'0%', 'z-index':'2'}).stop().animate
      left: '-100%'
    , 666, 'easeInOutExpo', =>
      @$next_btn.on Legwork.click, @nextSlide
      Legwork.$doc.on 'keyup.slider', @handleArrowKeys
      @old_slide_view.deactivate()

  ###
  *------------------------------------------*
  | priorSlide:void (=)
  |
  | Prior. Prior slide.
  *----------------------------------------###
  priorSlide: =>
    @$next_btn.off Legwork.click, @nextSlide
    Legwork.$doc.off 'keyup.slider', @handleArrowKeys

    @old_slide_index = @current_slide_index
    @old_slide_view = @current_slide_view
    
    @current_slide_index = if @current_slide_index > 0 then @current_slide_index - 1 else @slide_views.length - 1
    @current_slide_view = @slide_views[@current_slide_index]
    @current_slide_view.activate()

    @$current_cnt.text(@current_slide_index + 1)

    @$slides.css('left','100%')
    @old_slide_view.$el.removeClass('current').css({'left': '0%', 'z-index': '1'})
    @current_slide_view.$el.addClass('current').css({'left':'-100%', 'z-index':'2'}).stop().animate
      left: '-0%'
    , 666, 'easeInOutExpo', =>
      @$next_btn.on Legwork.click, @nextSlide
      Legwork.$doc.on 'keyup.slider', @handleArrowKeys
      @old_slide_view.deactivate()

  ###
  *------------------------------------------*
  | handleArrowKeys:void (=)
  |
  | Determine wich direction to slide
  | based on left or right arrow key hit
  *----------------------------------------###
  handleArrowKeys: (e) =>
    kc = e.keyCode

    if kc is 39 then @nextSlide()
    if kc is 37 then @priorSlide()








