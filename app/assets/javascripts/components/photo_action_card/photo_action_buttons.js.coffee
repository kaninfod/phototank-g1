@PhotoActionButtons = React.createClass
  render: ->
    React.DOM.ul {className: 'card-action-buttons vert'},

      React.DOM.li {},
        React.DOM.a {className: 'btn-floating waves-effect waves-light green'},
          React.DOM.i {className: 'material-icons'}, "info_outline"

      React.DOM.li {},
        React.DOM.a {className: 'btn-floating waves-effect waves-light orangelighten-2'},
          React.DOM.i {className: 'material-icons'}, "photo_album"

      React.DOM.li {},
        React.DOM.a {className: 'btn-floating waves-effect waves-light grey lighten-1'},
          React.DOM.i {className: 'material-icons'}, "rotate_right"
