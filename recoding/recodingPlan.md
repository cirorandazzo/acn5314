# New Recoding Plan
CR created 2022.04.03

- Separate out epochs of interest:
	- Pre-SWS
	- Correct Trials
	- Post-SWS

- Merge epochs? Or do next step, then average?
	- yes, merge

- For each epoch:
	- Bin into 100ms (cut time off beginning so all epochs are full length)
		- cell number & time cell fires
		- **how to vectorize?**
	- Count spikes/bin for each cell.
	- Make bin matrix (B) : 31 neurons * # bins. each row is b(n), bin vector for neuron n
	- normalize
	- C = B * B^T: element c(x,y) = b(x) dot b(y); measure of pairwise correlation
		- C is symmetric

  - Train 4 models:
	  - (1): pre-SWS
	  - (2): wake/behavior
	  - (3): post-SWS
	  - 4): non-behavior/non-sleep
	  - Each will have the following features:
		  - **session rule** R/L/light/dark (1 hot coded); check order
		  - **light-based rule?** T if rule=light/dark, false if rule=L/R (direction-based)
		  - **cell types** by neuron
		  - pairwise correlations by neuron?
			  - this is a lot of features, 31 choose 2 = 465
		  - rat ID 1hc?
	  - Compare predictive performance of a "learned" session.
		  - Hypothesis: wake > post > pre > random
	  - Split sessions with 2 rules (where animal "learned") into 2 sessions?


# Notes; meeting with Dr. Golden, 2022.04.04

## Similarity matrix: don't do.
- B * B^T --> similarity matrix; for pre, wake, post
	- column vectors of pre/post matrices * S. take magnitude of result. if big, highly correlated to wake.
	- similarity matrix is hebbian learning; each column is a new training iteration.
	- descriptive model: do all this stuff
	- vs. process model: how might this be implemented in the brain?
	- before computing B, compute the mean vector = average of columns of B
use all "wake"; use some random subset of "pre-wake"/"post wake"

# Another approach: do this
- Use only one session in which the animal learned the rule
- Bin all behavior trials (Δt = 100ms). These become rows in our feature matrix.
	- If animal did *correct* behavior during the trial from which this bin came, target = 1
	- If animal did *incorrect* behavior, target = 0.
- Train/test split (?)
- Then, we test with bins from pre- and post-sleep.
- T-test, pre vs. post -> we would expect this model is more accurate in predicting activity patterns from post-sleep, since the animal will rehearse those neural ensembles.

## CR additional thoughts:
- since we're only using data from 1 animal, cell type doesn't matter; cell ID is constant, so it's implicitly part of the data
	- same with some of the other features we've talked about (rule ID, etc)