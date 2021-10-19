# BodyFatCalculator

The body fat percentage is a measure of fitness level, which can be calculated as the total mass of fat divided by total body mass. In this project, a simple, robust, and accurate method to estimate the percentage of body fat using available measurements is proposed, related to man's weight, circumferences of abdomen, and thigh. We will follow several steps such as data cleaning, model building and selection, and model diagnostics. The final measurement will be a linear model with three variables which are the circumference of the abdomen, the circumference of the thigh, and body weight.
<!-- *** -->
<!-- Group 2, Module 2, BodyFatCalculator -->
***

## Table of Contents
  <!-- - [Description](#description) -->
  - [Dependencies](#dependencies)

  - [Installation](#installation)

  - [File Description](#file-description)

  - [Link to the web-based app](#link-to-the-web-based-app)
  
  - [Acknowledgements](#acknowledgements)

  
  - [Contributors](#contributors)

<!-- ## Description -->
***
## Dependencies
- [R](https://www.r-project.org/)
- [R Shiny](https://github.com/rstudio/shiny)(Shiny is supported on the latest release version of R, as well as the previous four minor release versions of R)



## Installation

This module depends upon a knowledge of  the packages in R.

```
install.packages("shiny")
install.packages("car")
install.packages("tidyverse")
install.packages("caret")
install.packages("broom")
install.packages("MVA")
install.packages("biwt")
install.packages("robustbase")
```


## File Description

- BodyfatShiny Folder - Code for Shiny App of body fat calculator based on final model.
- BodyFat.csv - the raw data set of available measurements include age, weight, height, bmi, and various body circumference measurements.
- Data Preprocessing.R - R code for data cleaning on Bodyfat.csv.
- Model Selection and Diagnostics.R - R code for model building, selection based on cleaned data and diagnostics for the selected model.
- Summary.pdf - A two-page .pdf file of the summary of the whole project, including the description of project process and conclusions.
- Presentation.pdf - A .pdf file of the slides we used in presentation.

## Link to the web-based app

[Shiny APP Link](https://ouyangxu.shinyapps.io/BodyfatShiny/)

### Preview:
<img src="/BodyFatShiny/ShinyPreview.png" width="600"/>

## Acknowledgements
This project is a project of STAT 628 Fall 2021 UW-Madison, supervised by Prof.Hyunseung Kang.


## Contributors
* **Bowen Tian** - (btian23@wisc.edu)
* **Ouyang Xu** - (oxu2@wisc.edu)
* **Tianhang Li** -(tli425@wisc.edu)

