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
