elements = undefined

App.Tagger = do ->

  init: () ->
    elements =
      input: undefined
      wrapper: undefined
      dropDownResult: undefined
      dropDownResultItems: undefined
      selectedItem: []
      addedTags: undefined

  initTagger: (options) ->
    _this = this
    defaults =
      identifier:null,
      ajaxUrl:false,
      tags: {}
      minLength: 2

    options = $.extend(defaults, options);

    elements.wrapper = $(options.identifier)

    elements.wrapper.append("<input id=tagger-input>")
    elements.input = $(elements.wrapper).children("input")

    #add ul for dropdown-result to wrapper
    elements.wrapper.append("<ul class=collection></ul>")
    elements.dropDownResult = $(elements.wrapper).children("ul.collection")
    $(elements.dropDownResult).addClass("dropdown-result")

    #add div for added tags to wrapper
    elements.wrapper.prepend("<div class=added-tags></div>")
    elements.addedTags = $(elements.wrapper).children(".added-tags")

    @addExistingTags(options.tags)

    #events when typing
    elements.input.on "input", (event), ->
      if (elements.input.val().length >= options.minLength or elements.input.val().charAt(0) in ["#", "@"])
        url = options.ajaxUrl + $(event.target).val()
        $.get url, (data) ->
          result = _this.getResult(data)
          if result.length > 0
            elements.dropDownResult.addClass('show')
            $(elements.dropDownResult).html(result)
            _this.setInitialItem()
            _this.bindDropDownResultItems()
          else
            elements.dropDownResult.empty()
            elements.selectedItem = []
            elements.dropDownResult.removeClass('show')
      else
        elements.dropDownResult.removeClass('show')

    #Events for navigation with arrowkeys
    elements.input.on "keydown", (event), ->
      if event.keyCode in [38,40]
        _this.navigateResultItems(event)
      else if event.keyCode == 13
        if elements.selectedItem.length > 0
          _this.addTagToTagger(_this.extractTagFromElement(elements.selectedItem))
          elements.dropDownResult.removeClass('show')
        else if elements.input.val().length > 0
          _this.addTagToTagger({value: elements.input.val(), id: (-1)})

  addExistingTags: (tags) ->
    for item in tags
      @createTagElement(item)

  extractTagFromElement: (element) ->
    item = element.html()
    tagId = element.data("tagid")
    return {value: item, id: tagId}

  addTagToTagger: (data) ->
    existingElement = $(".tagger>.added-tags>.chip[data-tagid=" + data.id + "]")
    if existingElement.length == 0 or data.id == -1
      elements.input.val(data.tag)
      elements.input.val("")
      elements.wrapper.trigger("tag:added", data)
    else
      elements.input.val("")

  createTagElement: (data) ->
    htmlStr = @getChipHtml(data)
    elements.addedTags.append(htmlStr)
    elements.addedTags.children().last().children(".close").on "click", (e) ->
      elements.wrapper.trigger("tag:removed", data)

  getChipHtml: (item)->
    "<div class=chip data-tagid=" + item.id + ">" + item.value + "<i class='close material-icons'>close</i></div>"

  navigateResultItems: (event) ->
    _this = this
    switch event.which
      when 38
        _this.setActiveItem(elements.selectedItem.prev())
      when 40
        _this.setActiveItem(elements.selectedItem.next())
    elements.selectedItem.removeClass("active")
    elements.selectedItem = elements.dropDownResult.children(".active")

  setInitialItem: ->
    elements.selectedItem = elements.dropDownResult.children(".active")
    if elements.selectedItem.length == 0
      elements.dropDownResult.children().first().addClass("active")
      elements.selectedItem = elements.dropDownResult.children(".active")

  bindDropDownResultItems: ->
    _this = this
    elements.dropDownResultItems = $(".tagger>ul>li")
    elements.dropDownResultItems.on "click", (event), ->
      _this.setActiveItem(event.target)
      _this.addTagToTagger(_this.extractTagFromElement($(event.target)))
      elements.dropDownResult.removeClass('show')

  setActiveItem: (item) ->
    elements.dropDownResultItems.removeClass("active")
    $(item).addClass("active")

  getResult: (data) ->
    result = ""
    for item in data
      result += "<li class=collection-item data-tagid=" + item.id + ">" + item.value + "</li>"
    return result


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums, .locations.show").length > 0
  App.Tagger.init()
