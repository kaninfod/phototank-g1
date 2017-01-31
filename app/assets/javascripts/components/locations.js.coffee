@Locations = React.createClass
  getInitialState: ->
    locations: []
    nextPageURL: "locations.json?page=1"
    offset: 800
    loading: true


  getDefaultProps: ->
    locations: []

  render: ->
    React.DOM.div {className: 'locations'},
      React.DOM.div {className: 'row container-cards'},
        @loadLocations()
      React.DOM.div {className: "loadMore"},

  loadLocations: ->
    for location in @state.locations
      React.createElement LocationItem, key: location.id, location: location

  componentWillMount: ->
    @getLocations()

  componentDidMount: ->
    $(window).scroll event, => @handleScroll(event)

  getLocations: ->
    $.getJSON @state.nextPageURL, (data) =>
      locations = @state.locations.concat(data.locations)
      @setState locations: locations, nextPageURL: @extractURL(data.pagi), loading: true

  extractURL: (string)->
    url = $('<div/>').html(string).find(".next_page").attr('href')
    return url

  componentWillUnmount: ->
    $(window).unbind('scroll');

  handleScroll: (event) ->
    scrollPosition = $('.loadMore').offset().top  - ($(window).height() + $(window).scrollTop() + @state.offset)
    if scrollPosition < 0 and @state.loading and @state.nextPageURL != undefined
      @setState loading: false
      @getLocations()

LocationItem = React.createClass
  render: ->
    React.DOM.div {id: @props.location.id, className: "col"},
      React.DOM.div {className: "custom-card"},
        React.DOM.div {className: "card"},
          React.DOM.div {className: "card-image waves-effect waves-block waves-light"},
            React.DOM.a {className: "btn-floating btn-large btn-price pink"},
              @props.location.count
            React.DOM.img {className: "limit-size", alt: "product-img", src: @props.location.map_url},
          React.DOM.ul {className: "card-action-buttons"},
            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light green"
                href: "/locations/" + @props.location.id
                React.DOM.i {className: "material-icons"},
                  "photo"
          React.DOM.div {className: "card-content"},
            React.DOM.p {className: "card-title grey-text text-darken-4 truncate"},
              @props.location.address
