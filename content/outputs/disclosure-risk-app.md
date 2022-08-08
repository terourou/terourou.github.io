---
title: "Disclosure Risk Calculator"
date: 2022-07-15T10:45:04+13:00
description: "A web app for estimating the disclosure risk of a dataset"
team:
- tom
- barry
- "Shaun Roberts^1"
affiliations:
- "AUT^1"
tags:
- disclosure risk
- cloud computing
mbie_funded: true
links:
- title: Disclosure Risk Calculator App (website)
  link: https://risk.terourou.org
images:
- /img/disclosure-risk-logo.png
---

Before a dataset is made public, it needs to be checked to ensure no individuals are at risk of being identified. We developed this calculator to quickly assess a dataset for disclosure risk based on a selection of variables.

There are two aspects to the calculator:

### 1. Overall risk

This is the risk of disclosure given the currently chosen variablse and sampling fraction. The calculations here use only information about the number of unique and paired observations, and is easily performed in the browser. **The data is not uploaded to any external server.** These results are estimated using Robert's work.

### 2. Variable contributions and individual (row) risk

To calculate more detailed summaries, we use the **sdcMicro** package in `R`. Do obtain access from the web app (written with [reactjs](react.js)) we use [Rserve](https://www.rforge.net/Rserve/), accessed via the [react-rserve](https://www.npmjs.com/package/@tmelliott/react-rserve). While this does involve uploading the dataset to a remote server, the construction ensures that the dataset is accessible to only the current session. In brief, in user's connection is private and accessible only to them, and once the connection is broken (i.e., when the browser closes) the process is killed and the data vanished (it is only ever stored in memory). Details on how this works can be found [on the app's about page](https://risk.terourou.org/about).

If a user chooses to, they can upload their data to our server where it will be processed using the [**sdcMicro**](http://www.ihsn.org/software/disclosure-control-toolbox) package. This will output the individual variable contributions to the overall disclosure risk and a table showing each row's individual disclosure risk, with the highest at the top.
