@PhotoTaggerAddedTags = React.createClass
  getDefaultProps: ->
    null

  getInitialState: ->
    tags: @props.tags

  addTag: (tag) ->
    found = @state.tags.some((el) =>
      return el.id == tag.id
    )
    if !found
      $.get @props.parent.state.addTagUrl, tag, (data) =>
        @setState tags: data.tags

  removeTag: (e) ->
    tags = @state.tags
    id = parseInt($(e.target).parent().attr("id"))
    index = tags.map((item) => item.id).indexOf(id)
    tag = tags[index]
    tags.splice(index,1)
    $.get @props.parent.state.removeTagUrl, tag, (data) =>
      @setState tags: data.tags


  render: ->
    React.DOM.div {className: 'added-tags'},
      for tag in @state.tags
        React.DOM.div {className: 'tag', key: tag.id, id: tag.id},
          tag.name
          React.DOM.i {className: 'close material-icons', onClick: @removeTag}, "close"
