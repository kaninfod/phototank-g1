@PhotoActionCard = React.createClass
  getInitialState: ->
    widget: {content: PhotoActionStateInfo, contentString: "PhotoActionStateInfo"}
    photoId: @props.photoId
    url: "/photos/".concat(@props.photoId, ".json")

  getDefaultProps: ->
    null

  handleState: (state, stateString) ->
    @setState widget: {content: state, contentString: stateString}

  componentWillMount: ->
    $.getJSON @state.url, (data) =>
      @setState data: data

  render: ->
    if @state.data != undefined
      React.DOM.div {className: 'photo-action-card'},
        React.DOM.div {className: 'card'},
          React.DOM.div {className: ''},
            React.createElement @state.widget.content, data: @state.data
          React.createElement PhotoActionButtons, data: @state, handleState: @handleState
    else
      return null
