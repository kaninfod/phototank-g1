@Modalxxx = React.createClass
  getInitialState: ->
    visible: true
  getDefaultProps: ->


  render: ->
    console.log @state.visible
    if @state.visible
      React.DOM.div {className: 'modal-photo', ref: 'photoModal', id:@props.kaj},
        React.createElement ModalToolbar
        React.createElement ModalMenu
        React.DOM.div {className: 'photo'},
          React.DOM.img
            src: @props.photo.url_org
    else
      React.DOM.div {ref: 'photoModal', id:@props.kaj},


  componentDidMount: ->
    Mousetrap.bind 'esc', => @escKeyHandler()

  shouldComponentUpdate: ->
    if !@setState.visible
      @setState visible: true
      return true
    return false

  escKeyHandler: ->
    console.log this.refs.photoModal
    @setState visible: false

@ModalToolbar = React.createClass
  getInitialState: ->
    null
  getDefaultProps: ->
    null

  render: ->
    React.DOM.div {className: 'modal-toolbar'},

      React.DOM.a
        className: "waves-effect waves-light btn like" #current_user.voted_for?(@photo) ? "green" : "cyan darken-1"}
        type: "button"
        React.DOM.i {className: "material-icons"},
          "thumb_up"

      React.DOM.a
        className: "waves-effect waves-light btn cyan darken-2"
        type: "button"
        href: "#"
        id: "download-photo"
        "data-download-url": "kaj"#@props.photo.url #"#{@photo.url('org')}"
        React.DOM.i {className: "material-icons"},
          "file_download"

      React.DOM.a
        className: "waves-effect waves-light btn cyan darken-2"
        type: "button"
        id: "delete-photo"
        React.DOM.i {className: "material-icons"},
          "delete"

      React.DOM.a
        className: "waves-effect waves-light btn cyan darken-2"
        type: "button"
        href: "#album-list-photo"
        id: "add-to-album-photo"
        "data-turbolinks": false
        React.DOM.i {className: "material-icons"},
          "photo_album"


@ModalMenu = React.createClass
  getInitialState: ->
    null
  getDefaultProps: ->
    null

  render: ->
    React.DOM.div {className: 'modal-menu'},
      React.DOM.ul
        className: "collapsible overlay-menu overlay-menu-show"
        "data-collapsible": "accordion"
        React.DOM.li null,
          React.DOM.div
            className: "collapsible-header overlay-menu-header"
            React.DOM.i {className: "material-icons"},
              "info"
            "info"
          React.DOM.div
            className: "overlay-menu-body collapsible-body"
            "kaj"
