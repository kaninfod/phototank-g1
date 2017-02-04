@PhotoActionStateMap = React.createClass
  getInitialState: ->
    null

  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        "Photo location"
      React.DOM.div {className: 'photo-action-widget content'},
        React.DOM.img
          src: @props.data.photo.location.map_url
