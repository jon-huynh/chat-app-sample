# Chat App Sample

This project provides a sample of a smart chat assistant interface in addition to an example home screen for a simple banking application.

## Features
### Home
- Loads sample transactions from a local JSON file
- Stores sample transactions into UserDefaults (This should ideally be stored in CoreData, but chose to use UserDefaults for the sake of time and simplicity.)
- Allows user to tap to open chat support

### Chat
- Mocks chat interaction that allows the user to:
  - Ask about the status of their transaction
    - For testing, the user input must include the word "status"
  - Ask when is the best time to send a payment
    - For testing, the user input must include the words "best time", "send", and "payment"
  - Resend/delete failed messages
    - For testing, the user input must include the word "weather"
   
### Offline
- Supports viewing locally cached transactions when offline/airplane mode
