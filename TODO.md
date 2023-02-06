# TODO for Embla Flutter client

* Add widget tests
* Separate session button painter class from shared state in session.dart. Ugly stuff.
* Optimize animation redraws, or switch over to APNG for animation when Flutter adds support.
The client currently manually loads all the PNG animation frames into memory and
renders them on a ticker. This kind of basic functionality should not be handled by us
and reflects the immaturity of the Flutter environment. But support is apparently coming...
* Fix broken playback when session button is hammered repeatedly (only issue on iOS)
* Performance profiling
* Confirmation alert on completion of clear query history calls
* Add hardcoded timeout for streaming speech
* Open preferences if microphone/location enabled in settings but not allowed in system settings