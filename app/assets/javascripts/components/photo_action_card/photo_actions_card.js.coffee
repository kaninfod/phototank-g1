@PhotoActionCard = React.createClass
  getInitialState: ->
    widget: {content: PhotoActionStateInfo, contentString: "PhotoActionStateInfo"}
    photoId: @props.photoId
    url: "/photos/" + @props.photoId + ".json"

  getDefaultProps: ->
    null

  render: ->
    if @state.data != undefined
      React.DOM.div {className: 'photo-action-card'},
        React.DOM.div {className: 'card'},
          React.DOM.div {className: 'card-image waves-effect waves-block waves-light'},
            React.createElement PhotoActionWidget, data: @state.data, widget: @state.widget
          React.createElement PhotoActionButtons, parent: this, handleState: @handleState
          React.createElement PhotoActionFooter
    else
      return null

  handleState: (state, stateString, modifier) ->
    @setState widget: {content: state, contentString: stateString, modifier: modifier}

  componentWillMount: ->
    $.getJSON @state.url, (data) =>
      @setState data: data
