# WPAssignment

# Requirements:
1. Display fetched cards from the Random Data API.
2. Sort and group cards by type.
3. Provide an option to bookmark or save cards.
4. Handle errors properly and display appropriate error messages if the API call fails.

# Architecture Followed
The app follows the MVVM (Model-View-ViewModel) architecture, which integrates seamlessly with SwiftUI's declarative approach. Additionally, the app employs a modular folder structure, separating the Persistence Layer and Service Layer from the MVVM components to ensure clear responsibility segregation.

# Dashboard:
The Dashboard features a TabView with two tabs: Credit Cards and Bookmarks, implemented using SwiftUI’s navigation approach.

# Credit Cards Tab:
1. Displays a progress indicator until the API data is fetched.
2. Shows an error view if the API call fails.
3. On successful API fetch: Cards are sorted and grouped by type, displayed in sections within a List.
4. Provides the ability to bookmark cards, with bookmarks persisted in SQLite.
5. Supports pull-to-refresh to fetch new cards. Refreshed data replaces the old cards but retains the bookmarked cards.
  
# Bookmarks Tab:
1. Displays all cards bookmarked by the user.
2. Reflects changes made in the Credit Cards Tab, ensuring real-time synchronization.
3. Handles empty states gracefully.

# ViewModel Layer:
The CreditCardViewModel and BookmarkViewModel handle the business logic for their respective views. They interact with the Service Layer to fetch data and synchronize with the View Layer using SwiftUI’s state management.

# Persistence Layer:
The app uses the SwiftData framework to persist card details. SwiftData internally utilizes Core Data to store data in an SQLite database.

# Service Layer:
Acts as a facade layer, fetching credit cards either from the database (if available) or through an API call when the data is not cached.

# Test Coverage:
Comprehensive test cases have been written for:
1. ViewModel Layer: Ensuring correct handling of business logic and state updates.
2. Persistence Layer: Verifying data storage and retrieval functionalities.
3. Service Layer: Testing seamless integration between API calls and database interactions.

