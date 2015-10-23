All experiments are done using 79% threshold, except for where as indicated

Note: 
49% threshold just always returned a direct path, unless the target was within 30cm! 
But overall, any threshold below 75% is unable to find our target!!! It either returns a distance within 15cm, or just 0 (which is the same as the R being found as 2cm)

I have tried to increase the TX power by using 24 V and 30V: These won't work without dramatically spreading the array away from the receiver as there is a tonne of acoustic conduction and direct-pathing



PER CHANNEL Folder: Evaluate channel performance using returned quadratic interpolated timer values. R = time * 49 / 78125

3D Folder: The folder "No Yaw/No Elevation" uses the system of linear equations algorithm/least squares to determine R. This is used to evaluate overall system accuracy