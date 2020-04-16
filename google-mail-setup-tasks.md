# Google Hosted Mail Setup Info

## Add users

1. Open your [Google Admin console](https://admin.google.com/) .
2. Go to [Users](https://admin.google.com/AdminHome#UserList:org).
3. Select the [organizational unit](https://support.google.com/a/answer/182433) to which you want to add the user. (You might need to click ![Open](https://lh3.googleusercontent.com/bUZKYBdWi5CQkGefX-wF7eB8CZL0y3tPzA-xuz4hj__HCvDtC_NkDAnzSL4J1gTpag=w18) to show the organizational units.)
4. At the top of the page, click **Add new user**

## DNS Records

Use the [G Suite Toolbox Dig](https://toolbox.googleapps.com/apps/dig/) to check DNS record values if you want info about your DNS records.
Use this tool to generate new SPF records:  https://www.spfwizard.net/ 

Use one of these SPF Checkers to check SPF records:

 https://www.dmarcanalyzer.com/spf/checker/ 



### MX Records

These values might change, so you should probably [check here](https://support.google.com/a/answer/174125?hl=en) to be sure of the current recommended values. 

| Name/Host/Alias    | Time to Live (TTL*) | Record Type | Priority | Value/Answer/Destination |
| :----------------- | :------------------ | :---------- | :------- | :----------------------- |
| *@ or leave blank* | 3600                | MX          | 1        | ASPMX.L.GOOGLE.COM       |
| *@ or leave blank* | 3600                | MX          | 5        | ALT1.ASPMX.L.GOOGLE.COM  |
| *@ or leave blank* | 3600                | MX          | 5        | ALT2.ASPMX.L.GOOGLE.COM  |
| *@ or leave blank* | 3600                | MX          | 10       | ALT3.ASPMX.L.GOOGLE.COM  |
| *@ or leave blank* | 3600                | MX          | 10       | ALT4.ASPMX.L.GOOGLE.COM  |

For specific instructions for various web hosts, check out  https://support.google.com/a/topic/1611273 
For instructions for WHM check out:  https://support.google.com/a/answer/54718?hl=en&ref_topic=4445221 
For instructions for CPanel check out  https://support.google.com/a/answer/54717?hl=en&ref_topic=4445219 

### SPF Record

To create an SPF record for your domain, you can simply have the record refer to the Google SPF record. Your domain automatically inherits changes to the Google IP addresses.

> `v=spf1 include:_spf.google.com ~all`

For the literal IP addresses of G Suite mail servers, use DNS lookup commands (`nslookup`, `dig`, `host`) to retrieve the SPF records for the domain _spf.google.com:

> `nslookup -q=TXT _spf.google.com 8.8.8.8`

This returns a list of the domains included in Google's SPF record, such as:
_netblocks.google.com, _netblocks2.google.com, _netblocks3.google.com

Now look up the DNS records associated with those domains, one at a time:

> `nslookup -q=TXT _netblocks.google.com 8.8.8.8nslookup -q=TXT _netblocks2.google.com 8.8.8.8nslookup -q=TXT _netblocks3.google.com 8.8.8.8`

The results contain the current range of addresses.

**Note**: These netblocks also include IP addresses for all other G Suite services (for example, docs.google.com or drive.google.com). However, because mail can be served from any point in Google’s infrastructure, it’s important to include *all* of these records.

**Note**: To get the main IP address of a CPanel server run this command:

> `cat  /var/cpanel/mainip`

## Set up SMTP Relay

Sendmail and Postfix config instructions are below. For instructions for all types of mail servers, check out [this google support document](https://support.google.com/a/answer/2956491).

### Sendmail

Follow the instructions below to set up the SMTP relay service for Sendmail. These instructions are designed to work with a majority of deployments.

Changing server timeouts should not be necessary. In Sendmail, the server timeout is set in the **Timeout.datafinal** value. By default, it's set to one hour. If the **Timeout.datafinal** value has been changed to a lower value, raise the value to one hour.

**To configure a smarthost for Sendmail:**

1. Add the following line to the /etc/mail/sendmail.mc file:
   **define(`SMART_HOST', `smtp-relay.gmail.com')****​​**
2. Stop and restart the sendmail server process.
3. When you've completed your configuration, send a test message to confirm that your outbound mail is flowing.

In addition to the server configuration steps listed above, you might have to perform an additional configuration on your server if either of the following is true:

- You click the **Any address** option in the **Allowed senders** setting and you send mail from a domain you do not own, such as yahoo.com.
- You send mail without a “From” address, such as non-delivery reports or vacation “out of office” notifications.

In these cases, you must configure your mail server to either ensure that the server is using SMTP AUTH to authenticate as a registered G Suite user or to present one of your domain names in the HELO or EHLO command. See the instructions [here](http://serverfault.com/questions/205271/how-to-specify-outgoing-helo-with-sendmail).

**Important:** G Suite Support does not provide technical support for configuring on-premise mail servers or third-party products. In the event of a Sendmail issue, you should consult your Sendmail administrator. These instructions are designed to work with the most common Sendmail scenarios. Any changes to your Sendmail configuration should be made at the discretion of your Sendmail administrator.

### Postfix

Follow the instructions below to set up the SMTP relay service for Postfix. These instructions are designed to work with a majority of deployments. There is no need to increase the timeouts for Postfix servers. The default timeout settings are appropriate.

**To set up a smart host for Postfix:**

1. Add the following line to your configuration file (example path /etc/postfix/main.cf):
   **relayhost = smtp-relay.gmail.com:25**
2. Restart Postfix by running the following command:
   **# sudo postfix reload**
3. Send a test message to confirm that your outbound mail is flowing.

Determine whether either of the following is true:

- You click the **Any address** option in the **Allowed senders** setting and you send messages from a domain you do not own, such as yahoo.com.
- You send messages without a “From” address, such as non-delivery reports or vacation “out of office” notifications.

If either is true, configure your mail server to either ensure that the server is using SMTP AUTH to authenticate as a registered G Suite user or to present one of your domain names in the HELO or EHLO command. See the instructions [here](http://www.postfix.org/BASIC_CONFIGURATION_README.html).

**Important:** G Suite Support does not provide technical support for configuring on-premise mail servers or third-party products. In the event of a Postfix issue, you should consult your Postfix administrator. These instructions are designed to work with the most common Postfix scenarios. Any changes to your Postfix configuration should be made at the discretion of your Postfix administrator.

## Set up a catch-all address

A catch-all address ensures that messages sent to an incorrect email address for a domain are still received.

To set up a catch-all address:

1. Do the [initial steps](https://support.google.com/a/answer/6297084#initial-step) to sign in, select the organization if necessary, open the Routing setting, and enter a description for the new setting.
2. For email [messages to affect](https://support.google.com/a/answer/6297084#affect-messages), select **Inbound, Internal-receiving**, or both.
3. Set up an [envelope filter](https://support.google.com/a/answer/6297084#envelope-filter) if you want the rule to affect only specific envelope senders and recipients. You can specify single recipients by entering an email address for that user. You can also specify groups.
4. Under [For the above types of messages](https://support.google.com/a/answer/6297084#consequences), select **Modify message**.
5. Under Envelope recipient, select **Change envelope recipient**.
6. Select **Enter new username**.
7. Enter a catch-all address in the empty field next to **@exisiting-domain**. For example, enter **jsmith**.
8. Click **Show options**.
9. Under [Account types to affect](https://support.google.com/a/answer/6297084#account-types), check the **Unrecognized / Catch-all** box. Uncheck **Users** and **Groups**.
10. Click **Add setting**.
11. [Save the configuration](https://support.google.com/a/answer/6297084#save-configuration).