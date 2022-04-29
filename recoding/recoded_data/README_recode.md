<script
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
  type="text/javascript">
</script>

# Learning & Sleep

ACN5314 Neuro3
Dataset: pfc-6 from crcns.org


## Summary

Multisite neural recordings were taken in a rat undergoing learning of a behavioral contingency task.

A model will be trained on activation patterns by time bin during the learning session, with the target being correctness (i.e., did the animal follow the rule and get rewarded?).

Then, this model will be used to predict "correctness" of each bin based on neural recording data from slow-wave sleep (SWS) *before* (pre-SWS) and *after* (post-SWS) the learning session.

We hypothesize that our model will predict a larger proportion of post-SWS bins as "correct" than pre-SWS bins due to the role of neural ensemble rehearsal during sleep in memory consolidations.


## Files

6 files are included in recoded dataset:
1. 201222_beh_binned.csv
2. 201222_pre_sws_binned.csv
3. 201222_post_sws_binned.csv
4. 201222_beh_svd.csv
5. 201222_pre_svd.csv
6. 201222_post_svd.csv

___

### (1) 201222_beh_binned.csv ###

Includes neural data recorded during trials of the behavioral contingency task. Columns (1-31) are ID numbers for each recorded neuron. Rows indicate start time of each 100ms bin. For each bin, the number of times that each neuron spiked is recorded. Notice that this can be interpreted as a frequency (spikes/100ms bin).

Column "correct" (boolean) indicates whether the animal responded correctly in the trial of the behavioral contingency task from which this bin was taken.


### (2) and (3) 201222_(pre/post)_sws_binned.csv ###

Same format as 201222_beh_binned.csv, without "correct" column. Data taken from periods of SWS data before (pre) or after (post) behavior contigency task. See Peyrache et al. 2019 for characterization of SWS.


### (4) 201222_beh_svd.csv ###

For wake/behavior data $A_w$, we have SVD
$$ A_w = U_w \cdot S \cdot V^T $$

File contains first 6 rows of matrix $U_w$ .

*(5) and (6) 201222_(pre/post)_svd.csv*

We want to express sleep data $ A_s $ (either pre or post) in terms of an orthonormal basis of the row space, the columns of $ V^T $. These are our linearly independent ``activation patterns" of the 31 neurons. Thus, we take

$$ U_s = A_s \cdot (V^T)^{-1} \cdot S^{-1} $$

We then pick the first $n$ columns of $U_w$ and $U_s$. We train our model on some of the rows of $U_w$, then test on the remainder of $U_w$. Then, we apply the model to $U_{s-pre}$ and $U_{s-post}$ and compare predictive performance.

## References

Adrien Peyrache, Mehdi Khamassi, Karim Benchenane, Sidney I Wiener, Francesco Battaglia (2018); Activity of neurons in rat medial prefrontal cortex during learning and sleep. CRCNS.org http://dx.doi.org/10.6080/K0KH0KH5

"Replay of rule-learning related neural patterns in the prefrontal cortex during sleep." Adrien Peyrache, Mehdi Khamassi, Karim Benchenane, Sidney I Wiener, Francesco P Battaglia. *Nature Neuroscience* 12(7):919-26 (July 2009) doi: 10.1038/nn.2337