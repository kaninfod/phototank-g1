@Catalogs = React.createClass
  getInitialState: ->
    catalogs: []
    nextPageURL: "catalogs.json?page=1"
    offset: 800
    loading: true


  getDefaultProps: ->
    catalogs: []

  render: ->
    React.DOM.div {className: 'catalogs'},
      React.DOM.div {className: 'row container-cards'},
        @loadCatalogs()
      React.DOM.div {className: "loadMore"},

  loadCatalogs: ->
    for catalog in @state.catalogs
      React.createElement CatalogItem, key: catalog.id, catalog: catalog

  componentDidMount: ->
    $(window).scroll event, => @handleScroll(event)
    @getCatalogs()

  getCatalogs: ->
    $.getJSON @state.nextPageURL, (data) =>
      catalogs = @state.catalogs.concat(data.catalogs)
      @setState catalogs: catalogs, nextPageURL: @extractURL(data.pagi), loading: true

  extractURL: (string)->
    url = $('<div/>').html(string).find(".next_page").attr('href')
    return url

  componentWillUnmount: ->
    $(window).unbind('scroll');

  handleScroll: (event) ->
    scrollPosition = $('.loadMore').offset().top  - ($(window).height() + $(window).scrollTop() + @state.offset)
    if scrollPosition < 0 and @state.loading and @state.nextPageURL != undefined
      @setState loading: false
      @getCatalogs()

CatalogItem = React.createClass
  render: ->
    React.DOM.div {id: @props.catalog.id, className: "col other-card"},
      React.DOM.div {className: "custom-card"},
        React.DOM.div {className: "card"},
          React.DOM.div {className: "card-image waves-effect waves-block waves-light"},
            React.DOM.a {className: "btn-floating btn-large btn-price pink"},
              @props.catalog.count
            React.DOM.img {className: "limit-size", alt: "product-img", src: @props.catalog.photo_url},
          React.DOM.ul {className: "card-action-buttons"},

            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light green"
                href: "/catalogs/" + @props.catalog.id
                React.DOM.i {className: "material-icons"},
                  "photo"

            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light orange.lighten-2"
                href: "/jobs"
                React.DOM.i {className: "material-icons"},
                  "build"

            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light grey lighten-1"
                href: "/catalogs/" + @props.catalog.id + "/edit"
                React.DOM.i {className: "material-icons"},
                  "edit"

            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light light-blue"
                href: "/catalogs/" + @props.catalog.id + "/import"
                React.DOM.i {className: "material-icons"},
                  "compare_arrows"

            React.DOM.li null,
              React.DOM.a
                className: "btn-floating waves-effect waves-light red"
                href: "/catalogs/" + @props.catalog.id + "/destroy"
                React.DOM.i {className: "material-icons"},
                  "delete"

          React.DOM.div {className: "card-content"},
            React.DOM.p {className: "card-title grey-text text-darken-4 truncate"},
              @props.catalog.name
