jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
  
  bindSearchTypeahead($(".search-query"))
  
  
bindSearchTypeahead = (node) ->
  node.typeahead(
      source: (typeahead, query) ->
        $.ajax(
          dataType: 'json',
          url: "/search?q="+query
          success: (data) => 
           typeahead.process(data)
        )
      autoSelect: false
      property: "name"
      onselect: (obj) =>
       redirectSelect(obj.url)
  )


redirectSelect = (url) =>
  window.location = url