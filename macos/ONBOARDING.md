# Onboarding

## Pre-requisites

```bash
brew install notmuch
brew install uv
```

## Installing

```bash
bash install-with-uv.sh
```

## Configure notmuch

- Execute `notmuch setup` and fill the prompts with your name and email address
- Edit the file `~/.notmuch-config` and add a line under `[database]` to the path where you want to store your data, for example:

```toml
[database]
path=/Users/account/mail
```

## Configure lieer

Create a folder for each email account and enter that directory to configure lieer with your email account:

```bash
mkdir -p ~/mail/gmail-account-name
cd ~/mail/gmail-account-name
gmi init account@email-address.com
```

Lieer will print an authentication link in your terminal and open that link in your browser. Complete the authentication prompt to generate access credentials for lieer.

## Pulling your email data

Remember to enter your email account directory to execute lieer. Use the commands below to download all your emails and apply the notmuch tags to new messages:

```bash
cd ~/mail/gmail-account-name
gmi pull
notmuch new
```

## Useful commands

```bash
notmuch count '*'
notmuch search tag:inbox
notmuch show <thread-id>
```
