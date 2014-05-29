#ui-typeahead

Typeahead control that handles the commonly needed functionality: 

- Expects the page to provide `ui-typeahead-item` entries that 
- Emits a debounced `inputChange` event that can be handled by the containing page/control to retrieve the data
- Binds the provided `results` and renders the provided result items
- Emits an `change` when the selected item is changed
- Handles keypresses for navigating through the items

    _ = require('../node_modules/lodash/dist/lodash.js')
    lastEmittedValue = null
    
    Polymer 'ui-typeahead',


##Attributes and Change Handlers

##Methods
      
      selectItem: (item) ->
        items = @querySelectorAll('ui-typeahead-item')
        _.each items, (i) ->
          if i is item
            i.setAttribute 'selected', ''
            i.setAttribute 'focused', ''
          else
            i.removeAttribute 'selected'
            i.removeAttribute 'focused'
          true

        index = _.indexOf items, item
        @fire 'change', { item, index, query: @$.input.value }

##Event Handlers
      
      focus: (evt) ->
        @focused = true

Since we stop click propagation from within our element, anything
bubbling up to the document handler is outside us and should unfocus the element

      documentClick: (evt) ->
        @focused = false 

      click: (evt) ->
        evt.stopPropagation()
        if evt.target in @querySelectorAll('ui-typeahead-item')
          @selectItem evt.target

      keyup: (evt) ->
        items = @querySelectorAll('ui-typeahead-item')
        focusIndex = _.findIndex items, (i) -> i.hasAttribute 'focused'
        
Handle various control keypresses or debounce and pass on keypress event

        if evt.which is 40 
          items[focusIndex]?.removeAttribute 'focused'
          items[ (focusIndex+1)%items.length ]?.setAttribute 'focused', ''
        else if evt.which is 38
          items[focusIndex]?.removeAttribute 'focused'
          focusIndex = items.length if focusIndex <= 0
          items[focusIndex-1]?.setAttribute 'focused', ''
        else if evt.which in [13, 9]
          @selectItem items[focusIndex]
        else if evt.which is 27
          items[focusIndex]?.focused = false
          @selectItem null
          @fire 'inputChange', { text: null }
        else
          @debouncedKeyPress(evt)


##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->
        @debounce ||= 300

We debounce the keypresses and make sure we only emit the value
if it's actually changed ignoring arrow keys etc that don't affect the data

        @debouncedKeyPress = _.debounce ->
          if @$.input.value isnt lastEmittedValue
            lastEmittedValue = @$.input.value
            @fire 'inputChange', { text: @$.input.value }
        , @debounce

        @addEventListener 'click', @click
        @addEventListener 'focus', @focus
        @addEventListener 'keyup', @keyup
        window.addEventListener 'click', (evt) => @documentClick(evt)

      domReady: ->

      detached: ->
        window.removeEventListener 'click', @documentClick
