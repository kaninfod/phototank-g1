@PhotoActionStateRotate = React.createClass
  getInitialState: ->
    rotateAngle: undefined

  getDefaultProps: ->
    rotations: [90, 180, 270]

  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        "Rotate photo"
      React.DOM.div {className: 'photo-action-widget content'},

        React.DOM.div {className: 'photo-action-state-rotate'},
          React.DOM.ul {className: 'rotate'},
            for rotation in @props.rotations
              React.DOM.li {key: rotation},
                React.DOM.input {id: rotation, name: 'rotate', type: 'radio', onChange: @handleChange}
                React.DOM.label {htmlFor: rotation},
                  rotation  + String.fromCharCode(176)

          React.DOM.a
            className: 'waves-effect waves-teal btn-flat right'
            onClick: @handleClick
            'Rotate photo'


  handleClick: (e) ->
    if @state.rotateAngle != undefined
      url= "/photos/".concat(@props.data.photo.id, "/rotate/", @state.rotateAngle)
      $.getJSON url, (data) =>
        if data.status
          Materialize.toast('Photo is queued for rotation', 4000)

  handleChange: (e)->
    @setState rotateAngle: e.target.id
