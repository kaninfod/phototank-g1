@PhotoActionStateTag = React.createClass
  render: ->
    React.DOM.div {className: 'photo-action-state-tag'},
      React.DOM.input {className: 'tag-input'}



  componentDidMount: ->
    url = "/photos/get_tag_list?photo_id=".concat(@props.state.photo.id)
    $.get(url).done (data) =>
      new App.Tagger
        identifier: ".tag-input"
        ajaxUrl: "/photos/get_tag_list?term="
        minLength: 2
        photoId: @props.state.photo.id
        tags: data
