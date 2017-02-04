@PhotoActionStateTag = React.createClass
  render: ->
    React.DOM.div {className: 'photo-action-widget'},
      React.DOM.div {className: 'photo-action-widget header'},
        "Add tags to photo"
      React.DOM.div {className: 'photo-action-widget content'},

        React.DOM.div {className: 'photo-action-state-tag'},
          React.createElement PhotoTagger, {
              photoId: @props.data.photo.id
              tags: @props.data.photo.tags
              minLength: 2
              tagUrl: "/photos/get_tag_list?term="
              addTagUrl: "/photos/".concat(@props.data.photo.id, "/addtag")
              removeTagUrl: "/photos/".concat(@props.data.photo.id, "/removetag")
            }
