---
title: "Bayesian Demography with iNZight"
date: 2021-04-14T14:55:33+13:00
description: "A prototype for a Bayesian demographic modelling module using iNZight's add-on system."
team:
- tom
- "John Bryant^1"
affiliations:
- "Bayesian Demography^1"
tags:
- inzight
- demography
- bayesian
- accessibility
draft: false
files:
- title: "Report of the prototype iNZight module"
  path: "bayesian-demography-with-inzight.pdf"
links:
- title: Github repository
  link: https://github.com/terourou/small-area-estimation
mbie_funded: true
citation: "Elliott, T. and Bryant, J. (2021). Bayesian Demography with iNZight. *Te Rourou Tātaritanga*. https://terourou.org/outputs/inzight_demography"
---

Bayesian demography is an important technique for minority communites, and requires special methods to infer the correct results. A set of existing R packages provide a way for researchers to fit hierarchical Bayesian models to estimate birth rates, life expectancy, or forecast important values such as diabetes rates.

iNZight is a tool for exploring and analysing data, and provides a way for researchers low on time, money, and/or skill to quickly generate the necessary results with minimal effort. It also provides the capabilities to do some basic data wrangling, including aggregation of data into an array of counts, necessary for fitting demographic models.

We have developed a prototype for a Bayesian small area estimation module within iNZight, allowing users to create the necessary aggregated array and fit a set of simple models to this data. The results of the MCMC simulation are displayed in the graph automatically, and forecasts and other posterior estimation procedures can be carried out --- all using simple point-and-click mechanisms.
