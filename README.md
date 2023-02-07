# Rapid_IIIC_Labeling_GUI_MultipleEEGs
GUI for rapid labeling of segments from multiple EEGs, and instructions for preparing data for these labeling tasks

# Rapid_IIIC_Labeling_GUI

This repository describes a GUI developed by Dr. Jin Jing ("JJ"), PhD that enables rapid labeling of IIIC patterns. By following these instructions you can set up the GUI to annotate your own data. Note that this GUI allows labeling of isolated samples from multiple EEGs in one task. This is different from the GUI that allows labeling of a single EEG exhaustively. 

**Requirements:** MATLAB, EEGLAB (https://sccn.ucsd.edu/eeglab/index.php), and Python (Anaconda)

**Input data:** Raw EDF files inside .\Data\EDF\; scalp monopolar/C2 EEG that contains a full set of 19 channels + 1 EKG (optional), with channels named as follows:

Fp1 F3 C3 P3 F7 T3 T5 O1 Fz Cz Pz Fp2 F4 C4 P4 F8 T4 T6 O2 (EKG)
<img src="readme.fld/image001.png" alt="drawing" width="300"/>


**Step1:** Read EDF to MAT using EEGLAB toolbox for MATLAB. Run script step1_readEDF2MAT.m, which converts EDF format to MAT format in .\Data\MAT\ that contains the following variables:

- _data_: EEG array
- _channels_: list of channel names in data
- _Fs_: the sampling rate of data
- _startTime_: the start time vector of data

<img src="readme.fld/image002.png" alt="drawing" width="300"/>


**Step2:** Preprocess MAT to select/rearrange channels, resample to 200Hz , and denoise with 0.5 40Hz band-pass and 5Hz band-stop centered at the power-line frequency (US: 60Hz, UK: 50Hz). Output files are saved in .\Data\processed\

<img src="readme.fld/image003.png" alt="drawing" width="300"/>

**Step3:** run SPaRCNet (Python backend)

==Configure Python==

Install anaconda3 and open a terminal

`$ conda create -n iiic python=3.6`

`$ activate iiic`

`$ conda install -c conda-forge hdf5storage`

`$ pip install mne`

`$ pip install torch==1.5.0+cpu torchvision==0.6.0+cpu -f https://download.pytorch.org/whl/torch_stable.html`

Run MATLAB wrapper step3_runSPaRCNat.m

CSV score table will be export to .\Data\iiic\

Each row is the probabilities for 6 classes: Other, Seizure, LPD, GPD, LRDA, and GRDA

Starting from the 1^st^ 10sec EEG segment and moving at 2sec step in time

Eg. row #1: scores for 0 10sec, row #2: scores for 2 12sec, ...

<img src="readme.fld/image004.png" alt="drawing" width="300"/>

**Step4:** Run step4_readCSV.m to read CSV to MAT to make sure every 2sec segment has scores. The output files are saved in .\Data\iiic\model_prediction\.

**Step5:** Run step5_computeSpectrograms to get regional average spectrograms in .\Data\Spectrograms\, which contains the following variables:

- _Sdata_: 4 regional average spectrograms
- _stimes_: time coordinates
- _sfreqs_: frequency coordinates
- _params_: spectrogram parameters

**Step6:** Run step6_segementEEG.m to divide EEG into stationary periods with change point (CP) detection, and the output look-up-table are exported to .\Data\CPDs\ which contains the following variables:

-	isCPcenters: 0 (not CP center) or 1 (is CP center)
-	isCPs: 0 (not CP) pr 1 (is CP)
-	lut_cpd: index of each CP center (column #1) and its range [start (column #2),  end (column #3)]
<img src="readme.fld/image002.png" alt="drawing" width="300"/>

**Step7:** Compute embedding map (PaCMAP) and wrap all inputs into one task folder for each patient

Configure PaCMAP (Python library: https://github.com/YingfanWang/PaCMAP)

Run step6_prepare4GUI.m

<img src="readme.fld/image005.png" alt="drawing" width="500"/>

**Step8:** Run GUI CMGUI_Sequential_BoWspreading_v3.m inside the task folder .\Task\subject01\

<img src="readme.fld/image006.png" alt="drawing" width="300"/>  input rater initials to store scores.

<img src="readme.fld/image007.png" alt="drawing" width="500"/>  click Start to continue.

Enter Phase #I: label K=50 clusters in a row.

<img src="readme.fld/image008.png" alt="drawing" width="500"/>

Enter Phase #2: sequential inspect all labels.

<img src="readme.fld/image009.png" alt="drawing" width="500"/>

Press _Done_ button to seal and export the labels.

<img src="readme.fld/image010.png" alt="drawing" width="500"/>

Please refer to slides for detailed instructions.
