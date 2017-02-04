class App.Tagger
  constructor: (options) ->
    defaults =
      identifier:null,
      ajaxUrl:false,
      tags: {}
      minLength: 2
      photoId: undefined

    @options = $.extend(defaults, options);
    @elements = {}

    @setupElements()
    @loadTagItems(@options.tags)

    #events when typing
    @elements.tagInput.on "input", (event), => @updateTagItemPane(event)

    #Events for navigation with arrowkeys
    @elements.tagInput.on "keydown", (event), =>  @selectTagItemKeyboard(event)

  #Setup html elements for component
  setupElements: ->
    @elements.tagInput = $(@options.identifier)

    @elements.tagInput.wrap("<div class=tagger></div>")
    @elements.wrapper = $(@elements.tagInput).parent()

    #add ul for dropdown-result to wrapper
    @elements.wrapper.append("<ul class=collection></ul>")
    @elements.tagItemPane = $(@elements.wrapper).children("ul.collection")
    $(@elements.tagItemPane).addClass("tag-item-pane")

    #add div for added tags to wrapper
    @elements.wrapper.prepend("<div class=added-tags></div>")
    @elements.addedTags = $(@elements.wrapper).children(".added-tags")

    #@elements.wrapper.wrap("<div class=tagger-element></div>")

  updateTagItemPane: (event) ->
    if (@elements.tagInput.val().length >= @options.minLength or @elements.tagInput.val().charAt(0) in ["#", "@"])
      url = @options.ajaxUrl + $(event.target).val()
      $.get url, (data) =>
        result = @getTagItemHTML(data)
        if result.length > 0
          @elements.tagItemPane.addClass('show')
          $(@elements.tagItemPane).html(result)
          @setInitialTagItem()
          @bindTagItems()
        else
          @elements.tagItemPane.empty()
          @elements.selectedTagItem = []
          @elements.tagItemPane.removeClass('show')
    else
      @elements.tagItemPane.removeClass('show')

  getTagItemHTML: (data) ->
    result = ""
    for item in data
      result += "<li class=collection-item data-tagid=" + item.id + ">" + item.value + "</li>"
    return result

  #Set the first item i dropdown as active on load
  setInitialTagItem: ->
    @elements.selectedTagItem = @elements.tagItemPane.children(".active")
    if @elements.selectedTagItem.length == 0
      @elements.tagItemPane.children().first().addClass("active")
      @elements.selectedTagItem = @elements.tagItemPane.children(".active")

  #bind click event to items in dropdown
  bindTagItems: ->
    me = this
    @elements.tagItems = @elements.wrapper.find("ul>li")
    @elements.tagItems.on "click", (event), => @selectTagItemMouse(event)


  #Eventhandler for when user navigates and selects from the result dropdown with keyboard
  selectTagItemKeyboard: (event) ->
    if event.keyCode in [38,40]
      @navigateTagItemPane(event)
    else if event.keyCode == 13
      if @elements.selectedTagItem.length > 0
        @addTag(@getDataFromTagItem(@elements.selectedTagItem))
        @elements.tagItemPane.removeClass('show')
      else if @elements.tagInput.val().length > 0
        @addTag({value: @elements.tagInput.val(), id: (-1)})

  #Eventhandler for when user selects from the result dropdown with Mouse
  selectTagItemMouse: (event) ->
    @setSelectedTagItem(event.target)
    @addTag(@getDataFromTagItem($(event.target)))
    @elements.tagItemPane.removeClass('show')

  #Add array of exsisting tags loaded on init
  loadTagItems: (tags) ->
    for item in tags
      @loadTagItem(item)

  #extract tag data from  tagItem (from tagItemPane)
  getDataFromTagItem: (element) ->
    item = element.html()
    tagId = element.data("tagid")
    return {value: item, id: tagId}

  #add new tag to the tagger
  addTag: (data) ->
    existingElement = $(@elements.addedTags).find(".chip[data-tagid=" + data.id + "]")
    if existingElement.length == 0 or data.id == -1
      @loadTagItem(data)
      @elements.tagInput.val(data.tag)
      @elements.tagInput.val("")
      data.photoId = @options.photoId
      @elements.wrapper.trigger("tag:added", data)
    else
      @elements.tagInput.val("")

  #Create the tag element in the tagger
  loadTagItem: (data) ->
    htmlStr = @getTagHTML(data)
    @elements.addedTags.append(htmlStr)
    data.photoId = @options.photoId
    @elements.addedTags.find(".close:last").on "click", (e) =>
      @elements.wrapper.trigger("tag:removed", data)

  #generate html for the chip element
  getTagHTML: (item)->
    "<div class=chip data-tagid=" + item.id + ">" + item.value + "<i class='close material-icons'>close</i></div>"

  #set active element in result dropdown when arrowkeys up/down
  navigateTagItemPane: (event) ->
    switch event.which
      when 38
        @setSelectedTagItem(@elements.selectedTagItem.prev())
      when 40
        @setSelectedTagItem(@elements.selectedTagItem.next())
    @elements.selectedTagItem.removeClass("active")
    @elements.selectedTagItem = @elements.tagItemPane.children(".active")

  setSelectedTagItem: (item) ->
    @elements.tagItems.removeClass("active")
    $(item).addClass("active")
