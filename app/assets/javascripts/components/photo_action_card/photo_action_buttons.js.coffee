@PhotoActionButtons = React.createClass
  getInitialState: ->
    likeUrl: '/photos/'.concat(@props.parent.state.photoId,'/like')
    likeState:   if @props.parent.state.data.photo.like then "green" else "grey"
  getDefaultProps: ->
    null

  getHorzButtons: ->
    [{color: "blue lighten-2", widgetContent: "PhotoActionStateInfo", icon: "info_outline", key: 1},
    {color: "brown lighten-3", widgetContent: "PhotoActionStateAlbum", icon: "photo_album", key: 2},
    {color: "deep-orange lighten-2", widgetContent: "PhotoActionStateRotate", icon: "rotate_right", key: 3},
    {color: "lime", widgetContent: "PhotoActionStateComment", icon: "comment", key: 4},
    {color: "teal lighten-2", widgetContent: "PhotoActionStateTag", icon: "local_offer", key: 5}]

  getVertButtons: ->
    [{color: @state.likeState, widgetContent: null, icon: "thumb_up", key: 3, handler: @likePhoto}
    {color: "orange lighten-2", widgetContent: "PhotoActionStateMap", icon: "map", key: 2}
    {color: "deep-purple lighten-3", widgetContent: null, icon: "delete_forever", key: 1, handler: @deletePhoto}]

  likePhoto: ->
    $.get @state.likeUrl, (data) =>
      if data.liked_by_current_user
        likeState = "green"
      else
        likeState = "grey"
      @setState likeState: likeState

  deletePhoto: ->
    swal {
      title: 'Are you sure?'
      text: 'You will not be able to recover the photo once deleted!!'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Yes, delete it!'
      closeOnConfirm: false
    }, ->
      $.ajax
        url: '/photos/'.concat(@props.data.photo.id, '.json')
        type: 'DELETE',
        contentType: 'application/json',
        success: (data) ->
          callback()
          swal 'Deleted!', 'The photo has been deleted.', 'success'

  render: ->
    React.DOM.div {},
      React.DOM.ul {className: 'card-action-buttons horz'},
        for button in @getHorzButtons()
          React.createElement PhotoActionButton,
            button: button,
            key: button.key,
            handleState: @props.parent.handleState

      if @props.parent.state.widget.contentString in ["PhotoActionStateInfo", "PhotoActionStateMap"]
        React.DOM.ul {className: 'card-action-buttons vert'},
          for button in @getVertButtons()
            React.createElement PhotoActionButton,
              button: button,
              key: button.key
              handleState: button.handler ? @props.parent.handleState
