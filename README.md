
# UI typeahead item 


##Attributes and Change Handlers

##Event Handlers

##Polymer Lifecycle

Rebubble click events as this element so it's easier for the ui-typeahead to capture them













#ui-typeahead

Typeahead control that handles the commonly needed functionality: 

- Expects the page to provide `ui-typeahead-item` entries that 
- Emits a debounced `inputChange` event that can be handled by the containing page/control to retrieve the data
- Binds the provided `results` and renders the provided result items
- Emits an `change` when the selected item is changed
- Handles keypresses for navigating through the items






##Attributes and Change Handlers

##Methods














##Event Handlers




Since we stop click propagation from within our element, anything
bubbling up to the document handler is outside us and should unfocus the element










Handle various control keypresses or debounce and pass on keypress event

















##Polymer Lifecycle





We debounce the keypresses and make sure we only emit the value
if it's actually changed ignoring arrow keys etc that don't affect the data












