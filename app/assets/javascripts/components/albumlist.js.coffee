$('#add-to-album-bucket').on 'click' , (event) -> addToAlbum(event)


addToAlbum: ->
  album_id = $('#album-list-bucket * #albums input:radio:checked').val()
  $.get '/bucket/save', {album_id: album_id}, ->
    Materialize.toast("Photos have been saved to album", 3000)




@Modal = React.createClass
  getInitialState: ->
    albums: @props.albums
  getDefaultProps: ->
    albums: []
  render: ->
    React.DOM.div
      className: "modal-content"
      React.DOM.h4 null,
        "Save to album (Bucketx)"
      React.createElement "Albums", albums: @state.albums, radioGroup: @props.radioGroup


@Albums = React.createClass
  getInitialState: ->
    newAlbum: {id: -1, name: "New Album"}
    albums: @props.albums
  getDefaultProps: ->
    null
  render: ->
    React.DOM.div
      className: 'albums'
      React.DOM.h2
        className: 'title'
        'Albums'
      React.DOM.div
        React.createElement Album, key: @state.newAlbum.id, album: @state.newAlbum, radioGroup: @props.radioGroup
        for album in @state.albums
          React.createElement Album, key: album.id, album: album, radioGroup: @props.radioGroup

@Album = React.createClass
  render: ->
    React.DOM.p null,
      React.DOM.input
        name: @props.radioGroup
        type: "radio"
        value: @props.album.id
        id: @props.album.id
      React.DOM.label
        htmlFor: @props.album.id
        @props.album.name
