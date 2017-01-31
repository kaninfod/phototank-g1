@PhotoGrid = React.createClass
  getInitialState: ->
    photos: []
    bucket: []
    nextPageURL: "photos.json?page=1"
    offset: 800
    loading: true

  getDefaultProps: ->
    photos: []

  render: ->
    React.DOM.div {className: 'photos-component'},
      React.DOM.div {className: 'row photogrid'},
        @loadPhotos()
      React.DOM.div {className: "row loadMore"},

  loadPhotos: ->
    for photo in @state.photos
      photo.bucket = @state.bucket.includes photo.id
      React.createElement PhotoWidget, key: photo.id, photo: photo

  componentWillMount: ->
    @getPhotos()

  componentDidUpdate: ->
    $(window).scroll event, => @handleScroll(event)
    $('.lazy').lazyload()

  componentDidMount: ->


  componentWillUnmount: ->
    $(window).unbind('scroll');

  getPhotos: ->
    $.getJSON @state.nextPageURL, (data) =>
      photos = @state.photos.concat(data.photos)
      @setState photos: photos, nextPageURL: @extractURL(data.pagi), loading: true, bucket:data.bucket

  extractURL: (string)->
    url = $('<div/>').html(string).find(".next_page").attr('href')
    return url

  handleScroll: (event) ->
    scrollPosition = $('.loadMore').offset().top  - ($(window).height() + $(window).scrollTop() + @state.offset)
    if scrollPosition < 0 and @state.loading and @state.nextPageURL != undefined
      @setState loading: false
      @getPhotos()

PhotoWidget = React.createClass
  render: ->
    React.DOM.div
      id: @props.photo.id
      className: "photo-widget z-depth-1"
      onMouseEnter: @handleHover
      onMouseLeave: @handleHover
      ref: 'widget'
      React.DOM.div {className: "photo-widget-content"},
        React.DOM.div {className: "photo-widget-header"},

          React.DOM.div
            className: "overlay-button overlay-select " + if @props.photo.bucket then 'selected'
            onClick: @handleSelect
            ref: 'select'
            React.DOM.i {className: "material-icons"},
              "check"

          React.DOM.div
            className: "overlay-button overlay-zoom"
            onClick: @handleZoom
            React.DOM.i {className: "material-icons"},
              "zoom_out_map"

          React.DOM.div
            className: "overlay-button overlay-delete"
            onClick: @handleDelete
            React.DOM.i {className: "material-icons"},
              "delete_forever"

          React.DOM.div {className: "overlay-button overlay-processing"},
            React.DOM.i {className: "material-icons"},
              "update"

          React.DOM.img {className: "lazy", id: @props.photo.id, "data-original": @props.photo.url, href: "#animatedModal"},
        React.DOM.div {className: "photo-widget-date"},
          @props.photo.date_taken

  handleSelect: ->
    $(this.refs.select).toggleClass('selected')
    App.Bucket.bucketPhoto(@props.photo.id)

  handleZoom: ->
    console.log "zoom"
    f=Math.random()
    ReactDOM.render React.createElement(Modalxxx, {kaj: f, photo: @props.photo}), document.getElementById('root')
    #React.createElement Modalxxx
    #App.PhotoWidget.showModal(@props.photo.id)

  handleDelete: ->
    App.PhotoWidget.deletePhoto @props.photo.id, =>
      $(this.refs.widget).fadeOut(700)

  handleHover: (e) ->
    overlayButton = $(this.refs.widget).find(".overlay-button:not(.overlay-processing)")
    if e.type == 'mouseenter'
      overlayButton.addClass('overlay-show')
    else
      overlayButton.removeClass('overlay-show')
