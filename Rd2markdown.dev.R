setwd('~/Dropbox/Projects')

require(devtools)

document('Rd2markdown')
check_doc('Rd2markdown')
install('Rd2markdown')
check('Rd2markdown')
build('Rd2markdown', binary=FALSE)
build('Rd2markdown', binary=TRUE)


#### Test
require(Rd2markdown)
front.matter <- '---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---'
require(multilevelPSA)
Rd2markdown('multilevelPSA', 
			outdir='~/Dropbox/Projects/jbryer.github.com/multilevelPSA/docs',
			front.matter=front.matter)

#### Initial setup
package.skeleton(name='Rd2markdown', path='~/Dropbox/Projects', force=TRUE,
				 code_files='~/Dropbox/Projects/Rd2markdown.R')
