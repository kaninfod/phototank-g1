@PhotoActionStateInfo = React.createClass
  getInitialState: ->
    infoArray: [
      {key: 1, label: 'ID', info: @props.data.photo.id},
      {key: 2, label: 'Date', info: @props.data.photo.date_taken}
      {key: 3, label: 'Country', info: @props.data.photo.location.country}
      {key: 4, label: 'Model', info: @props.data.photo.model}
      {key: 5, label: 'Make', info: @props.data.photo.make}
    ]


  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        "Photo Information"
      React.DOM.div {className: 'photo-action-widget content'},
        React.DOM.ul {className: 'photo-action-state-info'},
          for info in @state.infoArray
            React.DOM.li {key:info.key},
              React.DOM.label {}, info.label
              React.DOM.div {className: "content"},
                info.info
