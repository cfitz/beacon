# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ -> $('#document_summary').wysihtml5();
$ -> bindCreatorTypeahead($('.creator-typeahead'))
$ -> bindTopicTypeahead($('.topic-typeahead'))




$(document).on('focus', "[data-behaviour~='datepicker']", ( ->
   $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true});
));


$('.remove-row').live( 'click', ( -> 
  $(this).parents('div.controls:first').remove();
));


$ -> window.nestedFormEvents.insertFields = (content, assoc, link) ->
     content = content.replace("readonly" , "")
     jContent = $(content)
     bindCreatorTypeahead(jContent.find('.creator-typeahead'))     
     bindTopicTypeahead(jContent.find('.topic-typeahead'))     
     jContent.insertBefore(link)

$ -> DV.load("#{window.location}.json", { container: '#DV-container', width: '100%', height: 500,  sidebar: false });


insertSelected = (selected, inputNode ) -> 
   clone = inputNode.clone()
   
   index = inputNode.closest('section').find('.fields').size()
   docType = inputNode.attr('id') + "_attributes"
    
   name = "document[#{docType}][#{index}]"
   create = name + "[id]"
   destroy = name + "[_destroy]"
   
   destroyInput = inputNode.next('input')
   destroyInput.attr('name', destroy)
   
   clone.attr('name', create)
   clone.attr('value', selected.id )
   clone.attr('type', 'hidden')
   
   inputNode.closest('div').append(clone)
   
   inputNode.attr('readonly', true)
   inputNode.removeAttr('name')
  


bindCreatorTypeahead = (node) ->
  node.typeahead(
      source: (typeahead, query) ->
        $.ajax(
          url: "/people.json?q="+query
          success: (data) => 
           typeahead.process(data)
        )
      property: "name"
      onselect: (obj) =>
        insertSelected(obj, node)
  )


bindTopicTypeahead = (node) ->
  node.typeahead(
      source: (typeahead, query) ->
        $.ajax(
          url: "/topics.json?q="+query
          success: (data) => 
           typeahead.process(data)
        )
      property: "name"
      onselect: (obj) =>
        insertSelected(obj, node)
  )


