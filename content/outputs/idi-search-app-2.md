---
title: "IDI Search App"
date: 2022-12-07T09:57:23+13:00
description: "A web app for searching New Zealand's IDI"
team:
- tom
- barry
- eileen
- colin
- andrew
tags:
- IDI
url: /idisearch
draft: false
mbie_funded: true
---

The IDI Search App allows researchers to explore what variables are available in the IDI, and provides descriptions and SQL information about each variable. The app uses _Data Dictionaries_ from Statistics NZ to collate collection, dataset, and variable information, which is stored within a relational database. The front end is powered by [NextJS](https://nextjs.org), allowing us to provide an interface for users to list all variables or, more usefully, those variables, datasets, and collections that match a specific search term. We also periodically obtain a list of variables in the current IDI refresh, and display this information on each variable's information page so that researchers can see whether they might need to access an older refresh to get the data they are after.

The current feature set includes:
- information about a subset of agencies, collections, datasets, and variables where we have received the necessary data dictionaries
- listing of collections belonging to an agency; datasets in a collection; variables in a dataset
- for datasets, a list of 'Linking' variables is also displayed (either agency or IDI linking variables)
- search bar to search all fields to filter the master list of agencies/collections/datasets/variables, with the search term highlighted in descriptions
- display of refresh availability to see which IDI refreshes a variable is available in (this does not apply to Adhoc tables)

Future work will:
- display links to other names of variables or datasets, so researchers can update code for new refreshes
- allow for multiple search terms (AND, OR, etc.)
- continue adding more data dictionaries
- add facilities for users to register and provide comments on agencies/collections/datasets/variables

The app can be viewed at: https://idisearch.terourou.org/

If you would like to provide feedback or offer support for the app's development, please get in touch with [Tom Elliott](/team/tom).
