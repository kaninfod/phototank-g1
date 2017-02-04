@PhotoActionButton = React.createClass
  handleClick: (e) ->
    @props.handleState window[e.target.dataset.widget], e.target.dataset.widget

  render: ->
    React.DOM.li {key: @props.button.key},
      React.DOM.a
        className: 'btn-floating waves-effect waves-light ' + @props.button.color
        onClick: @handleClick

        React.DOM.i
          className: 'material-icons'
          "data-widget": @props.button.widgetContent
          @props.button.icon
