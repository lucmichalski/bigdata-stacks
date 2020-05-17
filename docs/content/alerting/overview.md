# Alert Manager

The built-in Alertmanager is simple:

Must be switch ON in a Vigie Config File:

```
[alerting]
  enable = true
```

## Frequency intervals

At each interval the bad tests are evaluated and sent as notification.

> The lower the interval, the sooner you will be notified.

## Notification

A notification containing the summary of all the bad tests will be sent.

If no changes occur between two intervals, no new notifications will be sent to avoid spamming.

### Reminder

**The reminder serves two purpose:**

* **A classic reminder,** if no change takes place for a long time, the reminder will remind you that you have some bad tests to resolve.
* **As a dead man's switch,** if for any reason the reminder is not received: Vigie may have problems sending messages.

### Email

Example of a Email Notification *(Vigie v0.3)*

![Screenshot](../../assets/img/notif_email.png)

### Discord

Example of a Discord Notification *(Vigie v0.3)*

![Screenshot](../../assets/img/notif_discord.png)

### Slack

Example of a Slack Notification *(Vigie v0.4)*

![Screenshot](../../assets/img/notif_slack.png)