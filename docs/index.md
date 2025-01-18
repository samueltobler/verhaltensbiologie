---
title: "Verhaltensbiologie 🐝"
site: bookdown::bookdown_site
github-repo: "samueltobler/verhaltensbiologie"
documentclass: book
link-citations: yes
description: |
  Dieses Buch behandelt die Grundkonzepte der Verhaltensbiologie 
  auf gymnasialer Ebene. 
---

# Einleitung

This is a *sample* book written in **Markdown**. You can use anything that Pandoc's Markdown supports; for example, a math equation $a^2 + b^2 = c^2$.

## Was ist ein Leitprogramm? 

Each **bookdown** chapter is an .Rmd file, and each .Rmd file can contain one (and only one) chapter. A chapter *must* start with a first-level heading: `# A good chapter`, and can contain one (and only one) first-level heading.


## Wie funktioniert ein Leitprogramm


Each **bookdown** chapter is an .Rmd file, and each .Rmd file can contain one (and only one) chapter. A chapter *must* start with a first-level heading: `# A good chapter`, and can contain one (and only one) first-level heading.

Use second-level and higher headings within chapters like: `## A short section` or `### An even shorter section`.

The `index.Rmd` file is required, and is also your first book chapter. It will be the homepage when you render the book.




``` r
par(mar = c(4, 4, .1, .1))
plot(pressure, type = 'b', pch = 19)
```

<div class="figure" style="text-align: center">
<img src="index_files/figure-html/nice-fig-1.png" alt="Plot with connected points showing that vapor pressure of mercury increases exponentially as temperature increases." width="80%" />
<p class="caption">(\#fig:nice-fig)Here is a nice figure!</p>
</div>