
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











##Events

### change

Change fires when the selected `ui-typeahead-item` changes.  It returns a detail object with 3 properties

- `index` is index of the selected `ui-typeahead-item` or -1 if item was deselected.  If you have both static and data 
  bound items be aware that this index includes both and may not correspond directly to the index of the data you bound
- `item` is the selected `ui-typeahead-item` DOM object or null if the selection was removed

### inputChange

inputChange fires when user changes the text input of the typehead.  This event is debounced per the debounce property (in milliseconds) and only fires
When the value is different that the previously emitted value.  The event detail contains a single `value` property with the input text, or null if it's been cleared.

##Methods

### selectItem and clear

Selects the provided `ui-typeahead-item`, while clear is simply an alias for `selectItem(null)`.












We set the attributes for the selected item including the top incase the consumer would like to overlay the 
selection over the original input box














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




We pull the 'selected attribute off the typeahead' so on subsequent keypresses items can be seen
after initial item selection


























##Polymer Lifecycle


### attached

Wiring up the various event handlers, including a document level click 
handler that sets focused to false when clicking outside the control (actual blur wasn't working
and would trigger even when clicking results withint the ui-typeahead)














### detached

Unwiring the document level click handler. 


