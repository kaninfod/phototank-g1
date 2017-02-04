@PhotoActionStateAlbum = React.createClass
  render: ->
    React.DOM.div {className: 'photo-action-state-album'},
      React.DOM.ul {className: 'albums'},
        for album in @props.data.albums
          React.DOM.li {key: album.id},
            React.DOM.input
              id: album.id
              name: 'albums'
              type: 'radio'
              onChange: @handleChange
            React.DOM.label {htmlFor: album.id},
              album.name
      React.DOM.a
        className: 'waves-effect waves-teal btn-flat right'
        onClick: @handleClick
        'Add photo'

  handleClick: (e) ->
    url= "/albums/".concat(@state.albumId, "/photo/", @props.data.photo.id, "/add")
    $.getJSON url, (data) =>
      null

  handleChange: (e)->
    @setState albumId: e.target.id
