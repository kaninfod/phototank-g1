@PhotoActionWidget = React.createClass
  getDefaultProps: ->
    title: "Title goes here"
    content: "Content here"
  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        @props.state.photo.date_taken
      React.DOM.div {className: 'photo-action-widget content'},
        React.createElement @props.widgetContent, state: @props.state
