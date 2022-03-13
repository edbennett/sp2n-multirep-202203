# Set this to where you have placed the data
DATA_DIR = ./data

# These will be created automatically
PROCESSED_DIR = ./processed_data
PLOTS_DIR = ./plots
TABLES_DIR = ./tables

# Use this on macOS:
WOLFRAMSCRIPT = /Applications/Mathematica.app/Contents/MacOS/wolframscript

# Use this on Linux:
# WOLFRAMSCRIPT = /usr/local/bin/wolframscript

# Use this on Windows:
# WOLFRAMSCRIPT = 'c:\Program Files\Wolfram Research\Mathematica\7.0\wolframscript.exe'

.PHONY : clean all_plots all_tables paper_outputs

FIG1_OUT_DIR := ${PLOTS_DIR}/Fig1_hmc_forces
FIG45_OUT_DIR := ${PLOTS_DIR}/Fig4-5_mass_scan
FIG6_OUT_DIR := ${PLOTS_DIR}/Fig6_plaq_suscept
FIG7_OUT_DIR := ${PLOTS_DIR}/Fig7_diff_plaq
FIG8_OUT_DIR := ${PLOTS_DIR}/Fig8_cr_plaq_suscept
FIG9_10_OUT_DIR := ${PLOTS_DIR}/Fig9-10_cr_meson_spectra
FIG11_15_OUT_DIR := ${PLOTS_DIR}/Fig11-15_unfolded_density
FIG16_17_OUT_DIR := ${PLOTS_DIR}/Fig16-17_FV_mass_spectrum

FIG_DIRS := ${FIG1_OUT_DIR} ${FIG45_OUT_DIR} ${FIG6_OUT_DIR} ${FIG7_OUT_DIR} ${FIG8_OUT_DIR} ${FIG9_10_OUT_DIR} ${FIG11_15_OUT_DIR} ${FIG16_17_OUT_DIR}

${PROCESSED_DIR} ${TABLES_DIR} ${FIG_DIRS} :
	mkdir -p $@

${PROCESSED_DIR}/force_%.txt : ${DATA_DIR}/out_% | ${PROCESSED_DIR}
	cat $^ | ./code/forcefilter.sh > $@

${PROCESSED_DIR}/plaq_%.txt : ${DATA_DIR}/out_% | ${PROCESSED_DIR}
	cat $^ | ./code/plaqfilter.sh > $@

${PROCESSED_DIR}/meson_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/mesfilter_ms.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@

${PROCESSED_DIR}/vmeson_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/mesfilter_mv.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@

${PROCESSED_DIR}/atmeson_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/mesfilter_mat.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@

${PROCESSED_DIR}/tmeson_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/mesfilter_mt.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@

${PROCESSED_DIR}/avmeson_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/mesfilter_mav.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@

${PROCESSED_DIR}/ch_corr_%.txt : ${DATA_DIR}/out_corr_% | ${PROCESSED_DIR}
	cat $^ | ./code/chbfilter.sh $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+') > $@


${PROCESSED_DIR}/corr_I_fit_%.txt ${PROCESSED_DIR}/corr_v_fit_%.txt ${PROCESSED_DIR}/corr_ps_fit_%.txt &: ${PROCESSED_DIR}/plaq_%.txt ${PROCESSED_DIR}/meson_corr_%.txt ${PROCESSED_DIR}/vmeson_corr_%.txt
	${WOLFRAMSCRIPT} -f code/corr_meson.wls $$(echo $@ | grep -Eo 'mas[-0-9.]+' | grep -Eo '[-0-9.]+')

${PROCESSED_DIR}/eigs_% : ${DATA_DIR}/out_eigs_% | ${PROCESSED_DIR}
	cat $^ | ./code/eigfilter.sh > $@

${PROCESSED_DIR}/eigs_sorted_% : ${PROCESSED_DIR}/eigs_%
	python code/eigsort_sp4.py $^ $@

FIG1_OUTPUTS := ${FIG1_OUT_DIR}/force_history.pdf ${FIG1_OUT_DIR}/force_summary.pdf

${FIG1_OUTPUTS} &: ${PROCESSED_DIR}/force_8x8x8x8b6.5mas-0.9mf-0.7.txt | ${FIG1_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/force_summary.wls $^ ${FIG1_OUTPUTS}


FIG45_INPUTS := ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.8335mf-0.9335_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.8335mf-0.9335_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.835mf-0.935_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.835mf-0.935_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.109mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.109mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.18_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.18_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.21_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.21_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.2_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas3.0mf-1.2_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.13_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.12_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.12_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.13_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.14_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.14_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.15_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.15_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.16_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.16_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.18_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.18_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.1_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.1_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.2_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas0.0mf-1.2_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.79mf-0.89_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.79mf-0.89_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.81mf-0.91_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.81mf-0.91_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.82mf-0.92_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.82mf-0.92_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.83mf-0.93_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.83mf-0.93_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.84mf-0.94_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.84mf-0.94_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.85mf-0.95_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.85mf-0.95_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.87mf-0.97_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-0.87mf-0.97_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.095mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.095mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.105mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.105mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.112mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.112mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.115mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.115mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.115mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.115mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.11mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.11mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.125mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.125mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.12mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.12mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.12mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.12mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.135mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.135mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.13mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.13mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.13mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.13mf0.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.145mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.145mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.14mf3.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.14mf3.0_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.14mf0.0_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.14mf0.0_unit.txt
FIG45_OUTPUTS := ${FIG45_OUT_DIR}/mass_scan_avg_E.pdf ${FIG45_OUT_DIR}/mass_scan_avg_D.pdf ${FIG45_OUT_DIR}/mass_scan_hist_D.pdf ${FIG45_OUT_DIR}/mass_scan_avg_C.pdf ${FIG45_OUT_DIR}/mass_scan_hist_C.pdf ${FIG45_OUT_DIR}/mass_scan_avg_B.pdf ${FIG45_OUT_DIR}/mass_scan_avg_A.pdf

${FIG45_OUTPUTS} &: ${FIG45_INPUTS} | ${FIG45_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/mass_scan_plaq.wls


FIG6_OUTPUTS := ${FIG6_OUT_DIR}/avg_plaq_volumes.pdf ${FIG6_OUT_DIR}/plaq_suscept_volumes.pdf
FIG6_INPUTS := ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.04mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.045mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.03mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.05mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.04mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.045mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.01mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.06mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.05mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.04mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.025mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.01mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.06mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.05mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.02mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.025mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.01mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.06mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.035mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.02mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.025mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.03mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.035mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.02mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.4mas-1.045mf-0.6_random.txt ${PROCESSED_DIR}/plaq_16x16x16x16b6.4mas-1.03mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.4mas-1.035mf-0.6_random.txt

${FIG6_OUTPUTS} &: ${FIG6_INPUTS} | ${FIG6_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/bulk_phase_transition.wls ${FIG6_OUTPUTS}


FIG7_OUTPUTS := ${FIG7_OUT_DIR}/diff_plaq.pdf
FIG7_INPUTS := ${PROCESSED_DIR}/plaq_12x12x12x12b6.3mas-1.098mf-0.6_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.1mas-1.2mf-0.6_unit.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.28mas-1.108mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.0mas-1.25mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.2mas-1.15mf-0.6_random.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.28mas-1.108mf-0.6_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.0mas-1.25mf-0.6_unit.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.2mas-1.15mf-0.6_unit.txt ${PROCESSED_DIR}/plaq_12x12x12x12b6.3mas-1.098mf-0.6_random.txt ${PROCESSED_DIR}/plaq_8x8x8x8b6.1mas-1.2mf-0.6_random.txt

${FIG7_OUTPUTS} &: ${FIG7_INPUTS} | ${FIG7_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/diff_plaq.wls ${FIG7_OUTPUTS}


FIG8_OUTPUTS := ${FIG8_OUT_DIR}/cr_avg_plaq.pdf ${FIG8_OUT_DIR}/cr_plaq_suscept.pdf
FIG8_INPUTS := ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.055mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.063mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.064mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.065mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.066mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.067mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.068mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.069mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.06mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.072mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.075mf-0.6.txt ${PROCESSED_DIR}/plaq_24x12x12x12b6.35mas-1.07mf-0.6.txt

${FIG8_OUTPUTS} &: ${FIG8_INPUTS} | ${FIG8_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/plaq_suscept_b6.35.wls ${FIG8_OUTPUTS}


FIG9_10_OUTPUTS := ${FIG9_10_OUT_DIR}/meson_masses.pdf ${FIG9_10_OUT_DIR}/meson_decay_consts.pdf ${FIG9_10_OUT_DIR}/decay_const_ratio.pdf ${FIG9_10_OUT_DIR}/mass_ratio.pdf
FIG9_10_INPUTS := $(foreach MAS, -1.055 -1.06 -1.063 -1.064 -1.065 -1.066 -1.067 -1.068 -1.069 -1.07 -1.072 -1.075, $(foreach INFIX, ps I v, ${PROCESSED_DIR}/corr_$(INFIX)_fit_24x12x12x12b6.35mas$(MAS)mf-0.6.txt))

${FIG9_10_OUTPUTS} &: ${FIG9_10_INPUTS} | ${FIG9_10_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/meson_spectra_cr.wls ${FIG9_10_OUTPUTS}


FIG11_15_OUTPUTS := ${FIG11_15_OUT_DIR}/bare_eigvals.pdf ${FIG11_15_OUT_DIR}/eigval_histogram_4x4fun.pdf ${FIG11_15_OUT_DIR}/eigval_histogram_4x4asy.pdf ${FIG11_15_OUT_DIR}/eigval_density.pdf ${FIG11_15_OUT_DIR}/eigval_histogram_3x3.pdf ${FIG11_15_OUT_DIR}/eigval_histogram_4x4fun_trunc.pdf ${FIG11_15_OUT_DIR}/eigval_histogram_3x3fun_trunc.pdf ${TABLES_DIR}/
FIG11_15_INPUTS := $(foreach SUFFIX, 3x3x3x3b8.0mf-0.2 4x4x4x4b8.0mf-0.2 4x4x4x4b8.0mas-0.2, ${PROCESSED_DIR}/eigs_sorted_$(SUFFIX))

${FIG11_15_OUTPUTS} &: ${FIG11_15_INPUTS} | ${FIG11_15_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/dirac_eigs.wls ${FIG11_15_OUTPUTS}


FIG16_17_OUTPUTS := ${FIG16_17_OUT_DIR}/mps_f_scaling.pdf ${FIG16_17_OUT_DIR}/mps_as_scaling.pdf ${FIG16_17_OUT_DIR}/mcb_f_scaling.pdf ${FIG16_17_OUT_DIR}/mv_scaling.pdf ${FIG16_17_OUT_DIR}/fps_scaling.pdf ${FIG16_17_OUT_DIR}/plaq_scaling.pdf
FIG16_17_INPUTS := corr_I_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_I_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_at_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_at_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_av_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_av_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_ch_fit_36x8x8x8b6.5mas-1.01mf-0.71.txt corr_ch_fit_48x12x12x12b6.5mas-1.01mf-0.71.txt corr_ch_fit_48x16x16x16b6.5mas-1.01mf-0.71.txt corr_ch_fit_48x18x18x18b6.5mas-1.01mf-0.71.txt corr_ch_fit_48x20x20x20b6.5mas-1.01mf-0.71.txt corr_ch_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_ch_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_ps_fit_36x8x8x8b6.5mas-1.01mf-0.71.txt corr_ps_fit_48x12x12x12b6.5mas-1.01mf-0.71.txt corr_ps_fit_48x16x16x16b6.5mas-1.01mf-0.71.txt corr_ps_fit_48x18x18x18b6.5mas-1.01mf-0.71.txt corr_ps_fit_48x20x20x20b6.5mas-1.01mf-0.71.txt corr_ps_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_ps_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_t_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_t_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt corr_v_fit_36x8x8x8b6.5mas-1.01mf-0.71.txt corr_v_fit_48x12x12x12b6.5mas-1.01mf-0.71.txt corr_v_fit_48x16x16x16b6.5mas-1.01mf-0.71.txt corr_v_fit_48x18x18x18b6.5mas-1.01mf-0.71.txt corr_v_fit_48x20x20x20b6.5mas-1.01mf-0.71.txt corr_v_fit_48x24x24x24b6.5mas-1.01mf-0.71.txt corr_v_fit_54x28x28x28b6.5mas-1.01mf-0.71.txt

${FIG16_17_OUTPUTS} &: ${FIG16_17_INPUTS} | ${FIG16_17_OUT_DIR}
	${WOLFRAMSCRIPT} -f code/FVeffects.wls ${FIG16_17_OUTPUTS}


TAB2_OUTPUT := ${TABLES_DIR}/eig_table.tex
TAB2_INPUTS := $(foreach SUFFIX, su2_4x4x4x4b1.8mf-1.0 su4_4x4x4x4b10.0mf-0.2 su4_4x4x4x4b10.0mas-0.2 4x4x4x4b8.0mf-0.2 4x4x4x4b8.0mas-0.2, ${PROCESSED_DIR}/eigs_${SUFFIX})

${TAB2_OUTPUT} : ${TAB2_INPUTS} | ${TABLES_DIR}
	python code/eigs_qmsquared.py $^ --output_filename=$@


TAB3_OUTPUT := ${TABLES_DIR}/plaq_table.tex
TAB3_INPUT_DATA := $(foreach VOLUME, 36x8x8x8 48x12x12x12 48x16x16x16 48x18x18x18 48x20x20x20 48x24x24x24 54x28x28x28, ${DATA_DIR}/out_${VOLUME}b6.5mas-1.01mf-0.71)
ENSEMBLES_FILE := data/spectrum_ensembles.yaml

${TAB3_OUTPUT} : ${ENSEMBLES_FILE} | ${TAB3_INPUT_DATA} ${TABLES_DIR}
	python code/plaq_table.py $^ --data_dir ${DATA_DIR} --output_file $@


clean-tables :
	rm -r ${TABLES_DIR}

clean-plots :
	rm -r ${PLOTS_DIR}

clean-data :
	rm -r ${PROCESSED_DIR}/*

clean : clean-tables clean-plots clean-data

all_plots : ${FIG1_OUT_DIR}/force_summary.pdf ${FIG45_OUTPUTS} ${FIG6_OUTPUTS} ${FIG7_OUTPUTS} ${FIG8_OUTPUTS} ${FIG9_10_OUTPUTS} ${FIG11_15_OUTPUTS}

all_tables : ${TAB2_OUTPUT} ${TAB3_OUTPUT}

paper_outputs : all_plots all_tables

.DEFAULT_GOAL := paper_outputs
