
# UI typeahead item 

    Polymer 'ui-typeahead-item',

##Attributes and Change Handlers

##Event Handlers

##Polymer Lifecycle

Rebubble click events as this element so it's easier for the ui-typeahead to capture them
  
      focusChanged: (a,b) ->
        console.log "Focus on item changed", 


      rebubbleClick: (evt) ->
        if evt.target isnt @
          evt.preventDefault()
          evt.stopPropagation()
          @fire 'click'

      attached: ->
        @addEventListener "click", @rebubbleClick

      domReady: ->

      detached: ->

