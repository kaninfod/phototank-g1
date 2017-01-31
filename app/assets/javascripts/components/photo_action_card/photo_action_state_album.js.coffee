@PhotoActionStateAlbum = React.createClass
  render: ->
    React.DOM.div {className: 'photo-action-state-album'},
      React.DOM.ul {className: 'albums'},
        for album in @props.state.albums
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
    console.log @props.state.photo.id
    url= "/albums/".concat(@state.albumId, "/photo/", @props.state.photo.id, "/add")
    $.getJSON url, (data) =>
      console.log data


  handleChange: (e)->
    @setState albumId: e.target.id
