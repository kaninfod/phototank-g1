s = undefined
App.LocationEdit = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      likeButtonId: '#like'
      numberOfLikes: '#likes_num'
      eventNamespace: 'photo'
    localStorage.setItem 'location', null
    @markers = []
    @initializeMap()
    @bindUIActions()


  bindUIActions: ->
    _this = this
    @searchBox.addListener 'places_changed', -> @getPlaces()
    $('#add_location').on 'click', -> _this.addLocation()
    @map.addListener 'click', (e) -> _this.updateMap(e)


  centerMap: ->
    _this = this
    # Center map on clients current location
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        pos =
          lat: position.coords.latitude
          lng: position.coords.longitude
        _this.map.setCenter pos

  # Sets the map on all markers in the array.
  setMapOnAll: (map) ->
    i = 0
    while i < @markers.length
      @markers[i].setMap map
      i++
    return

  # Removes the markers from the map, but keeps them in the array.
  clearMarkers: ->
    @setMapOnAll null
    return

  # add marker to map
  addMarker: (position) ->
    _this = this
    marker = new (google.maps.Marker)(
      position: position
      map: _this.map)
    @markers.push marker
    return

  # get address from GEOCODER

  get_location: (lat, lng) ->
    $('#spinner').html 'Loading...'
    $.ajax
      url: '/locations/new_from_coordinate_string'
      data:
        latitude: lat
        longitude: lng
      success: (response, request) ->
        $('#country').html response.country
        $('#city').html response.city
        $('#address').html response.address
        localStorage.setItem 'location', JSON.stringify(response)
        $('#spinner').html ''
        $('#address_block').show()
        return
      error: (e) ->

        return
    return



  # Initialize map
  initializeMap: ->
    @map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 14
      center: new (google.maps.LatLng)(55.68, 12.586)
      mapTypeId: google.maps.MapTypeId.ROADMAP)

    @centerMap()

    # Create the search box and link it to the UI element.
    input = document.getElementById('pac-input')

    @searchBox = new (google.maps.places.SearchBox)(input)
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push input

    # Bias the SearchBox results towards current map's viewport.
    _this = this
    @map.addListener 'bounds_changed', ->
      _this.searchBox.setBounds _this.map.getBounds()
      return

  # Listen for the event fired when the user selects a prediction and retrieve
  # more details for that place.
  getPlaces: ->
    places = @searchBox.getPlaces()
    if places.length == 0
      return
    # Clear out the old markers.
    @markers.forEach (marker) ->
      marker.setMap null
      return
    @markers = []
    # For each place, get the icon, name and location.
    bounds = new (google.maps.LatLngBounds)
    places.forEach (place) ->
      icon =
        url: place.icon
        size: new (google.maps.Size)(71, 71)
        origin: new (google.maps.Point)(0, 0)
        anchor: new (google.maps.Point)(17, 34)
        scaledSize: new (google.maps.Size)(25, 25)
      # Create a marker for each place.
      @markers.push new (google.maps.Marker)(
        map: map
        icon: icon
        title: place.name
        position: place.geometry.location)
      if place.geometry.viewport
        # Only geocodes have viewport.
        bounds.union place.geometry.viewport
      else
        bounds.extend place.geometry.location
      return
    @map.fitBounds bounds
    return

  # add location to DB

  addLocation: ->
    data = JSON.parse(localStorage.getItem('location'))
    if data != null
      $.ajax
        url: '/locations/create'
        data: data
        success: (response, request) ->

          localStorage.setItem 'location', null
          return
        error: (e) ->
          
          return
    return

  # Event listner for click events on map

  updateMap: (e) ->

    $('#address_block').hide()
    @clearMarkers()
    @addMarker e.latLng
    @get_location e.latLng.lat(), e.latLng.lng()


$(document).on "page:change", ->
  return unless $(".locations.new").length > 0
  App.LocationEdit.init()
