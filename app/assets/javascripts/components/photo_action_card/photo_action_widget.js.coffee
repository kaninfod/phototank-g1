@PhotoActionWidget = React.createClass
  getDefaultProps: ->
    titles: [
      {key: 1, class: "PhotoActionStateInfo",    title: "Photo info"}
      {key: 2, class: "PhotoActionStateAlbum",   title: "Select album to add photo to"}
      {key: 3, class: "PhotoActionStateRotate",  title: "Select rotation"}
      {key: 4, class: "PhotoActionStateComment", title: "Add comment"}
      {key: 5, class: "PhotoActionStateTag",     title: "Add tags"}
      {key: 5, class: "PhotoActionStateMap",     title: "Location"}
    ]

  getTitle: (cls)->
    result = (item for item in @props.titles when item.class is cls)
    return result[0].title

  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        @getTitle(@props.widget.contentString) #@props.data.photo.date_taken
      React.DOM.div {className: 'photo-action-widget content'},
        React.createElement @props.widget.content, data: @props.data
