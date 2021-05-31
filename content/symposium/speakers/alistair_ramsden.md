---
name: Alistair Ramsden
title: Improved synthetic data method for Stats NZ datalab microdata output
email: alistair.ramsden@stats.govt.nz
affiliation: Statistical Methods Census Methodology Team, Stats NZ
keywords:
- confidentiality
- methodology
- datalab
- synthetic data
presentation: alistair_ramsden.pptx
---

Stats NZ has approved a variation to Microdata Output Guide confidentiality rules, for the ‘He Ara Poutama mō te reo Māori SURF’ datalab project.

The synthetic data method is Classification And Regression Tree (CART) modelling, implemented using the Synthpop R package. The difference compared to existing rules is to generate, test, and release synthetic data counts tables with noised counts values {0,3,6,9,12,…}. Previously such values were {‘Suppressed’,6,9,12,…}.

The new method releases data with better utility (inferential validity), yet retaining adequate safety (disclosure control).

Next steps are to calculate Differential Privacy (DP) parameters {epsilon, delta} for this data and method.
