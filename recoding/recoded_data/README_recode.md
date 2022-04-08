# Learning & Sleep

ACN5314 Neuro3
Dataset: pfc-6 from crcns.org


## Summary

Multisite neural recordings were taken in a rat undergoing learning of a behavioral contingency task.

A model will be trained on activation patterns by time bin during the learning session, with the target being correctness (i.e., did the animal follow the rule and get rewarded?).

Then, this model will be used to predict "correctness" of each bin based on neural recording data from slow-wave sleep (SWS) *before* (pre-SWS) and *after* (post-SWS) the learning session.

We hypothesize that our model will predict a larger proportion of post-SWS bins as "correct" than pre-SWS bins due to the role of neural ensemble rehearsal during sleep in memory consolidations.


## Files

3 files are included in recoded dataset:
1. 201222_beh_binned.csv
2. 201222_pre_sws_binned.csv
3. 201222_post_sws_binned.csv


___

*(1) 201222_beh_binned.csv*

    Includes neural data recorded during trials of the behavioral contingency task. Columns (1-31) are ID numbers for each recorded neuron. Rows indicate start time of each 100ms bin. For each bin, the number of times that each neuron spiked is recorded. Notice that this can be interpreted as a frequency (spikes/100ms bin).

    Column "correct" (boolean) indicates whether the animal responded correctly in the trial of the behavioral contingency task from which this bin was taken.


*(2) 201222_pre_sws_binned.csv*

    Same format as 201222_beh_binned.csv, without "correct" column. Data taken from periods of SWS data before behavior contigency task. See Peyrache et al. 2019 for characterization of SWS.


*(3) 201222_post_sws_binned.csv*

    Same format as 201222_beh_binned.csv, without "correct" column. Data taken from periods of SWS data after behavior contigency task. See Peyrache et al. 2019 for characterization of SWS.
    

## References

Adrien Peyrache, Mehdi Khamassi, Karim Benchenane, Sidney I Wiener, Francesco Battaglia (2018); Activity of neurons in rat medial prefrontal cortex during learning and sleep. CRCNS.org http://dx.doi.org/10.6080/K0KH0KH5

"Replay of rule-learning related neural patterns in the prefrontal cortex during sleep." Adrien Peyrache, Mehdi Khamassi, Karim Benchenane, Sidney I Wiener, Francesco P Battaglia. *Nature Neuroscience* 12(7):919-26 (July 2009) doi: 10.1038/nn.2337