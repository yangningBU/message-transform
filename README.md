# MessageTranform

## Install
I'm using direnv with `ruby-2.6.3`
```
bundle install --binstubs
```

## Tests
```
rspec --format doc
```

## Example
```ruby
verbs = ["like", "going", "buy", "eat"]
source = (
  "I like going to Whole Foods during my lunch break " +
  "to buy a salad and eat there."
)
result = (
  'I <a href="#like">like</a> <a href="#going">going</a> to Whole Foods ' +
  'during my lunch break to <a href="#buy">buy</a> a salad and ' +
  '<a href="#eat">eat</a> there.'
)
MessageTransform.highlight_tokens(source, verbs) == result
```

## Ideas
Regex matching to formatting / message output
Examples:
1. When I post something that looks like a URL to a JIRA ticket, slack parses the URL and:
    - if I have an existing authorized connection to the JIRA integration, then:
      - authenticate and open URL to get contents
      - form a custom JIRA ticket card under the source message
    - if not then create message to ask user if they want to authorize JIRA and get a better user experience
2. When I post a message about X topic that includes Y words, do Z (this looks like that ML lib the OI team is using)
3. When I do a entry for DD like EKGM, the post automatically wraps the words in a linkable tag (like slack does for highlighted words or ones with markdown-light modifiers)