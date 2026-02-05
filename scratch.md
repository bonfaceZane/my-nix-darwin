The issue with Makes and Models was the single biggest cause of the `clickc to search` hanging forever during app startup. It boiled down to three main problems:

1. The "Zombie" Network Check
Before fetching Makes or Models, the app calls 
Network.getNetworkStateAsync().

Issue: There was no timeout on this specific check. If you were on a flaky mobile connection, this check could `hang` indefinitely.

The Result: Because the app must have Makes/Models to display the filters and search results, everything just stopped. The loading spinner would stay forever because the code was waiting for a response that would never come.

2. Sequential Bottleneck (The Waterfall)
Previously, the app fetched data like a waterfall:

Fetch Saved Searches - Wait
Once finished, fetch Makes - Wait
Once finished, use Makes to fetch Models - Wait

Issue: If you had a slow connection, these three sequential steps could take 15–20 seconds. If any one of them stalled, the whole chain broke.

Fix: changed to Parallel Fetching. We now fire off the requests for Searches and Makes at the same time, cutting the initial wait time in half and making the startup much more resilient.

3. Lack of a "Panic Exit" `Error Recovery`
The logic in useRemoteQueryParamSearch.ts `which handles deep links and filters` was too strict.
The Issue: If the API returned an error while fetching Makes (say, a 500 error or a timeout), the loading flags often wouldn't reset correctly.

The Fix: add try/catch/finally blocks. Now, if the "Models" fetch fails, the app "I couldn't get the models, but I’m going to clear the car and let the user see their results anyway" instead of staying stuck on the loading screen.

By adding a 10-second hard limit to the network check and allowing the app to recover from metadata failures, we've ensured that the `Makes and Models` step can no longer hold the entire app hostage.


#### ==============
The "first load of async storage" was the hidden match that started the infinite fire. Here is what was happening:

The "Hydration" Chaos
When the app first starts, AsyncStorage has to load your Filters, Auth Token, Sort Settings, and App Review state.

The Problem: Because these are loaded asynchronously, the app doesn't get them all at once. It gets "initial state" (empty) -> then "Filters loaded" -> then "Auth loaded". Each one of these updates causes a re-render.
The Cascade: In the old code, because the Context Providers weren't memoized, every single one of those AsyncStorage updates sent a "new" object down the whole app tree.

The Trigger: The 
SearchProvider
 (which is a child of all of them) would see these "new" references and think the user had just changed their filters or logged in. It would then restart the search fetch before the first one even had a chance to connect to the server.
How it created the "Bouncing Car" Hang
On a slow device or weak connection, the app would get caught in this loop:

SearchProvider
 starts a fetch...
- but then AsyncStorage finishes loading the "Sort" setting...
- which triggers a re-render
- which resets the search hook
- which starts a new fetch
 
Result: The car stays on screen forever because it’s constantly being "reset" and "restarted" by the hydration of other providers.

solution: 
Stable Hierarchy: By adding useMemo to the 
FilterProvider and AuthProvider, we ensured that even when AsyncStorage finishes loading, it only sends a single stable update. If the filters are the same as before, the SearchProvider will not re-render.

State Shield: modified the SearchContext so that the "Loading" state is now managed by a request counter. Even if a re-render happens during the first-load hydration, the "loading" car won't stay stuck; it now tracks the exact lifecycle of the requests and clears only when the actual data is ready.

Circuit Breaker: The new fetchingParamsRef logic specifically looks at the current search parameters. If AsyncStorage restoration triggers a re-render with the same parameters we are already fetching, we now silently bail out instead of restarting the engine.

In summary: We’ve stopped AsyncStorage from "fighting" with the network layer during the first 2 seconds of the app's life. Now, they work together: Storage hydrates, the Circuit Breaker verifies if a new fetch is needed, and the app remains smooth.



###======
The problem with the "Convert Filters" logic was the primary reason for the 1–3 second lag felt when switching tabs.

Fix

1. The Problem: "The Big Block"
Previously, the app was trying to convert every single filter for every single item in your history inside the main screen container:

The Waterfall of Work: For 50 saved searches, the app would run convertFiltersToTags 50 times in a row, every time you switched a tab or any state changed.

Deep Processing: This conversion isn't just a simple string change; it involves looking up translation keys, formatting prices, and mapping

Outcome: The JavaScript thread would completely "freeze" while doing this math. The UI couldn't animate the tab switch, making the app feel dead or stuck.

2. The Fix: "Lazy Processing"
Moved the conversion logic out of the main list and into the individual items:

Isolation: Now, each search item is responsible for converting its own filters via a useMemo in 
SavedSearchItem.container.tsx

Visibility-Based: Because it's inside the item, it only runs when that specific item is about to be rendered. If you have 50 searches, the app now only "converts" the 5 or 6 items that are actually visible on your screen.

Memoization: Once a filter is converted for an item, it stays "cached" unless that specific item's data changes.

3. The "Remote vs Local" ID Mismatch Fix
there was data integrity issue during conversion. Some older saved searches were using "Remote IDs" that the app's current filters didn't recognize correctly.

Fix:
SavedSearchItem.container.tsx
Added a mapping step (OLD_FILTER_IDS_MAP) during the conversion. This ensures that when a user clicks a saved search, the filters are translated into the "Local IDs" the app understands before navigating to the results. This prevents "empty" or "incorrect" search results when clicking an old saved search.
The Result: By moving the "Convert Filters" work from one giant block into 50 tiny, lazy pieces, we freed up the JS thread. The tab-switching is now instantaneous because the app no longer has to "think" about the whole list at once.
