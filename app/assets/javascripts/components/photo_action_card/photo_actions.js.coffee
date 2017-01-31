@PhotoActionCard = React.createClass
  getInitialState: ->
    widgetContent: PhotoActionStateInfo
    widgetContentString: "PhotoActionStateInfo"
    photoId: @props.photoId
    url: "/photos/" + @props.photoId + ".json"

  getDefaultProps: ->
    null

  render: ->
    if @state.data != undefined
      React.DOM.div {className: 'photo-action-card'},
        React.DOM.div {className: 'card'},
          React.DOM.div {className: 'card-image waves-effect waves-block waves-light'},
            React.createElement PhotoActionWidget, state: @state.data, widgetContent: @state.widgetContent
          React.createElement PhotoActionControls, handleState: @handleState
          if @state.widgetContentString == "PhotoActionStateInfo"
             React.createElement PhotoActionButtons
          React.createElement PhotoActionFooter
    else
      return null
  handleState: (state, stateString) ->
    @setState widgetContent: state, widgetContentString: stateString

  componentWillMount: ->
    $.getJSON @state.url, (data) =>
      @setState data: data
