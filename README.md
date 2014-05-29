
#ui-typeahead-item


##Event Handlers

Rebubbles click events with target as this element
simplifies the checking in ui-typeahead that determines whether or not
an item has beens elected








#ui-typeahead

Typeahead control that handles the common typeahead functionality by the following:

- Captures and debouncing user input per the `debounce` attribute
- Allows keypress and click navigation and selection of provided child `ui-typeahead-item` elements
- Publishes two events, `inputChange` that the containing page can use to retrieve the relevant data and template
  in the `ui-typeahead-items`, and `change` which fires when the selected item changes






##Attributes and Change Handlers

##Methods

### selectItem and clear

Selects the provided `ui-typeahead-item`, while clear is simply an alias for `selectItem(null)`.














##Event Handlers




### documentClick 

Since we stop click propagation from within our element, anything
bubbling up to the document handler is outside us and should unfocus the element



### click

Clicks on a ui-typeahead-item mark it as selected, all clicks within ui-typeahead 
are swallowed at this point





### keyup

On keyup, the typeahead checks for control keypresses and otherwise fires the `debouncedKeyPress` 
function, which debounces and then emits `change` (assuming that after the debounce the value 
is in fact different) 




















##Polymer Lifecycle


### attached

Wiring up the various event handlers, including a document level click 
handler that sets focused to false when clicking outside the control (actual blur wasn't working
and would trigger even when clicking results withint the ui-typeahead)












### detached

Unwiring the document level click handler. 


