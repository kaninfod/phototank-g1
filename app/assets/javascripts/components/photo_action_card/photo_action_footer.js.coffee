@PhotoActionFooter = React.createClass
  getDefaultProps: ->
    contentText: "content for footer"

  render: ->
    React.DOM.div {className: 'photo-action-footer card-content'},
      React.DOM.p {className: 'card-title grey-text text-darken-4'},
        React.DOM.a {className: 'grey-text text-darken-4'},
          @props.contentText
