@PhotoActionStateComment = React.createClass
  render: ->
    React.DOM.div {className: 'photo-action-state-comment'},
      for comment in @props.state.photo.comments
        React.DOM.div {className: 'comment'},
          React.DOM.div {className: 'comment-container'},
            React.DOM.div {className: 'card'},

              React.DOM.p {className: 'comment-date'},
                comment.created_at
              React.DOM.p {},
                comment.comment
            React.DOM.img {className: 'circle responsive-img', src: @props.state.current_user.avatar},
