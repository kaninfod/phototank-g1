@PhotoActionStateMap = React.createClass
  getInitialState: ->
    null

  render: ->
    React.DOM.div {},
      React.DOM.img
        src: @props.data.photo.location.map_url
