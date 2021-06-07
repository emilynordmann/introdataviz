--- 
title: "Data visualisation using R, for researchers who don’t use R"
author: "Emily Nordmann, Phil McAleer, Wilhelmiina Toivo, Helena Paterson, Lisa DeBruine"
date: "2021-06-04"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "Abstract here."
---




# Overview {-}

Please cite this book as:

<!--chapter:end:index.Rmd-->




# Introduction

Use of the programming language R for data processing and statistical analysis by researchers is increasingly common with a GET THE STATS FROM THAT THING I SAW ABOUT R ON TWITTER rise since XXXX (REF). In addition to benefiting reproducibility and transparency, one of the advantages of using R is that researchers have a much larger range of fully customisable data visualisations options than are typically available in point-and-click software, due to the open-source nature of R. These visualisation options not only look attractive, but can increase transparency about the distribution of the underlying data rather than relying on commonly used visualisations of aggregations such as bar charts of means [@newman2012bar].

Yet, the benefits of using R are hindered by its notoriously steep learning curve [@robins2003learning] and that that only a minority of psychology programmes currently teach programming skills [@rminr] with the majority of both undergraduate and postgraduate courses using proprietary point-and-click software such as SPSS or Microsoft Excel.

In this paper we aim to provide a practical introduction to data visualisation using R, specifically aimed at researchers who have little to no prior experience using R. We detail the rationale for using R for data visualisation, introduce the "grammar of graphics" that underlies data visualisation using the `ggplot` package, and provide a tutorial that walks the reader through how to replicate plots that are commonly available in point-and-click software such as histograms and boxplots, as well as showing how the code for these "basic" plots can be easily extended to less commonly available options such as violin-boxplots, raincloud plots, and heat-maps.

## Why R for data visualisation?

Data visualisation benefits from the same advantages as statistical analysis when writing code rather than using point-and-click software -- reproducibility and transparency. The need for psychological researchers to work in reproducible ways has been well-documented and discussed in response to the replication crisis [e.g. @munafo2017manifesto] and we will not repeat these arguments here. However, there is an additional selfish benefit to reproducibility that is less frequently acknowledged compared to the loftier goals of improving psychological science: if you write code to produce your plots, future-you can reuse and adapt that code rather than starting from scratch each time.

In addition to the benefits of reproducibility, using R for data visualisation gives the researcher almost total control over each element of the plot. Whilst this flexibility can seem daunting to novice users of R, if one can survive the initial learning curve, the ability to write reusable code recipes (and use recipes created by others) is highly advantageous. The level of customisation and the professional outputs available using R has led to news outlets such as the BBC [@BBC-R] and the New York Times [@NYT-R] to adopt R as their preferred data visualisation tool.

## A layered grammar of graphics

There are multiple approaches to data visualisation in R; in this paper we will be using the popular package[^1] `ggplot2` [@ggplot2] which is part of the larger `tidyverse`[^2] [@tidyverse] collection of packages that provide functions for data wrangling, descriptives, and visualisation. A grammar of graphics [@wilkinson2005graph] is a standardised way to describe the components of a graphic. `ggplot2` uses a layered grammar of graphics [@wickham2010layered], in which plots are built up in a series of layers. This approach may be familiar to users of MATLAB but can be unintuitive to those used to creating plots in Excel or SPSS.

[^1]: The power of R is that it is extendable and open source - put simply, if a function doesn't exist or is difficult to use, anyone can create a new **package** that contains data and code to allow you to perform new tasks. You may find it helpful to think of packages as additional apps that you need to download separately to extend the functionality beyond what comes with "Base R".

[^2]: Because there are so many different ways to achieve the same thing in R, when Googling for help with R, it is useful to append the name of the package or approach you are using, e.g., "how to make a histogram ggplot2".

Figure\ \@ref(fig:layers) displays the evolution of a simple scatterplot using this layered approach. First, the plot space is built (layer 1); the variables are specified (layer 2); the type of visualisation (known as a `geom`) that is desired for these variables is specified (layer 3) - in this case `geom_point()` is called to visualise individual data points; a second geom is added to include a line of best fit (layer 4), the axis labels are edited for readability (layer 5), and finally, a theme is applied to change the overall appearance of the plot (layer 6).

<div class="figure" style="text-align: center">
<img src="01-ch1_files/figure-html/layers-1.png" alt="Evolution of a layered plot" width="100%" />
<p class="caption">(\#fig:layers)Evolution of a layered plot</p>
</div>

Importantly, each layer is independent and independently customisable. For example, the size, colour and position of each component can be adjusted, or one could, for example, remove the first geom to only visualise the line of best fit, simply by removing the layer that draws the data points (Figure \ \@ref(fig:remove-layer)). The use of layers makes it easy to build up complex plots step-by-step, and to adapt or extend plots from existing code.

<div class="figure" style="text-align: center">
<img src="01-ch1_files/figure-html/remove-layer-1.png" alt="Plot with scatterplot layer removed." width="100%" />
<p class="caption">(\#fig:remove-layer)Plot with scatterplot layer removed.</p>
</div>

## Simulated dataset

For the purpose of this tutorial, we will use simulated data for a 2 x 2 mixed-design Stroop test experiment. There are 100 rows (1 for each subject) and 7 variables:

- Participant information:
    -   `id`: Participant ID
    -   `age`: Age
- 1 between-subject IV:
    -   `language`:  Language group (1 = monolingual/2 = bilingual)
- 4 columns for the 2 dependent variables for RT and accuracy, crossed by the within-subject IV of condition:
    -   `rt`_cong`: Reaction time (ms) for congruent trials
    -   `rt`_incon`: Reaction time (ms) for incongruent trials
    -   `acc_cong`: Accuracy for congruent trials
    -   `acc_incon`: Accuracy for incongruent trials
    
The simulated dataset and tutorial code can be found in the online supplementary materials. For newcomers to R, we would suggest working through this tutorial with the simulated dataset, then extending the code to your own datasets with a similar structure, and finally generalising the code to new structures and problems. 



## Setting up R and RStudio

We strongly encourage the use of RStudio to write code in R. R is the programming language whilst RStudio is an *integrated development environment* that makes working with R easier. More information on installing both R and RStudio can be found in the additional resources.

Projects are a useful way of keeping all your code, data, and output in one place. To create a new project, open RStudio and click `File - New Project - New Directory - New Project`. You will be prompted to give the project a name, and select a location for where to store the project on your computer. Once you have done this, click `Create Project`. Download the simulated dataset from the online materials and save the file (  `stroop_data.csv`) to this folder. The files pane on the bottom right of RStudio should now display this folder and the files it contains - this is known as your *working directory* and it is where R will look for any data you wish to import and where it will save any output you create.

This tutorial will require you to use the packages contained with the `tidyverse` collection. Additionally, we will also require use of `patchwork`. To install these packages, copy and paste the below code into the console (the left hand pane) and press enter to execute the code.


```r
# only run in the console, never put this in a script 
package_list <- c("tidyverse", "patchwork")
install.packages(package_list)
```

Finally, so that you can save your code to return to later, open a new script `File - New File - R Script` and then save it using `File - Save`. R will default to saving the script in your project folder. This is where we will write all the tutorial code from now on. We have also provided an R Markdown copy of all below code in the supplementary materials. The reason that the install packages code is not included in the script is that every time you run the install command code it will install the latest version of the package and so leaving this code in your script can lead you to unintentionally install a package update you didn't want. For this reason, avoid including install code in any script. R scripts (or R code chunks if you are using Markdwon) treat anything you write in them as code by default. If you wish to write a comment with further information about your code (which we encourage you to do), you must use the hashtag sign to "comment it out".


```r
this_is_code
# this is a comment
```

## Preparing your data

Before you start visualizing your data, you need to get the data into an appropriate format. These preparatory steps can all be dealt with reproducibly using R and the additional resources section points to extra tutorials for doing so. However, performing these types of tasks in R can be difficult for new learners and the solutions and tools are dependent on the idiosyncrasies of each dataset. For this reason, in this tutorial we encourage the reader to complete these steps using the method they are most comfortable with and to focus on the aim of data visualisation.

### Data format

The simulated Stroop data is provided in a `csv` file rather than e.g., `xslx`. Functions exist in R to read many other types of data files, however, you can convert an `xlsx` spreadsheet to `csv` by using the `Save As` function in Microsoft Excel. Note that `csv` files strip all formatting and only store data in a single sheet; you may wish to create a `csv` file that only contains the data you wish to visualise that is part of a larger workbook. When working with your own data, any files you import should remove summary rows or additional notes and should only contains the rows and columns you want to plot.

### Variable names

Ensuring that your variable names are consistent can make it much easier to work in R. We recommend using short but informative variable names, for example `rt_cong` is preferred over `dv1_iv1` or `reaction_time_congruent_condition` because these are either hard to read or hard to type.

It is also helpful to have a consistent naming scheme, particularly for variable names that require more than one word. Two popular options are `CamelCase` where each new word begins with a capital letter, or `snake_case` where all letters are lower case and words are separated by an underscore. For the purposes of naming variables, avoid using any spaces in variable names (e.g., `rt cong`) and consider the additional meaning of a separator beyond making the variable names easier to read. For example, `rt_cong`, `rt_incon`, `acc_cong`, and `acc_incon` all have the DV to the left of the separator and the level of the IV to the right. `rt_cong_condition` on the other hand has two separators but only one of them is meaningful and it is useful to be able to split variable names consistently. In this paper, we will use `snake_case` and lower case letters for all variable names so that we don't have to remember where to put the capital letters.

When working with your own data, you can rename columns in Excel, but there are also instructions for how to do this in R in the additional resources.

### Data values

A great benefit to using R rather than SPSS is that categorical data can be entered as text. In the tutorial dataset, language group is entered as 1 or 2, so we can show you below how to recode numeric values into factors with labels, which also sets the order of display for graphs. However, we recommend recording meaningful labels rather than numbers to avoid misinterpreting data due to coding errors. Note that values must match *exactly* in order to be considered in the same category and R is case sensitive, so "mono", "Mono", and "monolingual" would be classified as members of three separate categories.

Finally, cells that represent missing data should be left empty rather than containing values like `NA`, `missing` or `0`. A complementary rule of thumb is that each column should only contain one type of data, such as words or numbers, not both.


<!--chapter:end:01-ch1.Rmd-->



# Chapter 2

## Loading packages

To load the packages that have the functions we need, use the `library()` function. Whilst you only need to install packages once, you need to load any packages you want to use with `library()` every time you start R. When you load the tidyverse, you actually load several separate packages that are all part of the same collection and have been designed to work well together. R will produce a message that tells you the names of all the packages that have been loaded.


```r
library(tidyverse)
library(patchwork)
```

## Loading data

Download the data here: <a href="stroop_data.csv" download>stroop_data.csv</a>

To load the simulated data we use the function `read_csv()` from the `readr` tidyverse package.


```r
dat <- read_csv(file = "stroop_data.csv")
```

This code has created an object `dat` that contains the data from the file `stroop_data.csv`. This object will appear in the environment pane in the top right. Note that the name of the data file must be in quotation marks and the file extension (`.csv`) must also be included. If you receive the error `…does not exist in current working directory` it is highly likely that you have made a typo in the file name (remember R is case sensitive), have forgotten to include the file extension, or that the data file you want to load is not stored in your project folder. If you get the error `could not find function` it means you have either not loaded the correct package, or you have made a typo in the function name.

To view the dataset, click `dat` in the environment pane or run `View(dat)` in the console. The environment pane also tells us that the object `dat` has 100 observations of 7 variables, and is a useful quick check to ensure one has loaded the right data.

## Handling numeric factors

Another useful check is to use the functions `summary()` and `str()` (structure) to check what kind of data R thinks is in each column. Run the below code and look at the output of each, comparing it with what you know about the simulated dataset:


```r
summary(dat)
str(dat)        
```

Because the factor `language` is coded as 1 and 2, R has categorised this column as containing numeric information and unless we correct it, this will cause problems for visualisation and analysis. The code below shows how to recode numeric codes into labels. 

* `mutate()` makes new columns in a data table, or overwrites a column;
* `factor()` translates the language column into a factor with the labels "monolingual" and "bilingual"). You can also use the `factor()` function to set the display order of a column that contains words. Otherwise, they will display in alphabetical order.


```r
dat <- dat %>%
  mutate(language = factor(
    x = language, # column to translate
    levels = c(1, 2), # values of the original data in preferred order
    labels = c("monolingual", "bilingual") # labels for display
  ))
```

## Argument names

Each function has a list of arguments it can take, and a default order for those arguments. You can get more information on each function by entering `?function_name` into the console, although be aware that learning to read the help documentation in R is a skill in itself. When you are writing R code, as long as you stick to the default order, you do not have to explicitly call the argument names, for example, the above code could also be written as:


```r
dat <- dat %>%
  mutate(language = factor(language, 
                           c(1, 2), 
                           c("monolingual", "bilingual")))
```

One of the barriers to learning R is that many of the "helpful" examples and solutions you will find online do not include argument names and so for novice learners are completely opaque. In this tutorial, we will include the argument names the first time a function is used, however, we will remove some argument names from subsequent examples to facilitate knowledge transfer to the help available online.


## Demographic information

We can calculate and plot some basic descriptive information about the demographics of our sample using the imported dataset without any additional wrangling. The code below uses the `%>%` operator, otherwise known as the *pipe,* and can mostly useful be translated as "*and then"*. For example, the below code can be read as:

-   Start with the dataset `dat` *and then;*

-   Group it by the variable `language` *and then;*

-   Count the number of observations in each group


```r
dat %>%
  group_by(language) %>%
  count()
```


|  language   | n  |
|:-----------:|:--:|
| monolingual | 55 |
|  bilingual  | 45 |


`group_by()` does not result in surface level changes to the dataset, rather, it changes the underlying structure so that if groups are specified, whatever function is called next is peformed separately on each level of rhe grouping variable. The above code therefore counts the number of observations in each group of the variable `language`. If you just need the total number of observations, you could remove the `group_by()` line which would perform the operation on the whole dataset, rather than by groups:


```r
dat %>%
  count()
```


|  n  |
|:---:|
| 100 |

Similarly, we may wish to calculate the mean age (and SD) of the sample and we can do so using the function `summarise()` from the `dplyr` tidyverse package.


```r
dat %>%
  summarise(mean_age = mean(age),
            sd_age = sd(age))
```


| mean_age | sd_age |
|:--------:|:------:|
|  29.87   |   8    |

This code produces summary data in the form of a column named `mean_age` that contains the result of calculating the mean of the variable `age.` It then creates `sd_age` which does the same but for standard deviation. Note that the above code will not save the result of this operation, it will simply output the result in the console. If you wish to save it for future use, you can store it in an object by using the `<-` notation and print it later by typing the object name.


```r
age_stats <- dat %>%
  summarise(mean_age = mean(age),
            sd_age = sd(age))
```

Finally, the `group_by()` function will work in the same way when calculating summary statistics - the output of the function that is called after `group_by()` will be produced for each level of the grouping variable.


```r
dat %>%
  group_by(language) %>%
  summarise(mean_age = mean(age),
            sd_age = sd(age))
```


|  language   | mean_age | sd_age |
|:-----------:|:--------:|:------:|
| monolingual |  31.18   |  7.30  |
|  bilingual  |  28.27   |  8.58  |

## Bar chart of counts

For our first plot, we will make a simple bar chart of counts that shows the number of participants in each `language` group.


```r
ggplot(data = dat, mapping = aes(x = language)) +
  geom_bar()
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/bar1-1.png" alt="Bar chart of counts." width="100%" />
<p class="caption">(\#fig:bar1)Bar chart of counts.</p>
</div>

The first line of code sets up the first layer and base of the plot.

-   `data` specifies which data source to use for the plot

-   `mapping` specifies which variables to map to which aesthetics (`aes`) of the plot. Aesthetic mappings describe how variables in the data are mapped to visual properties (aesthetics) of geoms.

-   `x` specifies which variable to put on the x-axis

The second line of code draws the plot, and is connected to the base code with `+`. In this case, we ask for `geom_bar()`. Each `geom`, or type of plot, has an associated default statistic. For bar charts, the default statistic is to count the data passed to it. This means that you do not have to specify a `y` variable when making a bar plot of counts, when given an `x` variable, `geom_bar()` will automatically calculate counts of the groups in that variable. In this example, it counts the number of data points that are in each category of the `language` variable.

If your data already have the counts that you want to plot, you can set `stat="identity"` inside of `geom_bar()` to use that number instead of counting rows. For example, there is no way to plot percentages rather than counts within `ggplot`, you need to calculate these and store them in an object which is then used as the dataset. 

Notice that we are now omitting the names of the arguments `data` and `mapping` in the `ggplot()` function.


```r
count_dat <- dat %>%
  group_by(language) %>%
  count() %>%
  ungroup() %>%
  mutate(percent = (n/sum(n)*100))

ggplot(count_dat, aes(x = language, y = percent)) +
  geom_bar(stat="identity") 
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/bar-precalc-1.png" alt="Bar chart of pre-calculated counts." width="100%" />
<p class="caption">(\#fig:bar-precalc)Bar chart of pre-calculated counts.</p>
</div>


## Histogram

The code to plot a histogram `age` is very similar to the bar chart. We start by setting up the plot space, the dataset we want to use, and mapping the variables to the relevant axis. In this case, we want to plot a histogram with `age` on the x-axis:


```r
ggplot(dat, aes(x = age)) +
  geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/histogram1-1.png" alt="Histogram of ages." width="100%" />
<p class="caption">(\#fig:histogram1)Histogram of ages.</p>
</div>

By default `geom_histogram()` divides the x-axis into "bins" and counts how many observations are in each bin and so the y-axis does not need to be specified - it is automatically a count. When you run the code to produce the histogram, you will get the message `stat_bin() using bins = 30. Pick better value with binwidth`. This means that the default number of bins `geom_histogram()` divides the x-axis into is 30, but we may wish to pick a more appropriate value for our dataset. If we want one bar to equal one year, we can adjust `binwidth = 1`.


```r
ggplot(dat, aes(x = age)) +
  geom_histogram(binwidth = 1)
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/histogram2-1.png" alt="Histogram of ages where each bin covers one year." width="100%" />
<p class="caption">(\#fig:histogram2)Histogram of ages where each bin covers one year.</p>
</div>

## Customisation 1

So far we have made basic plots with the default visual appearance, before we move on to the experimental data we will introduce some simple visual customisation options.

### Editing axis names and labels

To edit axis names and labels we can use `scale_` functions. There are a number of different scale functions and which one you use depends on which aesthetic you wish to edit (e.g., x, y, fill, color) and the type of data it represents (discrete, continuous).

For the bar chart of counts, the x-axis is mapped to a discrete (categorical) variable whilst the y-axis is continuous. Each axis has its own function, and its own layer:


```r
ggplot(dat, aes(language)) +
  geom_bar() +
  scale_x_discrete(name = "Language group", 
                   labels = c("Monolingual", "Bilingual")) +
  scale_y_continuous(name = "Number of participants",
                     breaks = c(0,10,20,30,40,50))
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/bar3-1.png" alt="Bar chart with custom axis labels." width="100%" />
<p class="caption">(\#fig:bar3)Bar chart with custom axis labels.</p>
</div>

-   `name` controls the overall name of the axis

-   `labels` controls the names of the conditions with a discrete variable.

-   `c()` is a function that you will see in many different contexts and is used to combine multiple values. In this case, the labels we want to apply are combined within `c()` by enclosing each word within their own parenthesis, and are in the order displayed on the plot.

-   `breaks` controls the tick marks on the axis. Again because there are multiple values, they are enclosed within `c()` although because they are numeric and not text, they do not need quotation marks. 

### Changing colors

You can control colours used to display the bars by setting `fill` (internal colour)  and `colour` (outline colour) inside the geom function. This methods is only for changing **all** the bars; we will show you later how to set fill or color separately for different groups.


```r
ggplot(dat, aes(age)) +
  geom_histogram(binwidth = 1, fill = "white", colour = "black") +
  scale_x_continuous(name = "Participant age (years)")
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/histogram-fill-color-1.png" alt="Histogram with custom colors for bar fill and line colors." width="100%" />
<p class="caption">(\#fig:histogram-fill-color)Histogram with custom colors for bar fill and line colors.</p>
</div>

### Adding a theme

`ggplot` has a number of built-in visual themes that you can apply as an extra layer. The below code updates the x-axis label to the histogram, but also applies `theme_minimal()`. Each part of a theme can be independently customised, which may be necessary, for example, if you have journal guidelines on fonts for publication. There are further instructions for how to do this in the additional resources.


```r
ggplot(dat, aes(age)) +
  geom_histogram(binwidth = 1, fill = "wheat", color = "black") +
  scale_x_continuous(name = "Participant age (years)") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="02-ch2_files/figure-html/histogram-theme-1.png" alt="Histogram with a custom theme." width="100%" />
<p class="caption">(\#fig:histogram-theme)Histogram with a custom theme.</p>
</div>

You can set the theme globally so that all subsequent plots use a theme.


```r
theme_set(theme_minimal())
```

If you wished to return to the default theme, change the above to specify `theme_grey()`.

## Activities 1

Before you move on try the following:

-   Add a layer that edits the **name** of the y-axis histogram label to `Number of participants`.


<div class='solution'><button>Solution</button>


```r
ggplot(dat, aes(age)) +
  geom_histogram(binwidth = 1, fill = "wheat", color = "black") +
  scale_x_continuous(name = "Participant age (years)") +
  theme_minimal() +
  scale_y_continuous(name = "Number of participants")
```

</div>


-   Change the colour of the bars in the bar chart to red.


<div class='solution'><button>Solution</button>


```r
ggplot(data = dat, mapping = aes(x = language)) +
  geom_bar(fill = "red")
```

</div>


-   Remove `theme_minimal()` from the histogram and instead apply one of the other available themes (start typing `theme_` and the auto-complete will show you the available options).


<div class='solution'><button>Solution</button>


```r
#multiple options here e.g., theme_classic()
ggplot(dat, aes(age)) +
  geom_histogram(binwidth = 1, fill = "wheat", color = "black") +
  scale_x_continuous(name = "Participant age (years)") +
  theme_classic()

# theme_bw()
ggplot(dat, aes(age)) +
  geom_histogram(binwidth = 1, fill = "wheat", color = "black") +
  scale_x_continuous(name = "Participant age (years)") +
  theme_bw()
```

</div>



<!--chapter:end:02-ch2.Rmd-->




# Chapter 3

## Data formats

To visualise the experimental reaction time and accuracy data using `ggplot` we first need to perform some data wrangling, and it is this step that can cause friction with novice users of R. Traditionally, wide-format data is the preferred or default format. Wide-format data typically has one row of data for each participant with separate columns for each score or variable. Where there are repeated-measures variables, the dependent variable is split across different columns with one measurement for each condition.

The simulated Stroop data is currently in wide-format (see Table\ \@ref(tab:wide-data)) where each participant's aggregated [^3] reaction time and accuracy for each level of the within-subject variable is split across multiple columns.

[^3]: In this tutorial we have chosen to gloss over the data wrangling that must occur to get from the raw data to these aggregated values. This type of wrangling requires a more extensive tutorial than this paper can provide but, more importantly, it is still possible to use R for data visualisation having done these preparatory steps using existing workflows that newcomers to R are comfortable with. The aim of this paper is to bypass these initial, often problematic steps and focus on tangible outputs that may then encourage further mastery of reproducible methods.


Table: (\#tab:wide-data)Data in wide format.

|id   | age|language    | rt_cong| rt_incon| acc_cong| acc_incon|
|:----|---:|:-----------|-------:|--------:|--------:|---------:|
|S001 |  25|monolingual |  369.46|   666.82|       99|        90|
|S002 |  37|monolingual |  302.45|   585.04|       94|        82|
|S003 |  26|monolingual |  394.94|   608.50|       96|        87|
|S004 |  32|monolingual |  288.37|   485.89|       92|        76|
|S005 |  28|monolingual |  306.42|   551.32|       91|        83|
|S006 |  34|monolingual |  347.17|   517.34|       96|        78|

This format is popular because it is intuitive to read and easy to enter data into as all the data for one participant is contained within a single row. However, for the purposes of analysis, and particularly for analysis using R, this format is unsuitable because whilst it is intuitive to read by a human, the same is not true for a computer . Wide-format data combines multiple variables in a single column, for example in Table\ \@ref(tab:wide-data), `rt_cong` contains information related to both a DV and the level of an IV. Wickham [-@wickham2014tidy] provides a comprehensive overview of the benefits of tidy data as a standard way of mapping a dataset to its structure, but for the purposes of this tutorial there are two important rules: each column should be a *variable* and each row should be an *observation.*

Moving from using wide-form to long-form datasets can require a conceptual shift on the part of the researcher and one that usually only comes with practice and repeated exposure[^4]. For our example dataset, adhering to these rules would produce Table\ \@ref(tab:long). Rather than different observations of the same dependent variable being split across columns, there is now a single column for the DV reaction time, and a single column for the DV accuracy. Each participant now has multiple rows of data, one for each observation (i.e., for each participant there will be as many rows as there are levels of the within-subject IV). Although there is some repetition of age and language group, each row is unique when looking at the combination of measures.

[^4]: That is to say, if you are new to R, know that many before you have struggled with this conceptual shift - it does get better, it just takes time and your preferred choice of cursing.




Table: (\#tab:long)Data in the correct format for visualization.

|id   | age|language    |condition |     rt| acc|
|:----|---:|:-----------|:---------|------:|---:|
|S001 |  25|monolingual |cong      | 369.46|  99|
|S001 |  25|monolingual |incon     | 666.82|  90|
|S002 |  37|monolingual |cong      | 302.45|  94|
|S002 |  37|monolingual |incon     | 585.04|  82|
|S003 |  26|monolingual |cong      | 394.94|  96|
|S003 |  26|monolingual |incon     | 608.50|  87|

The benefits and flexibility of this format will hopefully become apparent as we progress through the tutorial, however, a useful rule of thumb when working with data in R for visualisation is that *anything that shares an axis should probably be in the same column*. For example, a simple bar chart of means for the reaction time DV would display the variable `condition` on the x-axis with bars representing both the `cong` and `incon` data, therefore, these data should be in one column and not split.

## Transforming data

We have chosen a 2 x 2 design with two DVs as we anticipate that this is a design many researchers will be familiar with and may also have existing datasets with a similar structure. However, it is worth normalising that trial-and-error is part of the process of learning how to apply these functions to new datasets and structures. Data visualisation can be a useful way to scaffold learning these data transformations because they can provide a concrete visual check as to whether you have done what you intended to do with your data.

### Step 1: `pivot_longer()`

The first step is to use the function `pivot_longer()` to transform the data to long-form. The pivot functions can be easier to show than tell - you may find it a useful exercise to run the below code and compare the newly created object `long` (Table\ \@ref(tab:long-example)) with the original `dat` Table\ \@ref(tab:wide-data) before reading on.


```r
long <- pivot_longer(data = dat, 
                     cols = rt_cong:acc_incon, 
                     names_sep = "_", 
                     names_to = c("dv_type", "condition"),
                     values_to = "dv")
```


-   As with the other tidyverse functions, the first argument specifies the dataset to use as the base, in this case `dat`. This argument name is often dropped in examples.

-   `cols` specifies all the columns you want to transform. The easiest way to visualise this is to think about which columns would be the same in the new long-form dataset and which will change. If you refer back to Table\ \@ref(tab:long-example) and Table\ \@ref(tab:wide-data), you can see that `id`, `age`, and `language` all remain, it is the columns that contain the measurements of the DVs that change. The colon notation `first_column:last_column` is used to select all variables from the first column specified to the second.  In our code, `cols` specifies that the columns we want to transform are `rt_cong` to `acc_incon`.

-   `names_sep` specifies how to split up the variable name in cases where it has multiple components. This is when taking care to name your variables consistently and meaningfully pays off. Because the word to the left of the separator (`_`) is always the DV type and the word to the right is always the condition of the within-subject IV, it is easy to automatically split the columns.

-   `names_to` specifies the names of the new columns that will be created. There are two: one for the text to the left of the separator, and one for the text to the right of the separator.

-   Finally, `values_to` names the new column that will contain the measurements, in this case we'll call it `dv`. At this point you may find it helpful to go back and compare `dat` and `long` again to see how each argument matches up with the output of the table.


Table: (\#tab:long-example)Data in long format.

|id   | age|language    |dv_type |condition |     dv|
|:----|---:|:-----------|:-------|:---------|------:|
|S001 |  25|monolingual |rt      |cong      | 369.46|
|S001 |  25|monolingual |rt      |incon     | 666.82|
|S001 |  25|monolingual |acc     |cong      |  99.00|
|S001 |  25|monolingual |acc     |incon     |  90.00|
|S002 |  37|monolingual |rt      |cong      | 302.45|
|S002 |  37|monolingual |rt      |incon     | 585.04|

### Step 2: `pivot_wider()`

Because we have two DVs, we need to perform an additional step. In the current long-form dataset, the column `dv` contains both reaction time and accuracy measures and keeping in mind the rule of thumb that *anything that shares an axis should probably be in the same column,* this creates a problem because we cannot plot two different units of measurement on the same axis. To fix this we need to use the function `pivot_wider()`. Again, we would encourage you at this point to compare `long` and `dat_long` with the below code to try and map the connections before reading on.


```r
dat_long <- pivot_wider(long, 
                        names_from = "dv_type", 
                        values_from = "dv")
```


-   The first argument is again the dataset you wish to work from, in this case `long`. We have removed the argument name `data` in this example.

-   `names_from` acts somewhat like the reverse of `names_to` from `pivot_longer()`. It will take the values from the variable specified and use these as variable names, i.e., in this case, the values of `rt` and `acc` that are currently in the `dv_type` column, and turn these into the column names.

-   Finally, `values_from` specifies the values to fill the new columns with. In this case, the new columns `rt` and `acc` will be filled with the values that were in `dv`. Again, it can be helpful to compare each dataset with the code to see how it aligns.

This final long-form data should looks like Table\ \@ref(tab:long-example).

We have purposefully used a more complex dataset with two DVs for this tutorial. If you are working with a dataset with only one DV, note that only step 1 of this process would be necessary, potentially with the removal of the `names_sep` argument. Finally, be careful not to calculate demographic descriptive statistics from this long-form dataset. Because the process of transformation has introduced some repetition for these variables, the wide-form dataset where 1 row = 1 participant should be used for demographic information.

## Histogram 2

Now that we have the experimental data in the right form, we can begin to create some useful visualizations. First, to demonstrate how code recipes can be reused and adapted, we will create histograms of reaction time and accuracy. The below code uses the same template as before but changes the dataset (`dat_long`), the binwidths of the histograms, the `x` variable to display (`rt`/`acc`), and the name of the x-axis.


```r
ggplot(dat_long, aes(x = rt)) +
  geom_histogram(binwidth = 10, fill = "white", color = "black") +
  scale_x_continuous(name = "Reaction time (ms)")
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/histogram-rt-1.png" alt="Histogram of reaction times." width="100%" />
<p class="caption">(\#fig:histogram-rt)Histogram of reaction times.</p>
</div>


```r
ggplot(dat_long, aes(x = acc)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black") +
  scale_x_continuous(name = "Accuracy (0-100)")
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/histogram-acc-1.png" alt="Histogram of accuracy scores." width="100%" />
<p class="caption">(\#fig:histogram-acc)Histogram of accuracy scores.</p>
</div>

## Density plots

The layer system makes it easy to create new types of plots by adapting existing recipes. For example, rather than creating a histogram, we can create a smoothed density plot by calling `geom_density()` rather than `geom_histogram()`. The rest of the code remains identical.


```r
ggplot(dat_long, aes(x = rt)) +
  geom_density()+
  scale_x_continuous(name = "Reaction time (ms)")
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/density-rt-1.png" alt="Density plot of reaction time." width="100%" />
<p class="caption">(\#fig:density-rt)Density plot of reaction time.</p>
</div>

### Grouped density plots

Density plots are most useful for comparing the distributions of different groups of data. Because the dataset is now in long format, it makes it easier to map another variable to the plot because each variable is contained within a single column. 

* In addition to mapping `rt` to the x-axis, we specify the `fill` aesthetic to fill the visualisation of each level of the `condition` variable with different colours. 
* As with the x and y-axis scale functions, we can edit the names and labels of our fill aesthetic by adding on another `scale_*_*()` layer.
* Note that the `fill` here is set inside the `aes()` function, which tells ggplot to set the fill differently for each value in the `condition` column. You cannot specify which colour here (e.g., `fill="red"`), like you could when you set `fill` inside the `geom_*()` function before.


```r
ggplot(dat_long, aes(x = rt, fill = condition)) +
  geom_density()+
  scale_x_continuous(name = "Reaction time (ms)") +
  scale_fill_discrete(name = "Condition",
                      labels = c("Congruent", "Incongruent"))
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/density-grouped-1.png" alt="Density plot of reaction times grouped by condition." width="100%" />
<p class="caption">(\#fig:density-grouped)Density plot of reaction times grouped by condition.</p>
</div>

## Scatterplots

Scatterplots are created by calling `geom_point()` and require both an `x` and `y` variable to be specified in the mapping.


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/point-plot-1.png" alt="Point plot of reaction time versus age." width="100%" />
<p class="caption">(\#fig:point-plot)Point plot of reaction time versus age.</p>
</div>

A line of best fit can be added with an additional layer that calls the function `geom_smooth()`. The default is to draw a LOESS or curved regression line, however, a linear line of best fit can be specified using `method = "lm"`. By default, `geom_smooth()` will also draw a confidence envelope around the regression line, this can be removed by adding `se = FALSE` to `geom_point()`.


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm")
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/smooth-plot-1.png" alt="Line of best fit for reaction time versus age." width="100%" />
<p class="caption">(\#fig:smooth-plot)Line of best fit for reaction time versus age.</p>
</div>

### Grouped scatterplots

Similar to the density plot, the scatterplot can also be easily adjusted to display grouped data. For `geom_point()`, the grouping variable is mapped to `color` rather than `fill` and the relevant `scale_*_*()` function is added.


```r
ggplot(dat_long, aes(x = rt, y = age, color = condition)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_discrete(name = "Condition",
                      labels = c("Congruent", "Incongruent"))
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/scatter-grouped-1.png" alt="Grouped scatter plot of reaction time versus age by condition." width="100%" />
<p class="caption">(\#fig:scatter-grouped)Grouped scatter plot of reaction time versus age by condition.</p>
</div>

## Customisation  2

### Accessible color schemes

One of the drawbacks of using `ggplot` for visualisation is that the default colour scheme is not accessible (or visually appealing). The red and green default palette is difficult for colour-blind people to differentiate, and also does not display well in grey scale. You can specify exact custom colors for your plots, but one easy option is to use the `viridis` scale functions. These take the same arguments as their default sister functions for updating axis names and labels, but display plots in contrasting colors that can be read by color-blind people and that also print well in grey scale. The `viridis` scale functions provide a number of different options for the color -- try setting `option` to any letter from A - E to see the different sets.


```r
ggplot(dat_long, aes(x = rt, y = age, color = condition)) +
  geom_point() +
  geom_smooth(method = "lm") +
  # use "viridis_d" instead of "discrete" for better colors
  scale_color_viridis_d(name = "Condition",
                        labels = c("Congruent", "Incongruent"),
                        option = "E")
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure" style="text-align: center">
<img src="03-ch3_files/figure-html/viridis-1.png" alt="Use the viridis color scheme for accessibility." width="100%" />
<p class="caption">(\#fig:viridis)Use the viridis color scheme for accessibility.</p>
</div>

## Activities 2

Before you move on try the following:

-   Use `fill` to created grouped histograms that display the distributions for `rt` for each `language` group separately and also edit the fill axis labels. Try adding `position = "dodge"` to `geom_histogram()` to see what happens.


<div class='solution'><button>Solution</button>


```r
# fill and axis changes
ggplot(dat_long, aes(x = rt, fill = language)) +
  geom_histogram(binwidth = 10) +
  scale_x_continuous(name = "Reaction time (ms)") +
  scale_fill_discrete(name = "Group",
                      labels = c("Monolingual", "Bilingual"))
# add in dodge
ggplot(dat_long, aes(x = rt, fill = language)) +
  geom_histogram(binwidth = 10, position = "dodge") +
  scale_x_continuous(name = "Reaction time (ms)") +
  scale_fill_discrete(name = "Group",
                      labels = c("Monolingual", "Bilingual"))
```


</div>


-   Use `scale_*_*()` functions to edit the name of the x and y-axis on the scatterplot


<div class='solution'><button>Solution</button>


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_continuous(name = "Reaction time") +
  scale_y_continuous(name = "Age")
```


</div>


-   Use `se = FALSE` to remove the confidence envelope from the scatterplots


<div class='solution'><button>Solution</button>


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_continuous(name = "Reaction time") +
  scale_y_continuous(name = "Age")
```

-   Remove `method = "lm"` from `geom_smooth()` to produce a curved regression line.


<div class='solution'><button>Solution</button>


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous(name = "Reaction time") +
  scale_y_continuous(name = "Age")
```

-   Replace the default `scale_fill_*()` on the grouped density plot with the color-blind friendly version.


<div class='solution'><button>Solution</button>


```r
ggplot(dat_long, aes(x = rt, fill = condition)) +
  geom_density()+
  scale_x_continuous(name = "Reaction time (ms)") +
  scale_fill_viridis_d(option = "E",
                      name = "Condition",
                      labels = c("Congruent", "Incongruent"))
```


<!--chapter:end:03-ch3.Rmd-->



# Chapter 4

## Transforming data 2

Following the rule *anything that shares an axis should probably be in the same column* means that we will frequently need our data in long-form when using `ggplot2`, however, there are some cases when wide-form is necessary. For example, we may wish to visualise the relationship between reaction time in the congruent and incongurent conditions. The easiest way to achieve this in our case would simply be to use the original wide-form data as the input:


```r
ggplot(dat, aes(x = rt_cong, y = rt_incon, fill = language)) +
  geom_point() +
  geom_smooth(method = "lm")
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/unnamed-chunk-2-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)**CAPTION THIS FIGURE!!**</p>
</div>

However, there may also be cases when you do not have an original wide-form version and you can use the `pivot_wider()` function to transform from long to wide.


```r
dat_wide <- dat_long %>%
  pivot_wider(id_cols = "id",
              names_from = "condition", 
              values_from = c(rt,acc))
```


|  id  | rt_cong  | rt_incon | acc_cong | acc_incon |
|:----:|:--------:|:--------:|:--------:|:---------:|
| S001 | 369.4585 | 666.8176 |    99    |    90     |
| S002 | 302.4513 | 585.0404 |    94    |    82     |
| S003 | 394.9407 | 608.5022 |    96    |    87     |
| S004 | 288.3734 | 485.8933 |    92    |    76     |
| S005 | 306.4250 | 551.3214 |    91    |    83     |
| S006 | 347.1710 | 517.3355 |    96    |    78     |

## Boxplots

As with `geom_point()`, boxplots also require an x and y-variable to be specified. In this case, `x` must be a discrete, or categorical variable, whilst `y` must be continuous.


```r
ggplot(dat_long, aes(x = condition, y = acc)) +
  geom_boxplot()
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/boxplot1-1.png" alt="Basic boxplot." width="100%" />
<p class="caption">(\#fig:boxplot1)Basic boxplot.</p>
</div>

### Grouped boxplots

As with histograms and density plots, `fill` can be used to create grouped boxplots:


```r
ggplot(dat_long, aes(x = condition, y = acc, fill = language)) +
  geom_boxplot() +
  scale_fill_viridis_d(option = "D",
                       name = "Group",
                       labels = c("Bilingual", "Monolingual")) +
  theme_classic() +
  scale_x_discrete(name = "Condition",
                   labels = c("Congruent", "Incongruent")) +
  scale_y_continuous(name = "Accuracy")
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/boxplot2-1.png" alt="Grouped boxplots" width="100%" />
<p class="caption">(\#fig:boxplot2)Grouped boxplots</p>
</div>

## Violin plots

Violin plots display the distribution of a dataset and can be created by calling `geom_violin()`. They are so-called because the shape they make sometimes looks something like a violin. They are essentially a mirrored density plot on its side. Note that the below code is identical to the code used to draw the boxplots above, except for the call to `geom_violin()` rather than `geom_boxplot().`


```r
ggplot(dat_long, aes(x = condition, y = acc, fill = language)) +
  geom_violin() +
  scale_fill_viridis_d(option = "D",
                       name = "Group",
                       labels = c("Bilingual", "Monolingual")) +
  theme_classic() +
  scale_x_discrete(name = "Condition",
                   labels = c("Congruent", "Incongruent")) +
  scale_y_continuous(name = "Accuracy")
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/violin1-1.png" alt="Violin plot." width="100%" />
<p class="caption">(\#fig:violin1)Violin plot.</p>
</div>

## Bar chart of means

Commonly, rather than visualising distributions of raw data researchers will wish to visualise the mean using a bar chart with error bars. Although this is one of the most common data visualisations, it is somewhat unintuitive for novice learners of R to achieve in `ggplot`. We present this code here because it is a common visualisation, however, we would urge you to use a better visualisation that provides more transparency about the distribution of the raw data such as the violin-boxplots we will present in the next section.

Rather than calling a `geom_` function, we call `stat_summary()`.

-   `fun` specifies the summary function that gives us the y-value we want to plot, in this case, `mean`

-   `geom` specifies what shape or plot we want to use to display the summary. For the first layer we will specify `bar`.


```r
ggplot(dat_long, aes(x = condition, y = rt)) +
  stat_summary(fun = "mean", geom = "bar")
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/badbar1-1.png" alt="Bar plot of means." width="100%" />
<p class="caption">(\#fig:badbar1)Bar plot of means.</p>
</div>

To add the error bars, another layer is added with a second call to `stat_summary`. This time, the function represents the type of error bars we wish to draw, you can choose from `mean_se` for standard error, `mean_cl_normal` for confidence intervals, or `mean_sdl` for standard deviation. `width` controls the width of the error bars - try changing the value to see what happens.

-   Whilst `fun` returns a single value (y), `fun.data` returns the y-values we want to plot plus their minimum and maximum values, in this case, `mean_se`


```r
ggplot(dat_long, aes(x = condition, y = rt)) +
  stat_summary(fun = "mean", geom = "bar") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .2)
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/badbar2-1.png" alt="Bar plot of means with error bars representing SE." width="100%" />
<p class="caption">(\#fig:badbar2)Bar plot of means with error bars representing SE.</p>
</div>

## Violin-boxplot

The power of the layered system is further highlighted by the ability to combine different types of plots. For example, rather than using a bar chart with error bars, one can easily create a single plot that includes a violin plot, boxplot, and the mean with error bars. This plot requires just two extra lines of code to produce than the bar plot with error bars, yet the amount of information displayed is vastly superior.

-   `fatten = NULL` removes the median line from the boxplot, which can make it easier to see the mean and error bars. Including this argument will result in the warning message `Removed 1 rows containing missing values (geom_segment)` and is not a cause for concern. Removing this argument will reinstate the median line.


```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  # remove the median line with fatten = NULL
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1)
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox1-1.png" alt="Violin-boxplot with mean dot and standard error bars." width="100%" />
<p class="caption">(\#fig:viobox1)Violin-boxplot with mean dot and standard error bars.</p>
</div>

It is important to note that the order of the layers matters. For example, if we call `geom_boxplot()` followed by `geom_violin()`, we get the following mess:


```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_boxplot() +  
  geom_violin() +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1)
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox1b-1.png" alt="Plot with the geoms in the wrong order." width="100%" />
<p class="caption">(\#fig:viobox1b)Plot with the geoms in the wrong order.</p>
</div>

### Grouped violin-boxplots

As with previous plots, another variable can be mapped to `fill` for the violin-boxplot, however, simply adding `fill` to the mapping causes the different components of the plot to become misaligned because they have different default positions:


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1)
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox2-1.png" alt="Grouped violin-boxplots without repositioning." width="100%" />
<p class="caption">(\#fig:viobox2)Grouped violin-boxplots without repositioning.</p>
</div>

To rectify this we need to adjust the argument `position` for each of the misaligned layers. `position_dodge()` instructs R to move (dodge) the position of the plot component by the specified value - what value you need can sometimes take trial and error.


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL, position = position_dodge(.9)) +
  stat_summary(fun = "mean", geom = "point", 
               position = position_dodge(.9)) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1,
               position = position_dodge(.9))
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox3-1.png" alt="Grouped violin-boxplots with repositioning." width="100%" />
<p class="caption">(\#fig:viobox3)Grouped violin-boxplots with repositioning.</p>
</div>

## Customisation part 3

Combining multiple type of plots can present an issue with the colours, particularly when the viridis scheme is used - in the below example it is hard to make out the black lines of the boxplot and the mean/errorbars.


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL, position = position_dodge(.9)) +
  stat_summary(fun = "mean", geom = "point", 
               position = position_dodge(.9)) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1,
               position = position_dodge(.9)) +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox4-1.png" alt="A color scheme that makes lines difficult to see." width="100%" />
<p class="caption">(\#fig:viobox4)A color scheme that makes lines difficult to see.</p>
</div>

There are a number of solutions to this problem. First, we can change the colour of individual geoms by adding `colour = "colour"` to each relevant geom:


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = condition)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL, colour = "grey") +
  stat_summary(fun = "mean", geom = "point", colour = "grey") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1, colour = "grey") +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox5-1.png" alt="Manually changing the line colors." width="100%" />
<p class="caption">(\#fig:viobox5)Manually changing the line colors.</p>
</div>

We can also keep the original colours but adjust the transparency of each layer using `alpha`. Again, the exact values needed can take trial and error:


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = condition)) +
  geom_violin(alpha = .4) +
  geom_boxplot(width = .2, fatten = NULL, alpha = .5) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="04-ch4_files/figure-html/viobox6-1.png" alt="Using transparency on the fill color." width="100%" />
<p class="caption">(\#fig:viobox6)Using transparency on the fill color.</p>
</div>

## Activities 3

Before you go on, do the following:

-   Review all the code you have run so far. Try to identify the commonalities between each plot's code and the bits of the code you might change if you were using a different dataset.

-   Take a moment to recognise the complexity of the code you are now able to read.

-   For the violin-boxplot, for `geom = "point"`, try changing `fun` to `median`


<div class='solution'><button>Solution</button>



```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  # remove the median line with fatten = NULL
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "median", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1)
```


</div>


-   For the violin-boxplot, for `geom = "errorbar"`, try changing `fun.data` to `mean_cl_normal` (for 95% CI)


<div class='solution'><button>Solution</button>



```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  # remove the median line with fatten = NULL
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_cl_normal", geom = "errorbar", width = .1)
```


</div>


-   Go back to the grouped density plots and try changing the transparency with `alpha`.


<div class='solution'><button>Solution</button>



```r
ggplot(dat_long, aes(x = rt, fill = condition)) +
  geom_density(alpha = .4)+
  scale_x_continuous(name = "Reaction time (ms)") +
  scale_fill_discrete(name = "Condition",
                      labels = c("Congruent", "Incongruent"))
```


</div>


<!--chapter:end:04-ch4.Rmd-->



# Chapter 5

## Interaction plots

Interaction plots are commonly used to help display or interpret a factorial design. Just like with the bar chart of means, interaction plots represent data summaries and so they are built up with a series of calls to `stat_summary()`.

-   `shape` acts much like `fill` in previous plots, except that rather than producing different colour fills for each level of the IV, the data points are given different shapes.

-   `size` lets you change the size of lines and points. You usually don't want different groups to be different sizes, so this option is set inside the relevant `geom_*()` function, not inside the `aes()` function.

-   `scale_color_manual()` works much like `scale_color_discrete()` except that it lets you specify the colour values manually. You can specify RGB colour values or a list of predefined colour names - all available options can be found by running `colours()` in the console. Other manual scales are also available, for example, `scale_fill_manual`.


```r
ggplot(dat_long, aes(x = condition, y = rt, 
                     shape = language,
                     group = language,
                     color = language)) +
  stat_summary(fun = "mean", geom = "point", size = 3) +
  stat_summary(fun = "mean", geom = "line") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .2) +
  scale_color_manual(values = c("blue", "darkorange")) +
  theme_classic()
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/ixn-plot-1.png" alt="Interaction plot." width="100%" />
<p class="caption">(\#fig:ixn-plot)Interaction plot.</p>
</div>

## Combined interaction plots

A more complex interaction plot can be produced that takes advantage of the layers to visualise not only the  overall interaction, but the change across conditions for each participant.

This code is more complex than all prior code because it does not use a universal mapping of the plot aesthetics. In our code so far, the aesthetic mapping (`aes`) of the plot has been specified in the first line of code as all layers have used the same mapping, however, is is also possible for each layer to use a different mapping. 

* The first call to `ggplot()` sets up the default mappings of the plot that will be used unless otherwised specified - the  `x`, `y` and `group` variable.
* `geom_point()`  overrides the default mapping by setting its own `colour` to draw the data points from each language group in a different colour. `alpha` is set to a low value to aid readability.
* Similarly, `geom_line()` overrides the default grouping varibale so that a line is drawn to connect the individual data points for each *participant* (`group = id`) rather than each language group, and also sets the colours.
* Finally, the calls to `stat_summary()` remain largely as they were, with the exception of setting `colour = "black"` and `size = 2` so that the overall means and errorbars can be more easily distinguished from the individual data points. Because they do not specify an individual mapping, they use the defaults (e.g., the lines are connected by language group).


```r
ggplot(dat_long, aes(x = condition, y = rt, group = language, shape = language)) +
  geom_point(aes(colour = language),alpha = .2) +
  geom_line(aes(group = id, colour = language), alpha = .2) +
  stat_summary(fun = "mean", geom = "point", size = 2, colour = "black") +
  stat_summary(fun = "mean", geom = "line", colour = "black") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .2, colour = "black") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-2-1.png" alt="Interaction plot with by-participant data" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)Interaction plot with by-participant data</p>
</div>

## Facets

So far we have produced single plots that display all the desired variables in one, however, there are situations in which it may be useful to create separate plots for each level of a variable. The below code is an adaptation of the code used to produce the grouped scatterplot (see Figure X) in which it may be easier to see how the relationship changes when the data are not overlaid. 

* Rather than using `colour = condition` to produce different colours for each level of `condition`, this variable is instead passed to `facet_wrap()`.


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~condition) +
  scale_color_discrete(name = "Condition",
                      labels = c("Congruent", "Incongruent"))
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-3-1.png" alt="Faceted scatterplot" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-3)Faceted scatterplot</p>
</div>

As another example, we can use `facet_wrap()` as an alternative to the grouped violin-boxplot (see Figure X) in which the variable `language` is passed to `facet_wrap()` rather than `fill`. 


```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  facet_wrap(~language) +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-4-1.png" alt="Facted violin-boxplot" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-4)Facted violin-boxplot</p>
</div>

Finally, note that editing the labels for faceted variables uses a different, and quite frankly altogether opaque and confusing, syntax calling on the `labeller` function.


```r
ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  facet_wrap(~language, 
             labeller = labeller(
               language = (c(monolingual = "Monolingual participants",
                             bilingual = "Bilingual participants")))) +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-5-1.png" alt="Faceted violin-boxplot with updated labels" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-5)Faceted violin-boxplot with updated labels</p>
</div>

## Saving plots

Just like with datasets, plots can be saved to objects. The below code saves the histograms we produced for reaction time and accuracy to objects named `p1` and `p2`. These plots can then be viewed by calling the object name in the console.


```r
p1 <- ggplot(dat_long, aes(x = rt)) +
  geom_histogram(binwidth = 10, color = "black")

p2 <- ggplot(dat_long, aes(x = acc)) +
  geom_histogram(binwidth = 1, color = "black") 
```

Importantly, layers can then be added to these saved objects. For example, the below code adds a theme to the plot saved in `p1` and saves it as a new object `p3`. This is important because many of the examples of `ggplot` code you will find in online help forums use the `p +` format to build up plots but fail to explain what this means, which can be confusing to beginners.


```r
p3 <- p1 + theme_minimal()
```

## Exporting plots 

In addition to saving plots to objects for further use in R, the function `ggsave()` can be used to save plots to your hard drive. The only required argument for `ggsave` is the file name of the image file you will create, complete with file extension (this can be "eps", "ps", "tex", "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf"). By default, `ggsave()` will save the last plot displayed, however, you can also specify a specific plot object.


```r
ggsave(filename = "my_plot.png") # save last displayed plot
ggsave(filename = "my_plot.png", plot = p3) # save plot p3
```

The width, height and resolution of the image can all be manually adjusted and the help documentation for is useful here (`?ggsave`).

## Multiple plots

As well as creating separate plots for each level of a variable using `facet_wrap()`, you may also wish to display multiple different plots together and the `patchwork` package provides an intuitive way to do this. `patchwork` does not require the use of any functions once it is loaded with `library()`, you simply need to save the plots you wish to combine to objects as above as use the operators `+`, `/` `()` and `|`.

### Combining two plots

Two plots can be combined side-by-side or stacked on top of each other. These combined plots could also be saved to an object and then passed to `ggsave`.


```r
p1 + p2 # side-by-side
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-9-1.png" alt="Side-by-side plots with patchwork" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-9)Side-by-side plots with patchwork</p>
</div>


```r
p1 / p2 # stacked
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-10-1.png" alt="Stacked plots with patchwork" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-10)Stacked plots with patchwork</p>
</div>


### Combining three or more plots

Three or more plots can be combined in a number of ways and the `patchwork` syntax is relatively easy to grasp with a few examples and a bit of trial and error. First, we save the complex interaction plot and faceted violin-boxplot to objects named `p5` and `p6`.


```r
p5 <- ggplot(dat_long, aes(x = condition, y = rt, group = language, shape = language)) +
  geom_point(aes(colour = language),alpha = .2) +
  geom_line(aes(group = id, colour = language), alpha = .2) +
  stat_summary(fun = "mean", geom = "point", size = 2, colour = "black") +
  stat_summary(fun = "mean", geom = "line", colour = "black") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .2, colour = "black") +
  theme_minimal()

p6 <- ggplot(dat_long, aes(x = condition, y= rt)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  facet_wrap(~language, 
             labeller = labeller(language = (c(monolingual = "Monolingual participants", bilingual = "Bilingual participants")))) +
  theme_minimal()
```

The exact layout of your plots will depend upon a number of factors. Try running the below examples and adjust the use of the operators to see how they change the layout.


```r
p1 /p5 / p6 
(p1 + p6) / p5 
p6 | p1 / p5 
```

## Customisation part 4

### Axis labels

Previously when we  edited the main axis labels we used the `scale_` functions to do so. These functions are useful to know because they allow you to customise each aspect of the scale, for example, the breaks and limits. However, if you only need to change the main axis `name`, there is a quicker way to do so using `labs()`. The below code edits the axis labels for the histogram saved in `p1`. The title and subtitle do not conform to APA standards (more on APA formatting in the additional resources), however, for presentations and social media they can be useful.


```r
p5 + labs(x = "Congruency of stimuli",
          y = "Reaction time (ms)",
          title = "Language group by congruency interaction plot",
          subtitle = "Reaction time data shows evidence of bilingual advantage")
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/Plot with edited labels and title-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:Plot with edited labels and title)**CAPTION THIS FIGURE!!**</p>
</div>

You can also use `labs()` to remove axis labels, for example, try adjusting the above code to `x = NULL`.

### Non-meaningful colours

So far when we have produced plots with colours, the colours were meaningful in that they represented different levels of a variable, but it is also possible to include colour for purely aesthetic reasons.

The below code adds `fill = language` to the faceted violin-boxplots, in addition to adjusting `alpha` and using the viridis colour palette.


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin(alpha = .4) +
  geom_boxplot(width = .2, fatten = NULL, alpha = .6) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  facet_wrap(~language, 
             labeller = labeller(language = (c(monolingual = "Monolingual participants", bilingual = "Bilingual participants")))) +
  theme_minimal() +
  scale_fill_viridis_d(option = "E")
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-13-1.png" alt="Violin-boxplot with redundant legend" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-13)Violin-boxplot with redundant legend</p>
</div>

Specifying a `fill` variable means that by default, R has produced a legend for that variable. However, given that the use of colour is not meaningful, this is a waste of plot space (it provides no more information than what is represented already by the x-axis). You can remove this legend with the `guides` function.


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin(alpha = .4) +
  geom_boxplot(width = .2, fatten = NULL, alpha = .6) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  facet_wrap(~language, 
             labeller = labeller(language = (c(monolingual = "Monolingual participants", bilingual = "Bilingual participants")))) +
  theme_minimal() +
  scale_fill_viridis_d(option = "E") +
  guides(fill = FALSE)
```

<div class="figure" style="text-align: center">
<img src="05-ch5_files/figure-html/unnamed-chunk-14-1.png" alt="Plot with suppressed redundant legend" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-14)Plot with suppressed redundant legend</p>
</div>




<!--chapter:end:05-ch5.Rmd-->

# Chapter 6


ridge
Alluvial
raincloud
split-violin

<!--chapter:end:06-ch6.Rmd-->

# (APPENDIX) Appendices {.unnumbered}

# Additional resources





There are a number of incredible resources online that, using the basis we have shown in this paper, will allow you to start adapting your figures and plots to the look you want, making them as informative as possible for your reader. We will list a few of those resoures below, but first we will show you a couple of additional tricks that are often used to help add information to your figure, as well as a couple of additional plot types.

## Adding lines to plots

**Vertical Lines - geom_vline()**

Often it can be useful to put a marker into our plots to highlight a certain criterion value. For example, if you were working with a scale that has a cut-off, perhaps the Austim Spectrum Quotient 10 (<!-- Ref -->), then you might want to put a line at a score of 7; the point at which the researchers suggest the participant is referred further. Alternatively, thinking about the Stroop test we have looked at in this paper, perhaps you had a level of accuracy that you wanted to make sure was reached - let's say 80%. If we refer back to Figure \@ref(fig:histogram-acc), which used the code below:


```r
ggplot(dat_long, aes(x = acc)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black") +
  scale_x_continuous(name = "Accuracy (0-100)")
```

and displayed the spread of the accuracy scores as such:

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/histogram-acc-vline1-1.png" alt="Histogram of accuracy scores." width="100%" />
<p class="caption">(\#fig:histogram-acc-vline1)Histogram of accuracy scores.</p>
</div>

if we wanted to add a line at the 80% level then we could use the `geom_vline()` function, again from the **`ggplot2`**, with the argument of `xintercept = 80`, meaning cut the x-axis at 80, as follows:


```r
ggplot(dat_long, aes(x = acc)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black") +
  scale_x_continuous(name = "Accuracy (0-100)") +
  geom_vline(xintercept = 80)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/histogram-acc-vline2-1.png" alt="Histogram of accuracy scores with black solid vertical line indicating 80% accuracy." width="100%" />
<p class="caption">(\#fig:histogram-acc-vline2)Histogram of accuracy scores with black solid vertical line indicating 80% accuracy.</p>
</div>

Now that looks ok but the line is a bit hard to see so we can change the style (`linetype = value`), color (`color = "color"`) and weight (`size = value`) as follows:


```r
ggplot(dat_long, aes(x = acc)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black") +
  scale_x_continuous(name = "Accuracy (0-100)") +
  geom_vline(xintercept = 80, linetype = 2, color = "red", size = 1.5)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/histogram-acc-vline3-1.png" alt="Histogram of accuracy scores with red dashed vertical line indicating 80% accuracy." width="100%" />
<p class="caption">(\#fig:histogram-acc-vline3)Histogram of accuracy scores with red dashed vertical line indicating 80% accuracy.</p>
</div>

**Horizontal Lines - geom_hline()**

Another situation may be that you want to put a horizontal line on your figure to mark a value of interest on the y-axis. Again thinking about our Stroop experiment, perhaps we wanted to indicate the 80% accuracy line on our boxplot figures. If we look at Figure \@ref(fig:boxplot1), which used this code to display the basic boxplot:


```r
ggplot(dat_long, aes(x = condition, y = acc)) +
  geom_boxplot()
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/boxplot1-add-1.png" alt="Basic boxplot." width="100%" />
<p class="caption">(\#fig:boxplot1-add)Basic boxplot.</p>
</div>

we could then use the `geom_hline()` function, from the **`ggplot2`**, with, this time, the argument of `yintercept = 80`, meaning cut the y-axis at 80, as follows:


```r
ggplot(dat_long, aes(x = condition, y = acc)) +
  geom_boxplot() +
  geom_hline(yintercept = 80)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/boxplot1-hline1-1.png" alt="Basic boxplot with black solid horizontal line indicating 80% accuracy." width="100%" />
<p class="caption">(\#fig:boxplot1-hline1)Basic boxplot with black solid horizontal line indicating 80% accuracy.</p>
</div>

and again we can embellish the line using the same arguements as above. We will put in some different values here just to show the changes:


```r
ggplot(dat_long, aes(x = condition, y = acc)) +
  geom_boxplot() +
  geom_hline(yintercept = 80, linetype = 3, color = "blue", size = 2)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/boxplot1-hline2-1.png" alt="Basic boxplot with blue dotted horizontal line indicating 80% accuracy." width="100%" />
<p class="caption">(\#fig:boxplot1-hline2)Basic boxplot with blue dotted horizontal line indicating 80% accuracy.</p>
</div>

**LineTypes**

One thing worth noting is that the `linetype` argument can actually be specified as both a value or as a word. They match up as follows:

|    Value     |         Word          |
|:------------:|:---------------------:|
| linetype = 0 |  linetype = "blank"   |
| linetype = 1 |  linetype = "solid"   |
| linetype = 2 |  linetype = "dashed"  |
| linetype = 3 |  linetype = "dotted"  |
| linetype = 4 | linetype = "dotdash"  |
| linetype = 5 | linetype = "longdash" |
| linetype = 6 | linetype = "twodash"  |

**Diagonal Lines - geom_abline()**

The last type of line you might want to overlay on a figure is perhaps a diagonal line. For example, perhaps you have created a scatterplot and you want to have the true diagonal line for reference to the line of best fit. To show this, we will refer back to Figure \@ref(fig:smooth-plot) which displayed the line of best fit for the reaction time versus age, and used the following code:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm")
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-add-1.png" alt="Line of best fit for reaction time versus age." width="100%" />
<p class="caption">(\#fig:smooth-plot-add)Line of best fit for reaction time versus age.</p>
</div>

By eye that would appear to be a fairly flat relationship but we will add the true diagonal to help clarify. To do this we use the `geom_abline()`, again from **`ggplot2`**, and we give it the arguements of the slope (`slope  = value`) and the intercept (`intercept = value`). We are also going to scale the data to turn it into z-scores to help us visualise the relationship better, as follows:


```r
dat_long_scale <- dat_long %>%
  mutate(rt_zscore = (rt - mean(rt))/sd(rt),
         age_zscore = (age - mean(age))/sd(age))

ggplot(dat_long_scale, aes(x = rt_zscore, y = age_zscore)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_abline(slope = 1, intercept = 0)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-abline1-1.png" alt="Line of best fit (blue line) for reaction time versus age with true diagonal shown (black line)." width="100%" />
<p class="caption">(\#fig:smooth-plot-abline1)Line of best fit (blue line) for reaction time versus age with true diagonal shown (black line).</p>
</div>

So now we can see the line of best fit (blue line) in relation to the true diagonal (black line). We will come back to why we z-scored the data in a minute, but first let's finish tidying up this figure, using some of the customisation we have seen as it is a bit messy. Something like this might look cleaner:


```r
ggplot(dat_long_scale, aes(x = rt_zscore, y = age_zscore)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black", size = .5) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", size = .5) +
  geom_vline(xintercept = 0, linetype = "solid", color = "black", size = .5) + 
  geom_point() +
    geom_smooth(method = "lm")
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-abline2-1.png" alt="Line of best fit (blue solid line) for reaction time versus age with true diagonal shown (black line dashed)." width="100%" />
<p class="caption">(\#fig:smooth-plot-abline2)Line of best fit (blue solid line) for reaction time versus age with true diagonal shown (black line dashed).</p>
</div>

That maybe looks a bit cluttered but it gives a nice example of how you can use the different geoms for adding lines to add information to your figure, clearly visualising the weak relationship between reaction time and age. **Note:** Do remember about the layering system however; you will notice that in the code for \@ref(fig:smooth-plot-abline2) we have changed the order of the code lines so that the geom lines are behind the points!

**Top Tip: Your intercepts must be values you can see**

Thinking back to why we z-scored the data for that last figure, we sort of skipped over that, but it did serve a purpose. Here is the original data and the original scatterplot but with the `geom_abline()` added to the code:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_abline(slope = 1, intercept = 0)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-abline3-1.png" alt="Line of best fit (blue solid line) for reaction time versus age with missing true diagonal." width="100%" />
<p class="caption">(\#fig:smooth-plot-abline3)Line of best fit (blue solid line) for reaction time versus age with missing true diagonal.</p>
</div>

The code runs but the diagonal line is nowhere to be seen. The reason is that you figure is zoomed in on the data and the diagonal is "out of shot" if you like. If we were to zoom out on the data we would then see the diagonal line as such:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_abline(slope = 1, intercept = 0) +
  coord_cartesian(xlim = c(0,1000), ylim = c(0,60))
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-abline4-1.png" alt="Zoomed out to show Line of best fit (blue solid line) for reaction time versus age with true diagonal (black line)." width="100%" />
<p class="caption">(\#fig:smooth-plot-abline4)Zoomed out to show Line of best fit (blue solid line) for reaction time versus age with true diagonal (black line).</p>
</div>

So the key point is that your intercepts have to be set to visible for values for you to see them! If you run your code and the line does not appear, check that the value you have set can actually be seen on your figure. This applies to `geom_abline()`, `geom_hline()` and `geom_vline()`.

## Zooming in and out

Like in the example above, it can be very beneficial to be able to zoom in and out of figures, mainly to focus the frame on a given section. One function we can use to do this is the `coord_cartesian()`, in **`ggplot2`**. The main arguments are the limits on the x-axis (`xlim = c(value, value)`), the limits on the y-axis (`ylim = c(value, value)`), and whether to add a small expansion to those limits or not (`expand = TRUE/FALSE`). Looking at the scatterplot of age and reaction time again, we could use `coord_cartesian()` to zoom fully out:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  coord_cartesian(xlim = c(0,1000), ylim = c(0,100), expand = FALSE)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-coord1-1.png" alt="Zoomed out on scatterplot with no expansion around set limits" width="100%" />
<p class="caption">(\#fig:smooth-plot-coord1)Zoomed out on scatterplot with no expansion around set limits</p>
</div>

And we can add a small expansion by changing the `expand` argument to `TRUE`:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  coord_cartesian(xlim = c(0,1000), ylim = c(0,100), expand = TRUE)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-coord2-1.png" alt="Zoomed out on scatterplot with small expansion around set limits" width="100%" />
<p class="caption">(\#fig:smooth-plot-coord2)Zoomed out on scatterplot with small expansion around set limits</p>
</div>

Or we can zoom right in on a specific area of the plot if there was something we wanted to highlight. Here for example we are just showing the reaction times between 500 and 725 msecs, and all ages between 15 and 55:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  coord_cartesian(xlim = c(500,725), ylim = c(15,55), expand = TRUE)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-coord3-1.png" alt="Zoomed in on scatterplot with small expansion around set limits" width="100%" />
<p class="caption">(\#fig:smooth-plot-coord3)Zoomed in on scatterplot with small expansion around set limits</p>
</div>

And you can zoom in and zoom out just the x-axis or just the y-axis; just depends on what you want to show.

## Setting the axis values

**Continuous scales**

You may have noticed that depending on the spread of your data, and how much of the figure you see, the values on the axes tend to change. Often we don't want this and want the values to be constant. We have already used functions to control this in the main body of the paper - the `scale_*` functions. Here we will use `scale_x_continuous()` and `scale_y_continuous()` to set the values on the axes to what we want. The main arguments in both functions are the limits (`limts = c(value, value)`) and the breaks (the tick marks essentially, `breaks = value:value`). Note that the limits are just two values (minimum and maximum), whereas the breaks are a series of values (from 0 to 100, for example). If we use the scatterplot of age and reaction time, then our code might look like this:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_continuous(limits = c(0,1000), breaks = 0:1000) +
  scale_y_continuous(limits = c(0,100), breaks = 0:100)
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-scales1-1.png" alt="Changing the values on the axes" width="100%" />
<p class="caption">(\#fig:smooth-plot-scales1)Changing the values on the axes</p>
</div>

That actually looks rubbish because we simply have too many values on our axes, so we can use the `seq()` function, from **`baseR`**, to get a bit more control. The arguments here are the first value (`from = value`), the last value (`last = value`), and the size of the steps (`by = value`). For example, `seq(0,10,2)` would give all values between 0 and 10 in steps of 2, (i.e. 0, 2, 4, 6, 8 and 10). So using that idea we can change the y-axis in steps of 5 (years) and the x-axis in steps of 50 (msecs) as follows:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0,1000,50)) +
  scale_y_continuous(limits = c(0,100), breaks = seq(0,100,5))
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-scales2-1.png" alt="Changing the values on the axes using the seq() function" width="100%" />
<p class="caption">(\#fig:smooth-plot-scales2)Changing the values on the axes using the seq() function</p>
</div>

Which gives us a much nicer and cleaner set of values on our axes. And if we combine that approach for setting the axes values with our zoom function (`coord_cartesian()`), then we can get something that looks like this:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0,1000,50)) +
  scale_y_continuous(limits = c(0,100), breaks = seq(0,100,5)) +
  coord_cartesian(xlim = c(250,750), ylim = c(15,55))
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-scales3-1.png" alt="Combining scale functions and zoom functions" width="100%" />
<p class="caption">(\#fig:smooth-plot-scales3)Combining scale functions and zoom functions</p>
</div>

Which actually looks much like our original scatterplot but with better definition on the axes. So you can see we can actually have a lot of control over the axes and what we see. One thing to note however is that you should not use the `limits` argument within the `scale_*` functions as a zoom. It won't work like that and instead will just disregard data. Look at this example:


```r
ggplot(dat_long, aes(x = rt, y = age)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_continuous(limits = c(500,600))
```

```
## Warning: Removed 165 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 165 rows containing missing values (geom_point).
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/smooth-plot-scales4-1.png" alt="Combining scale functions and zoom functions" width="100%" />
<p class="caption">(\#fig:smooth-plot-scales4)Combining scale functions and zoom functions</p>
</div>

It may look like it has zoomed in on the data but actually it has removed all data outwith the limits. That is what the warnings are telling you, and you can see that as there is no data above and below the limits, but we know there should be based on the earlier plots. So `scale_*` functions can change the values on the axes, but `coord_cartesian()` is for zooming in and out.

**Discrete scales**

The same idea of `limits` within a `scale_*` function can also be used to change the order of categories on a discrete scale. For example if we look at our boxplots again in Figure \@ref(fig:viobox6), we see this figure:


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = condition)) +
  geom_violin(alpha = .4) +
  geom_boxplot(width = .2, fatten = NULL, alpha = .5) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/viobox6-add-1.png" alt="Using transparency on the fill color." width="100%" />
<p class="caption">(\#fig:viobox6-add)Using transparency on the fill color.</p>
</div>

The figures always default to the alphabetical order. Sometimes that is what we want; sometimes that is not what we want. If we wanted to switch the order of **cong** and **incong** so that the incongruent condition comes first we would use the `scale_x_discrete()` function and set the limits within it (`limits = c("category","category")`) as follows:


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = condition)) +
  geom_violin(alpha = .4) +
  geom_boxplot(width = .2, fatten = NULL, alpha = .5) +
  stat_summary(fun = "mean", geom = "point") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1) +
  scale_fill_viridis_d(option = "E") +
  scale_x_discrete(limits = c("incon","cong")) + 
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/viobox6-scale1-1.png" alt="Switching orders of categorical variables" width="100%" />
<p class="caption">(\#fig:viobox6-scale1)Switching orders of categorical variables</p>
</div>

And that works just the same if you have more conditions, which you will see if you compare Figure \@ref(fig:viobox4) to the below figure where we have flipped the order of incongruent and congruent from the original default alphabetical order


```r
ggplot(dat_long, aes(x = condition, y= rt, fill = language)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL, position = position_dodge(.9)) +
  stat_summary(fun = "mean", geom = "point", 
               position = position_dodge(.9)) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1,
               position = position_dodge(.9)) +
  scale_fill_viridis_d(option = "E") +
  scale_x_discrete(limits = c("incon","cong")) + 
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/viobox4-scale1-1.png" alt="Same as earlier figure but with order of conditions on x-axis altered." width="100%" />
<p class="caption">(\#fig:viobox4-scale1)Same as earlier figure but with order of conditions on x-axis altered.</p>
</div>

**Changing Order of Factors**

Again, you have a lot of control beyond the default alphabetical order that **`ggplot2`** tends to plot in. One question you might have though is why **monolingual** and **bilingual** are not in alphabetical order? f they were then the **bilingual** condition would be plotted first. The answer is, thinking back to the start of the paper, we changed our conditions from **1** and **2** to the factor names of **monolingual** and **bilingual**, and **`ggplot`** maintains that factor order when plotting. So if we want to plot it in a different fashion we need to do a bit of factor reordering. This can be done much like earlier using the `factor()` function and stating the order of conditions we want (`levels = c("factor","factor")`). But be careful with spelling as it must match up to the names of the factors that already exist.

In this example, we will reorder the factors so that **bilingual** is presented first but leave the order of **congruent** and **incongruent** as the alphabetical default. Note in the code though that we are not permanently storing the factor change as we don't want to keep this new order. We are just changing the order "on the fly" for this one example before putting it into the plot.


```r
dat_long %>% 
  mutate(language = factor(language, 
                           levels = c("bilingual","monolingual"))) %>%
  ggplot(aes(x = condition, y= rt, fill = language)) +
  geom_violin() +
  geom_boxplot(width = .2, fatten = NULL, position = position_dodge(.9)) +
  stat_summary(fun = "mean", geom = "point", 
               position = position_dodge(.9)) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = .1,
               position = position_dodge(.9)) +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/viobox4-scale2-1.png" alt="Same as earlier figure but with order of conditions on x-axis altered." width="100%" />
<p class="caption">(\#fig:viobox4-scale2)Same as earlier figure but with order of conditions on x-axis altered.</p>
</div>

And if we compare this new figure to the original, side-by-side, we see the difference:

<div class="figure" style="text-align: center">
<img src="appendix-0_files/figure-html/viobox4-scale3-1.png" alt="Switching factor orders" width="100%" />
<p class="caption">(\#fig:viobox4-scale3)Switching factor orders</p>
</div>

## Lot more random stuff

## Setting A Lab Theme

## Additional Links

<!--chapter:end:appendix-0.Rmd-->

