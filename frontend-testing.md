# Headless Browsers and Automation

## Puppeteer

[Puppeteer](https://github.com/puppeteer/) is a Node library which provides a high-level API to control Chrome or Chromium over the [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/). Puppeteer runs [headless](https://developers.google.com/web/updates/2017/04/headless-chrome) by default, but can be configured to run full (non-headless) Chrome or Chromium. Recently Mozilla began switching to Puppeteer as well, however, it requires the Firefox Nightly build and does not work right yet (trust me on that).

- [Main Puppeteer Repository and QuickStart Guide](https://github.com/puppeteer/puppeteer/)
  - Definitely check out the [debugging tips](https://github.com/puppeteer/puppeteer/#debugging-tips)!!!
- [Puppeteer API Docs](https://github.com/puppeteer/puppeteer/blob/v5.5.0/docs/api.md)
- To see the current Chromium revision  used with Puppeteer check out [revisions.ts](https://github.com/puppeteer/puppeteer/blob/main/src/revisions.ts) in the github repository.