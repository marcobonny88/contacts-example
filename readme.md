COMPILE

To compile ContactsExample just open the project, select the "Contacts 2" target in the left-upper part of xcode then press the run button. 
ContactsExample does not have any dependencies with third party libraries.
The app should run correctly without our 'team provisioning profile'.


MANUAL 

This is an app with the purpose of recreating a simple contacts library. 
The app loeses the contacts data each time the user restarts the app. 
Each contact that is stored has three values: name, surname and phone number.

In the home page there is a table with all the contacts. The table already contains three test contacts.
When you select a contact you will move to a ‘form page’ where you can modify each value of the contact. 
Also, in the home page, you can select the 'add new entry' button. You will move in a ‘form page’ where you can insert each value and save the contact. In this page you can also use the 'import' button to add a single contact from the apple official contacts library.

In the form page each value will be validated in this way:
- Name can't be empty
- Surname can't be empty
- Phone number should have this format +39 340 1234567. The phone number must include the 2 blank spaces (like in the example). The prefix must be a + followed by at least one digit. The second part must be a number with at least one digit. The third part must be a number with at least 6 digits.

The contacts taken from the apple official contacts library are an exception. In this contacts the phone number is not separated by blank spaces but is a single piece.


LICENSE

ContactsExample is available under the MIT license. See the LICENSE file for more info.
