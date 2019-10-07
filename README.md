# Search_Ignore_Exps
Visual search 2AFC experiment written in Psychopy

These files comprise an experiment conducted in the Visual Cognition lab at Cambridge. 

The experiment aims to investigate whether humans can proactively ignore a complex stimulus. 

The original experiment was designed as an eye tracking experiment but here is adapted as a button press RT task.

'make_displays.m': This script generates the displays used in the task from photograph stimuli that are 275x275 pix.
'Ignore_Exp.m': This script runs the experiment using the stimuli generated.
The other files are lists of stimuli and stimulus location orders for counterbalancing (specific to the stimuli)

The participant aims to ignore the non-target image and instead indicate the direction of the target (from centre) with the arrow keys.
The target image is unknown to the participant before the trial, however the non-target category is known (clocks) for example.
Prior to the array onset a cue image is presented onscreen. Image locations are randomised such that location cannot be used to cue attention.

