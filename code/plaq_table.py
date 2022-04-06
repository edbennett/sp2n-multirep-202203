#!/usr/bin/env python

import logging
from re import compile
from numpy import mean, std, asarray, loadtxt
from numpy.random import default_rng

from uncertainties import ufloat

import yaml

BOOTSTRAP_SAMPLE_COUNT = 500
TRAJECTORY_GETTER = compile(
    r'\[MAIN\]\[0\]Trajectory #(?P<trajectory>[0-9]+)'
)
SUFFIX_FORMAT = '{Nt}x{Ns}x{Ns}x{Ns}b{beta}mas{m_asy}mf{m_fun}'


def basic_bootstrap(values, seed=None):
    values = asarray(values)
    samples = []
    rng = default_rng(seed)
    for _ in range(BOOTSTRAP_SAMPLE_COUNT):
        samples.append(mean(rng.choice(values, len(values))))
    return ufloat(mean(samples, axis=0), std(samples))


def get_ensembles(ensembles_file):
    with open(ensembles_file, 'r') as f:
        ensembles = yaml.safe_load(f.read())
    return {
        name: {**ensemble, 'name': name}
        for name, ensemble in ensembles.items()
        if 'Ns' in ensemble
    }


def get_args():
    from argparse import ArgumentParser, FileType
    parser = ArgumentParser()
    parser.add_argument('ensembles_file')
    parser.add_argument('--data_dir', default='data')
    parser.add_argument('--processed_dir', default='processed_data')
    parser.add_argument('--table_output_file', type=FileType('w'), default='-')
    parser.add_argument('--mathematica_output_file',
                        type=FileType('w'), default='-')
    return parser.parse_args()


def get_plaquettes_for_ensemble(ensemble, data_dir='data'):
    '''Given an ensemble descriptor, identify the file holding the HMC
    log for the ensemble, and return the plaquette history from it.'''

    hmc_file = data_dir + '/out_' + SUFFIX_FORMAT.format(**ensemble)
    return get_plaquettes_from_file(hmc_file)


def zip_dict_sorted(*dcts):
    '''Iterate through multiple dictionaries simultaneously.
    from https://stackoverflow.com/questions/16458340/'''

    if not dcts:
        return
    for i in sorted(set(dcts[0]).intersection(*dcts[1:])):
        yield i, tuple(d[i] for d in dcts)


def get_plaquettes_from_file(filename, first_trajectory=0):
    '''Given a HMC output filename, scan the file for all instances of
    plaquettes and return them in a list.'''

    plaquettes = []
    current_trajectory = 0
    for line in open(filename, 'r'):
        trajectory = TRAJECTORY_GETTER.match(line)
        if trajectory:
            current_trajectory = int(trajectory.group('trajectory'))
        if (
                current_trajectory > first_trajectory
                and line.startswith("[MAIN][0]Plaquette: ")
        ):
            plaquettes.append(float(line.split(' ')[1]))
    return asarray(plaquettes)


def tabulate(ensembles, plaquettes):
    header = r'''\begin{tabular}{|c|c|c|c|c|}
    \hline Ensemble & $N_t\times N_s^3$ & $N_{\mathrm{conf.}}$ &
    $\delta_\mathrm{traj}$ & $\langle\mathcal{P}\rangle$ \\\hline''' + '\n'
    footer = '\n' + r'\\\hline\end{tabular}'

    table_rows = []
    for name, (ensemble, plaquette) in zip_dict_sorted(ensembles, plaquettes):
        row = []
        row.append(name)
        row.append(r'${}\times{}^3$'.format(ensemble['Nt'], ensemble['Ns']))
        row.append(str(ensemble['Nconf']))
        row.append(str(ensemble['delta_traj']))
        row.append(f'{plaquette:.2ufSL}')
        table_rows.append(' & '.join(row))
    return header + '\\\\\n'.join(table_rows) + footer


def get_seed(array):
    return (array * 1e6).astype(int).sum()


def format_mathematica(ensembles, plaquettes):
    formatted_values = []
    for _, (_, plaquette) in zip_dict_sorted(ensembles, plaquettes):
        formatted_values.append(f'{plaquette.n} {plaquette.s}')
    return '\n'.join(formatted_values)


def get_average_plaquette_from_summary_file(ensemble,
                                            processed_dir='processed_data'):
    plaq_summary_file = (
        processed_dir + '/plaq_avg_' + SUFFIX_FORMAT.format(**ensemble)
        + '.txt'
    )
    value, uncertainty = loadtxt(plaq_summary_file)
    return ufloat(value, uncertainty)


def get_average_plaquette(
        ensemble, data_dir='data', processed_dir='processed_data'
):
    try:
        return get_average_plaquette_from_summary_file(
            ensemble, processed_dir=processed_dir
        )
    except FileNotFoundError:
        logging.warn(
            f"Couldn't open summary for {ensemble['name']}, recalculating"
        )
        plaquettes = get_plaquettes_for_ensemble(ensemble, data_dir=data_dir)
        thermalised_plaquettes = plaquettes[ensemble['plaq_therm']:]
        return basic_bootstrap(thermalised_plaquettes,
                               seed=get_seed(plaquettes))


def main():
    args = get_args()
    ensembles = get_ensembles(args.ensembles_file)
    avg_plaquettes = {}
    for name, ensemble in ensembles.items():
        avg_plaquettes[name] = get_average_plaquette(ensemble)
    print(tabulate(ensembles, avg_plaquettes), file=args.table_output_file)
    print(format_mathematica(ensembles, avg_plaquettes),
          file=args.mathematica_output_file)


if __name__ == '__main__':
    main()
