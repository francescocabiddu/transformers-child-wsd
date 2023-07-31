This folder contains the training and test data used in the simulations.

ChiSense-12_for_nlm = data taken from ChiSense-12 dataset (Cabiddu et al., 2022), which includes 9 target words.

ChiSense-12_for_nlm_extended = data which adds 4 new target words to ChiSense-12

senses_SpokenBNC_for_nlm = data from the spoken BNC

sense.tsv = mapping of word senses to target words. This file is a copy of "senses_SpokenBNC_for_nlm.tsv"; If you want to run simulation on, for example, ChiSense-12_for_nlm, please first delete "sense.tsv", then create a copy of "senses_ChiSense.tsv", and finally rename the copy "sense.tsv"

senses_ChiSense.tsv = mapping of word senses to target words in ChiSense-12_for_nlm

senses_ChiSense_extended.tsv = mapping of word senses to target words in ChiSense-12_for_nlm_extended

senses_SpokenBNC_for_nlm.tsv = mapping of word senses to target words in SpokenBNC_for_nlm