---
title: "
Implementation and Analysis of Centroid Displacement-Based k-Nearest Neighbors"
date: 2022-11-24T14:55:33+13:00
description: "International Conference on Advanced Data Mining and Applications"
team:
- alex
- "Chukova SS"
- binh
tags:
draft: false
links:
- title: "Implementation and Analysis of Centroid Displacement-Based k-Nearest Neighbors"
  link: https://link.springer.com/chapter/10.1007/978-3-031-22064-7_31
mbie_funded: true
---

k-NN is a widely used supervised machine learning method in different domains. Despite its simplicity, effectiveness, and robustness, k-NN is limited to the use of the Euclidean distance as the similarity metric, the arbitrarily selected neighborhood size k, the computational challenge from high dimensional data, and the use of the simple majority voting rule. Among different variants of k-NN in classification, we sought to address the last issue and proposed the Centroid Displacement-based k-NN (CDNN), where centroid displacement is used for class determination. In this study, we present an implementation of CDNN for scikit-learn, a well-known machine learning library for the Python programming language, and a comprehensive comparative performance analysis of CDNN with different variants of k-NN in scikit-learn. We open-source our algorithm to benefit the users, and to the best of our knowledge, no similar studies on performance analysis of k-NN and its variants in scikit-learn have been done. We also examine the effectiveness of different distance metrics on the performance of CDNN on different datasets. Extensive experiments on real-world and synthetic datasets verify the effectiveness of CDNN compared to the standard k-NN and other state-of-the-art k-NN-based algorithms. The results from the distance metrics comparison study also show that other distance metrics can further improve the classification performance of CDNN.
