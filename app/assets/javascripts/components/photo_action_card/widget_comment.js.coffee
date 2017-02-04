@PhotoActionStateComment = React.createClass
  getInitialState: ->
    userImgUrl: @props.data.current_user.avatar
    comments: @props.data.photo.comments
    commentUrl: url = '/photos/'.concat(@props.data.photo.id, '/add_comment')

  handleKeyDown: (e)->
    if e.which == 13 and e.target.value.length > 0
      $.getJSON @state.commentUrl, { comment: e.target.value }, (comments) =>
        @setInput ""
        @setState comments: comments.comments

  setInput: (value)->
    this.refs.input.value = value

  componentDidMount: ->
    this.refs.input.focus()

  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        "Add comments to photo"
      React.DOM.div {className: 'photo-action-widget content'},
        React.DOM.div {className: 'photo-action-state-comment'},

          React.DOM.div {className: 'comment'},
            React.DOM.div {className: 'comment-container'},
              React.DOM.div {className: 'card'},

                React.DOM.p {className: 'comment-date'},
                  "Right now"
                React.DOM.input {onKeyDown: @handleKeyDown, ref: "input"}
              React.DOM.img {className: 'circle responsive-img', src: @state.userImgUrl},



          for comment in @state.comments by -1
            React.DOM.div {className: 'comment', key: comment.id},
              React.DOM.div {className: 'comment-container'},
                React.DOM.div {className: 'card'},

                  React.DOM.p {className: 'comment-date'},
                    comment.created_at
                  React.DOM.p {},
                    comment.comment
                React.DOM.img {className: 'circle responsive-img', src: @state.userImgUrl},
