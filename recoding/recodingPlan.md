# New Recoding Plan
CR created 2022.04.03

*==ask about highlighted stuff==*

- Separate out epochs of interest:
	- Pre-SWS
	- Correct Trials
	- Post-SWS

- *==Merge epochs==*? Or do next step, then average?

- For each epoch:
	- Bin into 100ms (*==cut time off beginning so all epochs are full length==*?)
	- Count spikes/bin for each cell.
	- Make bin matrix (B) : 31 neurons * # bins. each row is b(n), bin vector for neuron n
	- *==normalize?==*
	- C = B * B^T: element c(x,y) = b(x) dot b(y)
		- C is symmetric
		- *==Can we consider this to be pairwise correlation?==*

  - Train 4 models:
	  - (1): pre-SWS
	  - (2): wake/behavior
	  - (3): post-SWS
	  - *==(4): non-behavior/non-sleep==*
	  - Each will have the following features:
		  - **session rule** R/L/light/dark (1 hot coded); check order
		  - **light-based rule?** T if rule=light/dark, false if rule=L/R (direction-based)
		  - **cell types** by neuron
		  - *==pairwise correlations==* by neuron?
			  - this is a lot of features, 31 choose 2 = 465
		  - *==rat ID==* 1hc?
	  - Compare predictive performance of a "learned" session.
		  - Hypothesis: wake > post > pre > random
	  - *==Split sessions==* with 2 rules (where animal "learned") into 2 sessions?