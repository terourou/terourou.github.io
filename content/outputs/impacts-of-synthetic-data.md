---
title: "The Impact of Synthetic Data Generation Techniques in IDI Research"
date: 2023-01-01T12:00:00+13:00
description: ""
team:
- binh
- alex
- "Marianna Pekar^1"
- "Simon Anastasiadis^1"
tags:
- IDI
- synthetic-data
affiliations:
- "Social Wellbeing Agency^1"
draft: false
---

Synthetic data is a versatile tool. When used correctly, it is compliant with data confidentiality principles, rules and methods set out by Statistics NZ. We believe synthetic data in general may have the risk of single out an individual in the dataset with extreme value and linkage attack with more than one dataset. In order to mitigate these risks, we will follow NZ Stats release guidance and expertise from the NZ Stats release team. In the meanwhile, we will utilize a joint probability- based data synthesis method, which completely breaks the 1-1 relation between the original and synthetic records. Contrary to other techniques, like pseudonymization, there is no key to go back from the synthetic records to the original ones, as this process is irreversible. Differential Privacy (DP) will be explored to be included in the data synthesis practice too. For data pre-processing, PII columns will be excluded in the model training and outliers will be removed. Post processing will be performed to remove synthetic samples, which are too close to any of the original samples, based on distance metrics. Informatics for Social Wellbeing Programme and Social Wellbeing Agency are proposing to look at use cases applicable to address the challenges of the IDI environment to assess the advantages and disadvantages of using synthetic data for different purposes. These use cases include (1) using low-fidelity synthetic data generated outside of IDI for training and demonstration of methods and (2) using high quality synthetic dataset generated inside the IDI environment to assess the advantages of using advanced machine learning methods outside of IDI. Such methods cannot be applied in the IDI because some of these methods require GPU and the software suite and range within IDI is limited.


### Research objectives

Evaluating use cases applicable to address the challenges of the IDI environment by assessing the advantages and disadvantages of using synthetic data.
These use cases include
1. Using low-fidelity synthetic data generated outside of IDI for training purpose and
2. Using high quality synthetic dataset generated inside the IDI environment to apply advanced machine learning methods. Models trained on this type of synthetic data would be imported back into the IDI environment to assess accuracy gains on real data.

Research question(s) to be investigated:
1. Is synthetic data created from unit-record level data in IDI effective and safe to use for training and parameter-tuning purposes of IDI? Is it preferable to doing the same inside IDI?
2. What are methods that benefit from application outside the IDI environment using synthetic data, i.e. microsimulation models, applying Deep Learning or other ML for e.g. building a classification model.

Anticipated outcomes include:
- Establishing when and how should synthetic data be used (i.e. purposes and methods)
- What method of data generation should be used for specific purposes?
- What else should a researcher consider when using synthetic data for research
