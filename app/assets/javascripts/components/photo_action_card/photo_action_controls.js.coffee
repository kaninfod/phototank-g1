@PhotoActionControls = React.createClass
  render: ->
    React.DOM.ul {className: 'card-action-buttons horz'},

      React.createElement PhotoActionButton,
        color: "green"
        widgetContent: "PhotoActionStateInfo"
        icon: "info_outline"
        handleState: @props.handleState

      React.createElement PhotoActionButton,
        color: "orange lighten-2"
        widgetContent: "PhotoActionStateAlbum"
        icon: "photo_album"
        handleState: @props.handleState

      React.createElement PhotoActionButton,
        color: "grey lighten-1"
        widgetContent: "PhotoActionStateRotate"
        icon: "rotate_right"
        handleState: @props.handleState

      React.createElement PhotoActionButton,
        color: "light-blue"
        widgetContent: "PhotoActionStateComment"
        icon: "comment"
        handleState: @props.handleState

      React.createElement PhotoActionButton,
        color: "red"
        widgetContent: "PhotoActionStateTag"
        icon: "local_offer"
        handleState: @props.handleState


@PhotoActionButton = React.createClass
  getDefaultProps: ->
    color: "green"
    widgetContent: "PhotoActionStateTag"
    icon: "local_offer"

  render: ->
    React.DOM.li {},
      React.DOM.a
        className: 'btn-floating waves-effect waves-light ' + @props.color
        onClick: @handleClick
        React.DOM.i
          className: 'material-icons'
          "data-widget": @props.widgetContent
          @props.icon

  handleClick: (e) ->

    @props.handleState window[e.target.dataset.widget], e.target.dataset.widget
