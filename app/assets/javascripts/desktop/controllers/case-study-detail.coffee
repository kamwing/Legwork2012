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
    @$back_btn = @$el.find('#back-slide-btn')
    @$current_cnt = @$el.find('.current-cnt')
    @inmotion

    for slide in @model.slides
      slide_view = new Legwork.Slides[slide.type]({model: slide})
      $slides_wrap.append slide_view.build()
      @slide_views.push(slide_view)

    @$slides = $('.slide', @$el)

    return @$el

  ###
  *------------------------------------------*
  | initialize:void (-)
  |
  | Initialize slides after build
  *----------------------------------------###
  initialize: ->
    super()

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

    @turnOffKeyboardNav()
    @onResize = _.debounce(@afterResize, 300)
    Legwork.$wn.on('resize', @onResize)

    @current_slide_view = @slide_views[0]
    @current_slide_index = 0
    @current_slide_view.activate()

    @resetSlides()

    @$next_btn.on Legwork.click, @nextSlide
    @$back_btn.on Legwork.click, @priorSlide
    $('.project-callouts h4', @$el).on Legwork.click, =>
      @$next_btn.trigger Legwork.click

  ###
  *------------------------------------------*
  | deactivate:void (-)
  |
  | Hides the element
  *----------------------------------------###
  deactivate: ->
    super()

    @current_slide_view.deactivate()

    if @inmotion then return false
    else @inmotion is true

    Legwork.$wn.off('resize', @onResize)
    @$next_btn.off Legwork.click
    @$back_btn.off Legwork.click
    $('.project-callouts h4', @$el).off Legwork.click

    @turnOffKeyboardNav()

  ###
  *------------------------------------------*
  | resetSlides:void (-)
  |
  | Reset the slides so that the
  | title-screen slide is first/current
  *----------------------------------------###
  resetSlides: =>
    @$slides.removeClass('current').css
      'left':'100%'

    @$slides.eq(@current_slide_index).addClass('current').css
      'left':'0%'

    @$current_cnt.text(@current_slide_index + 1)
    @$el.find('.total-cnt').text(@slide_views.length)

    @$back_btn.css 'top','-50px'

  ###
  *------------------------------------------*
  | afterResize:void (=)
  |
  | Call after resize complete
  *----------------------------------------###
  afterResize: =>
    w = Legwork.$wn.width()
    h = Legwork.$wn.height()
    @current_slide_view.resize(w, h)

    if w <= 740
      
      if @current_slide_index isnt 0
        @current_slide_view.deactivate()
        @current_slide_index = 0
        @current_slide_view = @slide_views[@current_slide_index]
        @current_slide_view.activate()
        @resetSlides()
      
      if @handlingArrowKeys is true then @turnOffKeyboardNav()
    else
      if @handlingArrowKeys is false then @turnOnKeyboardNav()

  ###
  *------------------------------------------*
  | nextSlide:void (=)
  |
  | Next. Next slide.
  *----------------------------------------###
  nextSlide: =>
    if @inmotion then return false
    else @inmotion = true

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
      @old_slide_view.deactivate()
      
      if @current_slide_index is 1
        @$back_btn.css 'top','0px'
      
      @inmotion = false

  ###
  *------------------------------------------*
  | priorSlide:void (=)
  |
  | Prior. Prior slide.
  *----------------------------------------###
  priorSlide: =>
    if @inmotion then return false
    else @inmotion = true

    @old_slide_index = @current_slide_index
    @old_slide_view = @current_slide_view

    @current_slide_index = if @current_slide_index > 0 then @current_slide_index - 1 else @slide_views.length - 1
    @current_slide_view = @slide_views[@current_slide_index]
    @current_slide_view.activate()

    @$current_cnt.text(@current_slide_index + 1)

    if @current_slide_index is 0
      @$back_btn.css 'top','-50px'

    @$slides.css('left','100%')
    @old_slide_view.$el.removeClass('current').css({'left': '0%', 'z-index': '1'})
    @current_slide_view.$el.addClass('current').css({'left':'-100%', 'z-index':'2'}).stop().animate
      left: '-0%'
    , 666, 'easeInOutExpo', =>
      @old_slide_view.deactivate()
      @inmotion = false

  ###
  *------------------------------------------*
  | handleArrowKeys:void (=)
  |
  | Determine wich direction to slide
  | based on left or right arrow key hit
  *----------------------------------------###
  handleArrowKeys: (e) =>
    kc = e.keyCode

    if kc is 37
      e.preventDefault()
      @priorSlide()

    if kc is 39
      e.preventDefault()
      @nextSlide()

  ###
  *------------------------------------------*
  | turnOffKeyboardNav:void (=)
  |
  | Turn off keyboard nav
  *----------------------------------------###
  turnOffKeyboardNav: =>
    @handlingArrowKeys = false
    Legwork.$doc.off 'keyup.slider', @handleArrowKeys

  ###
  *------------------------------------------*
  | turnOnKeyboardNav:void (=)
  |
  | Turn on keyboard nav
  *----------------------------------------###
  turnOnKeyboardNav: =>
    @handlingArrowKeys = true
    Legwork.$doc.on 'keyup.slider', @handleArrowKeys










