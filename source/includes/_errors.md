# Errors

The Fireflies API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Something is wrong with your request
401 | Unauthorized -- Your API key is invalid
403 | Forbidden -- The resource requested is hidden for administrators only
404 | Not Found -- The specified resource could not be found
405 | Method Not Allowed -- You tried to access a resource with an invalid method
406 | Not Acceptable -- You requested a format that isn't json
410 | Gone -- The resource requested has been removed from our servers
429 | Too Many Requests -- You're requesting too the endpoint too fast! Slow down!
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
