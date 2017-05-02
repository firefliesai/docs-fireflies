---
title: Fireflies API Reference

language_tabs:
  - javascript
  - bash
  - python

toc_footers:
  - <a href='mailto:enterprise@fireflies.ai?Subject=Registering%20for%20Fireflies%20API'>Sign Up for a Developer Key</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Fireflies API! You can use our API to access Fireflies API endpoints, which provides a service to extract tasks from conversations.

The Fireflies API consists of two parts

   - [Classification](#Classify) - Fireflies data model categorizes text to enable actions to be taken
   - [Feedback](#Feedback) - Response from end-user sent back to Fireflies for model tuning

We have language bindings in Node.js, Shell and Python! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# Rate Limits

Based on your subscription plan, your application is subject to daily and per-minute limits. There are three response headers you can use to check your quota allowance, the number of calls remaining on your quota and the time and date your quota will be reset:

- `X-RateLimit-Limit`: Daily limit of your current plan
- `X-RateLimit-Remaining`: The amount remained from your daily quota
- `X-RateLimit-Reset`: When the quotas are reset

<aside class="warning">
As these values are returned as response headers, you must make at least one successful API call before you can retrieve these values.
</aside>

# Authentication

> To authorize, use this code:

```javascript
var fireflies = require('node-fireflies-ml');

fireflies.authorize('API_KEY');
```

```python
import fireflies

fireflies.authorize('API_KEY')
```

```bash
# With shell, you can just pass the correct header with each request
```
```bash
curl "api_endpoint_here" \
  -H "Authorization: API_KEY"
```

> Make sure to replace `API_KEY` with your API key.

Fireflies uses API keys to allow access to the API. You can obtain a new Fireflies API key after your domain-specific model has been trained.

Fireflies expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: API_KEY`

<aside class="notice">
You must replace <code>API_KEY</code> with your personal API key.
</aside>

# Classify

## Classify Text Content

```javascript

fireflies.classify({
  text: 'sample sentence uttered from end user'
}, function(error, response) {
  if (error === null) {
    response['intents'].forEach(function(c) {
      console.log(c);
    });
  }
});

```

```python
text = "sample sentence uttered from end user"
classifications = fireflies.classify({"text": text})
for intent in classifications['intents']:
  print intent
```

```bash
curl "https://dev.firefliesapp.com/api/v1/classify" \
  -H "Authorization: API_KEY" \
  -H "Content-Type: application/json" \
  -X POST \
  -d text="sample sentence uttered from end user"
```

> The above command returns JSON structured like this:

```json
{
  "ok": true,
  "language":"en",
  "intents":[
    {
      "label":"action item",
      "code":"FF0001-wm5h3fe1f8ak",
      "confidence":1
    },
    ...
  ],
  "text":"sample sentence uttered from end user"
}
```

This endpoint retrieves all intents that are extracted from the text.

The returned intent can be helpful in providing the user an action. This **Classification** endpoint allows the developer to recommend actions to the end user, based on the confidence level of each intent.

We recommend a minimum confidence of 0.50 before taking action on a given intent, however, depending on the intrusiveness on the suggested action, this can be lowered.

<aside class="success">
 We [provide consultation](https://fireflies.ai/support) on best practices to take action on intents.
</aside>

Providing the `user` and `user_group` parameters on this request will improve recommendations when this API is used in conjunction with the Feedback API. Fireflies is able to provide intent classification on a per-group and per-user basis, by factoring in the responses to previous suggestions in the data model. For most customers, the models are trained once every week. [Contact us](https://fireflies.ai/support)  for a finer-grained control and frequency of model deployment.

Be sure to use the returned `code` parameter in the request to the Feedback API response so that Fireflies understands which recommendation was acted on learns over time.

### HTTP Request

`POST https://dev.firefliesapp.com/api/v1/classify`

### Query Parameters

Parameter |  Type |  Optional | Description
--------- | ----------- | ----------- | -----------
text | String | false | The sentence to receive an intent estimate from.
user | String | true | A unique identifier for the end user uttering the text.
user_group | String | true | A unique identifier for a group containing the end user (team, company, etc).


# Feedback

## Submit User Response

```javascript

fireflies.feedback({
  code: 'CODE_FROM_CLASSIFY_SUGGESTION', /* ex: 'FF0001-wm5h3fe1f8ak' */
  result: 'accept'
}, function(error, response) {
  if (error) {
    console.log(error)
  }
});

```

```python
code = "CODE_FROM_CLASSIFY_SUGGESTION"
result = "accept"
fireflies.feedback({"code": code, "result": result})

```

```bash
curl "https://dev.firefliesapp.com/api/v1/feedback" \
  -H "Authorization: API_KEY" \
  -H "Content-Type: application/json" \
  -X POST \
  -d code="CODE_FROM_CLASSIFY_SUGGESTION" \
  -d result="accept"
```

> The above command returns JSON structured like this:

```json
{
  "ok":true,
  "result": "accept"
}
```

This endpoint accepts feedback from the end user on the suggested intent from the Classify API. Your application should unobtrusively present the user the suggestion between calls of the Classify API and the Feedback API. After the user has been given time to act on the suggestion (we suggest 5 minutes after known activitiy), use this API to improve future suggestions.

<aside class="success">
We [provide consultation](https://fireflies.ai/support) on best practices to collect user feedback from suggested actions.
</aside>

Provide the `code` parameter with every request to the Feedback API. This parameter should be equal to the Classify API intent's `code` parameter, with which the feedback result is associated.

Accepted `result` values to the Fireflies Feedback API include `["accept","decline","ignore","spam"]`. Map the user's response as closely as possible to one of these four values. If more precise feedback control is required, please [contact us](https://fireflies.ai/support) for custom response support.

Providing the `user` and `user_group` parameters on this request will improve recommendations when this API is used in conjunction with the Classify API. Fireflies is able to provide intent classification on a per-group and per-user basis, by factoring in the responses to previous suggestions in the data model. For most customers, the models are trained once every week. [Contact us](https://fireflies.ai/support)  for a finer-grained control and frequency of model deployment.

### HTTP Request

`POST https://dev.firefliesapp.com/api/v1/feedback`

### Query Parameters

Parameter |  Type |  Optional | Description
--------- | ----------- | ----------- | -----------
code | String | false | The code associated with the recommended action. This code comes in the response to the Classify API.
result | String | false | The result of the recommendation. Takes on one of these values: `["accept","decline","ignore","spam"]`
user | String | true | A unique identifier for the end user uttering the text.
user_group | String | true | A unique identifier for a group containing the end user (team, company, etc).

