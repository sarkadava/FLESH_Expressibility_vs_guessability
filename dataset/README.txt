all_data_raw: all data copied from sessions and put together

conceptlist_info: all concepts used in our experiments (expressibility ratings, productions, etc.) with additional information about semantic category, PoS, etc.

problems: concepts/words for which we don't have cosine similarity yet (mostly two-word answers, but maybe some mis-spellings too)

expressibility_dutch: expressibility data for Dutch experiment, modeled + raw average

expressibility_german: expressibility data for German experiment, modeled + raw average

similarity_df_final: data with concepts, answers, expressibility, cosine similarity, and other info

df_similarity_only: data only with target, answer and cosine similarity (the numberbatch usually takes a lot of time to load, so to prevent running it all the time again, this is just all the data)

----

New additions
	- column pcnID, tracking participants (ignoring the two parts of a session), in form session_participant
	- column for dyad
	- column for correction, note that part 1 has value of correction 0
	- column for trial_order to keep track of the order how stimuli were presented
	- column trial_type keeps track of what concept is target/practice
	- column cycle renamed to participant (0 starts first, 1 follows, this is decided by rock-paper-scissors game and kept constant throughout the session)
	- column session ID stands for session_part
	- new dataframe df_similarity_only, see above the reason (it's just for data-wrangling purposes)

Notes
	- dyad 68 is not there because consent was withdrawn
	- dyad 19 is missing - not sure why, will check back on hard-drive 
	- therefore, for now, 140 participants

TODO

	- file name (will add later, need to check the string format of the video/audio name)

