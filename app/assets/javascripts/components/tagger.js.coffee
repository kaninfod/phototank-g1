@PhotoTagger = React.createClass
  getInitialState: ->
    tags: @props.tags
    tagUrl: @props.tagUrl
    addTagUrl: @props.addTagUrl
    removeTagUrl: @props.removeTagUrl
    minLength: @props.minLength

  getDefaultProps: ->
    identifier:null
    tagUrl: ""
    addTagUrl: ""
    removeTagUrl: ""
    tags: {}
    minLength: 2
    photoId: undefined

  render: ->
    React.DOM.div {className: 'tagger'},
      React.DOM.input {className: 'tag-input', onInput: @handleInput, onKeyDown: @handleKeyDown, ref:"input"}
        React.createElement PhotoTaggerTagItemPane,
          {addTag: @addTag, setInput: @setInput, ref: 'pane', parent: this}
      React.createElement PhotoTaggerAddedTags, tags: @state.tags, ref:'addedTags', parent: this

  handleKeyDown: (e) ->
    if e.keyCode in [38,40,13,27]
      this.refs.pane.navigate e

  handleInput: (e) ->
    if e.target.value.length >= @state.minLength
      this.refs.pane.setSearchString e.target.value

  setInput: (value)->
    this.refs.input.value = value

  addTag: (tag)->
    this.refs.addedTags.addTag tag

  componentDidMount: ->
    this.refs.input.focus()


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


@PhotoTaggerTagItemPane = React.createClass
  getDefaultProps: ->
    null

  getInitialState: ->
    @activeItem = null
    tags:[]


  setSearchString: (string) ->
    url = (@props.parent.state.tagUrl).concat(string)
    $.getJSON url, (data) =>
      @setState tags: data, searchString: string
      @activeItem = null


  componentDidUpdate: ->
    if @state.tags.length
      @setTagItemPane(1)

  setActiveItem: (item) ->
    if item.length > 0
      $(this.refs.ul).children().removeClass('active')
      $(item).addClass('active')
      @activeItem = item
      @props.setInput $(@activeItem).html()

  setTagItemPane: (state) ->
    if state
      $(this.refs.ul).addClass('show')
    else
      $(this.refs.ul).removeClass('show')

  navigate: (e) ->
    if @activeItem == null and !@state.tags.length and e.which in [38,40]
      return
    else if @activeItem == null and @state.tags.length and e.which in [38,40]
      @setActiveItem($(this.refs.ul).children().first())
    else if e.which == 38 and @state.tags.length
      @setActiveItem($(@activeItem).prev())
    else if e.which == 40 and @state.tags.length
      @setActiveItem($(@activeItem).next())
    else if e.which == 13 and @activeItem != null
      @props.addTag {name:$(@activeItem).html(), id: parseInt($(@activeItem).attr('id')) }
      @props.setInput ""
      @activeItem = null
      @setTagItemPane(0)
      @setState tags: [], searchString: ""
    else if e.which == 13 and @activeItem == null
      @props.addTag {name: @state.searchString, id: -1 }
      @props.setInput ""
      @activeItem = null
      @setTagItemPane(0)
      @setState tags: [], searchString: ""
    else if e.which == 27
      @props.setInput ""
      @activeItem = null
      @setTagItemPane(0)
      @setState tags: [], searchString: ""


  handleClick: (e) ->
    @props.addTag {name:e.target.innerHTML, id: parseInt(e.target.getAttribute('id')) }
    @setTagItemPane(0)
    @props.setInput e.target.innerHTML

  render: ->
    React.DOM.ul {className: 'collection tag-item-pane', ref: "ul"},
      for tag in @state.tags
        React.DOM.li {key: tag.id, id:tag.id, className: 'collection-item', onClick:@handleClick},
          tag.name
