@PhotoActionStateInfo = React.createClass
  render: ->
    React.DOM.ul {className: 'photo-action-state-info'},

      React.DOM.li null
        React.DOM.label {}, "ID"
        React.DOM.div {className: "content"},
          @props.state.photo.id

      React.DOM.li null
        React.DOM.label {}, "Date"
        React.DOM.div {className: "content"},
          @props.state.photo.date_taken

      React.DOM.li null
        React.DOM.label {}, "Country"
        React.DOM.div {className: "content"},
          @props.state.photo.country

      React.DOM.li null
        React.DOM.label {}, "Model"
        React.DOM.div {className: "content"},
          @props.state.photo.model

      React.DOM.li null
        React.DOM.label {}, "Make"
        React.DOM.div {className: "content"},
          @props.state.photo.make
