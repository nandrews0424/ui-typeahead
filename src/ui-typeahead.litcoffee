#ui-typeahead

Typeahead control that handles the common typeahead functionality by the following:

- Captures and debouncing user input per the `debounce` attribute
- Allows keypress and click navigation and selection of provided child `ui-typeahead-item` elements
- Publishes two events, `inputChange` that the containing page can use to retrieve the relevant data and template
  in the `ui-typeahead-items`, and `change` which fires when the selected item changes


    _ = require('lodash')
    lastEmittedValue = null
    keys =
      up: 38
      down: 40
      enter: 13
      escape: 27
      tab: 9


    Polymer 'ui-typeahead',

##Attributes
###value
This is the data value bound picked currently.

      valueChanged: ->
        @fire 'change', @value
        selectedTemplate = @querySelector 'selected template'
        if selectedTemplate
          selectedTemplate.setAttribute 'bind', '{{value}}'
          selectedTemplate.model = value: @value
        if @value
          @$.selected.classList.add 'open'
          @$.input.classList.add 'close'
          @$.results.classList.remove 'open'
        else
          @$.selected.classList.remove 'open'
          @$.input.classList.remove 'close'
          @$.results.classList.add 'open'

##Events

### change
Change fires when the selected `ui-typeahead-item` changes.

### inputChange
inputChange fires when user changes the text input of the typehead.  This event is debounced per the debounce property (in milliseconds) and only fires
When the value is different that the previously emitted value.  The event detail contains a single `value` property with the input text, or null if it's been cleared.

##Methods

### selectItem and clear

Selects the provided `ui-typeahead-item`, while clear is simply an alias for `selectItem(null)`.

This will hijack the template used to render each display item, and create a
display ready clone.

      selectItem: (item) ->
        @value = item?.templateInstance?.model

      clear: (clearInput=true) ->
        @selectItem null
        @$.input.value = null if clearInput

##Event Handlers

      inputChanged: ->
        @$.results.classList.add 'open'

### documentClick

Since we stop click propagation from within our element, anything
bubbling up to the document handler is outside us and should unfocus the element

      documentClick: (evt) ->
        @.classList.remove 'focused'

### click

Clicks on a ui-typeahead-item mark it as selected, all clicks within ui-typeahead
are swallowed at this point

      clickResults: (evt) ->
        evt.stopPropagation()
        if evt.target.tagName is "UI-TYPEAHEAD-ITEM"
          @selectItem evt.target

      clickSelected: (evt) ->
        @$.selected.classList.remove 'open'
        @$.input.classList.remove 'close'
        @$.input.focus()

### keyup

On keyup, the typeahead checks for control keypresses and otherwise fires the `debouncedKeyPress`
function, which debounces and then emits `change` (assuming that after the debounce the value
is in fact different)

      keyup: (evt) ->
        items = @querySelectorAll('ui-typeahead-item')
        focusIndex = _.findIndex items, (i) -> i.hasAttribute 'focused'

We pull the 'selected attribute off the typeahead' so on subsequent keypresses items can be seen
after initial item selection

        @removeAttribute 'selected'

        if evt.which is keys.down
          items[focusIndex]?.removeAttribute 'focused'
          items[ (focusIndex+1)%items.length ]?.setAttribute 'focused', ''

        else if evt.which is keys.up
          items[focusIndex]?.removeAttribute 'focused'
          focusIndex = items.length if focusIndex <= 0
          items[focusIndex-1]?.setAttribute 'focused', ''

        else if evt.which in [ keys.enter, keys.tab ]
          @selectItem items[focusIndex]

        else if evt.which is keys.escape
          items[focusIndex]?.focused = false
          @selectItem null
          @fire 'inputChange', { value: null }
        else
          @debouncedKeyPress(evt)

Size the results panel so that it doesn't fall off the page, instead -- make it
scroll.

        bottom = window.scrollY + window.innerHeight
        top = @$.results.getBoundingClientRect().top
        height = @$.results.scrollHeight
        if (top + height) > bottom
          maxHeight = bottom - top
          @$.results.style.maxHeight = "#{maxHeight}px"
          if @querySelector('[focused]')?.offsetTop > maxHeight
            @$.results.scrollTop = @querySelector('[focused]')?.offsetTop
          if @querySelector('[focused]')?.offsetTop < @$.results.scrollTop
            @$.results.scrollTop = @querySelector('[focused]')?.offsetTop
        else
          @$.results.style.maxHeight = ''

##Polymer Lifecycle

### attached

Wiring up the various event handlers, including a document level click handler
that sets focused to false when clicking outside the control (actual blur
wasn't working and would trigger even when clicking results withint the
ui-typeahead)

      attached: ->
        @debounce ||= 300
        @debouncedKeyPress = _.debounce =>
          if @$.input.value isnt lastEmittedValue
            lastEmittedValue = @$.input.value
            @fire 'inputChange', { value: @$.input.value }
            @inputChanged()
        , @debounce

        window.addEventListener 'click', (evt) => @documentClick(evt)

### detached

Unwiring the document level click handler.

      detached: ->
        window.removeEventListener 'click', @documentClick
