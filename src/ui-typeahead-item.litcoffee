#ui-typeahead-item
Wraps a single item in the typeahead. When clicked or on enter, the value
will fire up as 'selected'.

    Polymer 'ui-typeahead-item',

##Event Handlers
Rebubbles click events with target as this element
simplifies the checking in ui-typeahead that determines whether or not
an item has been selected

      click: (evt) ->
        if evt.target isnt @
          evt.preventDefault()
          evt.stopPropagation()
          @fire 'click'

      attached: ->
