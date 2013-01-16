# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


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

# Document Viewer - removing.
#$ -> DV.load("#{window.location}.json", { container: '#DV-container', width: '100%', height: 500,  sidebar: false });

# once selected, we want to make the input box readonly, disable it for updating, and change the hidden id field so that 
# the relationship gets made. 
insertSelected = (selected, inputNode ) -> 
  idField = inputNode.siblings("div.control-group.hidden")
  inputField = idField.find('input')
  inputField.attr('value', selected.id) 
  inputNode.attr('readonly', true)
  #inputNode.removeAttr('name')



  
  


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


