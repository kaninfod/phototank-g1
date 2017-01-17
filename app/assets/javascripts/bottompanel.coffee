s = undefined
App.BottomPanel = do ->

  init: ->
    s =
      eventNamespace: 'photo'
      photoGrid: '#photogrid'
      datePicker: undefined
    @bindUIActions()
    _this = this
    dateInput = $('.datepicker').pickadate
      selectMonths: true
      selectYears: 15
      closeOnSelect: false
      closeOnClear: false

    s.datePicker = dateInput.pickadate('picker')
    $('select').material_select();

  bindUIActions: ->
    _this = this
    $('body').on 'click.' + s.eventNamespace, '.panel-tab', -> _this.togglePanel(this)
    # $('#search-date').on 'changeDate', (e) -> _this.searchParamsChanged(e)
    $('body').on 'change.' + s.eventNamespace, '#search-date, #search_country, #search_direction, #search_like, #search_tags', -> _this.searchParamsChanged()


  togglePanel: (tab) ->
    panelId = $(tab).data("content")
    panel = $("#" + panelId)
    tab = $(tab)

    $('.bottom-panel').addClass('show')

    $(".panel-tab").removeClass("active")
    tab.addClass("active")

    $(".panel-content").removeClass('active')
    panel.addClass('active')
    # else if $(tab).attr('id') == "hide-tab"
    #   $('.bottom-panel').toggleClass('show')


  searchParamsChanged: (e)->

    data = this.getSearchParams()

    url = '/photos/'

    $('#photogrid').load url, data, ->
      App.PhotoGrid.init()
      $('img.lazy').lazyload()
      $('.pagination:first').parent().remove()
    s.datePicker.close()

  getSearchParams: ->
    direction = $("#search_direction").prop('checked')
    country = $("#search_country").val()
    like = $("#search_like").prop('checked')
    tags = []#$("#searchbox_tags").tagsinput('items')

    date = s.datePicker.get('select')
    if date != null
      if not date.pick instanceof Date
        date = ""
      else
        date = new Date(date.pick)
    return {tags: tags, like: like, direction: direction, startdate: date, country: country}


$(document).on "turbolinks:load", ->
  App.BottomPanel.init()
