all_data_raw: all data copied from sessions and put together

conceptlist_info: all concepts used in our experiments (expressibility ratings, productions, etc.) with additional information about semantic category, PoS, etc.

problems: concepts/words for which we don't have cosine similarity yet (mostly two-word answers, but maybe some mis-spellings too)

expressibility_dutch: expressibility data for Dutch experiment, modeled + raw average

expressibility_german: expressibility data for German experiment, modeled + raw average

similarity_df_final: data with concepts, answers, expressibility, cosine similarity, and other info

----

- Add columns:
	- participant: for unique identifier of participant (e.g., 1, 2, 3...)
	- dyad: for unique identifier of dyad (e.g., 1, 2, 3...)
	- file: name of file of the production
	- correction: 0 = first production, 1 = second production, 2 = third production

- Remove non-target items. Alternatively, add a column that allows for identification (e.g., called "trial" with values "practice" and "target")

- Maybe after the steps above, it will not be necessary anymore: 
	Please let me know what are the columns:
	- cycle
	- session_ID (what are the individual parts)
	
- Other questions:
	- Please double-check that all dyads are there. I have data from 61 dyads and 122 participants (as opposed to 72 dyads and 144 participants.)