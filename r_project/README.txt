Francesco Cabiddu, Cardiff University, CabidduF@cardiff.ac.uk

This R project enables the preparation of training and test stimuli for Transformers. It also facilitates the reproduction of all results presented in the main manuscript and appendix, once the training and test stimuli have been processed by the Transformer models using the provided Python scripts.

To prepare the training and test files, follow the order of the .R files (0_additional_senses.R, 1_prep_prototypes.R, etc.)

After executing all .R files, use the Python scripts to construct sense prototypes and operate the Transformers on the test stimuli.

Upon generating the results, all the .Rmd files can be used to reproduce the results found in the paper and appendix.

Included in the project are several .RData files containing workspace objects. These enable the printing of the paper and appendix results without the necessity of running the full project.