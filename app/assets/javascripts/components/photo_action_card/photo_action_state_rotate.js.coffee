@PhotoActionStateRotate = React.createClass
  getInitialState: ->
    rotateAngle: undefined
  render: ->
    React.DOM.div {className: 'photo-action-state-rotate'},
      React.DOM.ul {className: 'rotate'},

        React.DOM.li {},
          React.DOM.input {id: 90, name: 'rotate', type: 'radio', onChange: @handleChange}
          React.DOM.label {htmlFor: 90},
            '90'  + String.fromCharCode(176)

        React.DOM.li {},
          React.DOM.input {id: 180, name: 'rotate', type: 'radio', onChange: @handleChange}
          React.DOM.label {htmlFor: 180},
            '180' + String.fromCharCode(176)

        React.DOM.li {},
          React.DOM.input {id: 270, name: 'rotate', type: 'radio', onChange: @handleChange}
          React.DOM.label {htmlFor: 270},
            "270" + String.fromCharCode(176)

      React.DOM.a
        className: 'waves-effect waves-teal btn-flat right'
        onClick: @handleClick
        'Rotate photo'

        
  handleClick: (e) ->
    if @state.rotateAngle != undefined
      url= "/photos/".concat(@props.state.photo.id, "/rotate/", @state.rotateAngle)
      $.getJSON url, (data) =>
        console.log data


  handleChange: (e)->
    @setState rotateAngle: e.target.id
