jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
  
  bindSearchTypeahead($(".search-query"))
  $('ul.typeahead').on('mousedown', 'ul.typeahead', ()  =>
    e.preventDefault()
  )

bindSearchTypeahead = (node) ->
  node.typeahead(
      source: (typeahead, query) ->
        $.getJSON("/search", { q: query }, (data) =>
            typeahead.process(data)
        )
      autoSelect: false
      property: "name"
      onkeypress: (obj) =>
       redirectSelect(obj.url)
      onselect: (obj) =>
       redirectSelect(obj.url)
  )



redirectSelect = (url) =>
  window.location = url