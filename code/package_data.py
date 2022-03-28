from collections import defaultdict, namedtuple
import logging
import re

import h5py
import numpy as np

Ensemble = namedtuple(
    'Ensemble',
    ["family", "rank", "nt", "nx", "ny", "nz", "beta", "mas", "mf", "tag"]
)

def read_cfggeneration(filename):
    data = []
    start = None
    nits_per_cycle, nhb, nor = None, None, None
    deltas, dt1, dt0, accept = None, None, None, None
    log_type = None

    for line in open(filename, 'r'):
        if line.startswith('[MAIN][0]Trajectory #') and line.endswith('...\n'):
            trajectory = int(line.split()[1][1:-3])
        elif (start is None) and line.startswith('[FLOW][0]Starting'):
            start = line.split()[6]
        elif (start is None) and line.startswith('[MAIN][0]Configuration fro'):
            start = 'existing'
        elif line.startswith('[MAIN][0]Number of hb-or iterations per cycle:'):
            nits_per_cycle = int(line.split()[6])
        elif line.startswith('[MAIN][0]Number of heatbaths per iteration:'):
            nhb = int(line.split()[5])
        elif line.startswith('[MAIN][0]Number or overrelaxations per ite'):
            nor = int(line.split()[5])
        elif line.startswith('[HMC][10][DeltaS'):
            deltas = float(line.split()[2].split(']')[0])
        elif line.startswith('[MD_INT][10]MD parameters: level=1'):
            dt1 = float(line.split()[6].split('=')[1])
        elif line.startswith('[MD_INT][10]MD parameters: level=0'):
            dt0 = float(line.split()[6].split('=')[1])
        elif line.startswith('[HMC][10]Configuration '):
            if line.split()[1] == 'accepted.':
                accept = True
            elif line.split()[1] == 'rejected.':
                accept = False
            else:
                continue

        if line.startswith('[MAIN][0]Plaquette:') and trajectory is not None:
            plaq = float(line.split()[1])
            if (
                    (deltas is not None) and (dt1 is not None) and
                    (dt0 is not None) and (accept is not None)
            ):
                if (log_type is not None) and (log_type != 'hmc'):
                    raise ValueError(f"Inconsistent generation log {filename}")
                log_type = 'hmc'
                data.append((trajectory, plaq, deltas, dt0, dt1, accept))
            elif (
                    (nhb is not None) and (nor is not None) and
                    (nits_per_cycle is not None)
            ):
                if (log_type is not None) and (log_type != 'puregauge'):
                    raise ValueError(f"Inconsistent generation log {filename}")
                log_type = 'puregauge'
                data.append((trajectory, plaq, nits_per_cycle, nhb, nor))
            else:
                raise ValueError(f"Indeterminate log type {filename}")
            trajectory, plaq = None, None
            deltas, dt0, dt1, accept = None, None, None, None

    if log_type == 'hmc':
        dt = np.dtype([
            ('trajectory', int),
            ('plaquette', float),
            ('delta_S', float),
            ('dt_gauge', float),
            ('dt_fermion', float),
            ('accepted', bool)
        ])
    elif log_type == 'puregauge':
        dt = np.dtype([
            ('trajectory', int),
            ('plaquette', float),
            ('nits_per_cycle', int),
            ('heat_bath_steps', int),
            ('overrelaxation_steps', int)
        ])

    recs = np.array(data, dtype=dt)
    return log_type, start, recs


def read_eigvals(filename):
    eigvals = []
    cfg_idxs = []
    cfg_eigvals = None
    for line in open(filename, 'r'):
        if (
                line.startswith('[IO][0]Configuration')
                or line.startswith('[MAIN][0]Time taken =')
        ):
            if cfg_eigvals is not None:
                eigvals.append(cfg_eigvals)
                cfg_idxs.append(cfg_idx)
            if line.startswith('[IO][0]Configuration'):
                cfg_idx = int(
                    re.match('.*n([0-9]+)\]', line.split()[1]).groups()[0]
                )
                cfg_eigvals = []
        elif line.startswith('[RESULT][0]Eig '):
            _, idx, _, eig_real, eig_imag = line.split()
            if len(cfg_eigvals) != int(idx):
                raise ValueError("Eigenvalue file appears corrupt")
            cfg_eigvals.append(float(eig_real) + 1J * float(eig_imag))

    return np.asarray(cfg_idxs), np.asarray(eigvals)


def read_correlators(filename):
    cfg_idxs = set()
    correlators = defaultdict(lambda : defaultdict(dict))

    for n, line in enumerate(open(filename, 'r')):
        if n == 0:
            if 'REPR_ANTISYMMETRIC' in line:
                default_rep = 'asy'
            elif 'REPR_FUNDAMENTAL' in line:
                default_rep = 'fun'
            elif 'REPR_SYMMETRIC' in line:
                default_rep = 'sym'
            elif 'REPR_ADJOINT' in line:
                default_rep = 'adj'
            else:
                raise ValueError(
                    'First line should define representation'
                )

        if line.startswith('[IO][0]Configuration'):
            cfg_idx = int(
                re.match('.*n([0-9]+)\]', line.split()[1]).groups()[0]
            )
            rep = default_rep
        elif line.startswith("[CALC_PROPAGATOR_FUND][10]n"):
            rep = 'fun'
        elif line.startswith("[MAIN][0]conf #"):
            split_line = line.split()
            m = float(split_line[2][5:])
            if split_line[3] == 'DEFAULT_POINT':
                del split_line[3]
            channel = split_line[4][:-1]
            correlator = list(map(float, split_line[5:]))
            cfg_idxs.add(cfg_idx)
            correlators[(m, rep)][channel][cfg_idx] = correlator

    correlator_arrays = defaultdict(dict)

    for mass_rep, mr_correlator_set in correlators.items():
        for channel, channel_correlators in mr_correlator_set.items():
            assert set(channel_correlators.keys()) == cfg_idxs
            correlator_arrays[mass_rep][channel] = np.asarray([
                correlator for _, correlator in sorted(channel_correlators.items())
            ])

    return np.asarray(sorted(cfg_idxs)), correlator_arrays


def parse_metadata(filename):
    ftype, family, rank, nt, nx, ny, nz, beta, mas, mf, tag = re.match(
        '(?:.*/)?'
        'out_(?:([a-z]+)_)?(?:(su)([0-9]+)_)?([0-9]+)x([0-9]+)x([0-9]+)'
        'x([0-9]+)b([0-9]+[.]?[0-9]*)(?:mas(-?[0-9]+[.]?[0-9]*))?'
        '(?:mf(-?[0-9]+[.]?[0-9]*))?(?:_([a-z]*))?',
        filename
    ).groups()
    if not ftype:
        ftype = 'cfggeneration'
    if not family:
        family = 'Sp'
    else:
        family = family.upper()
    if not rank:
        rank = 4
    rank, nt, nx, ny, nz = map(int, (rank, nt, nx, ny, nz))
    beta = float(beta)
    if mas:
        mas = float(mas)
    if mf:
        mf = float(mf)
    return ftype, Ensemble(family, rank, nt, nx, ny, nz, beta, mas, mf, tag)


def get_args():
    from argparse import ArgumentParser

    parser = ArgumentParser()
    parser.add_argument('filenames', metavar='filename', nargs='+')
    parser.add_argument('--output_filename', required=True)
    return parser.parse_args()


def attribute_hdf5_obj(obj, ensemble, extras={}):
    for attr_name, attr_value in {**ensemble._asdict(), **extras}.items():
        if attr_value is not None:
            obj.attrs[attr_name] = attr_value


def filename_suffix(ensemble):
    return (
        '{family}{rank}_{nt}x{nx}x{ny}x{nz}b{beta:.6f}{mas_tag}{mf_tag}'
        '{suffix}'
    ).format(
        **ensemble._asdict(),
        suffix=(f'_{ensemble.tag}' if ensemble.tag else ''),
        mas_tag=(f'mas{ensemble.mas:.6f}' if ensemble.mas else ''),
        mf_tag=(f'mf{ensemble.mf:.6f}' if ensemble.mf else '')
    )


def process_file(filename, h5file):
    ftype, ensemble = parse_metadata(filename)
    ens_name = filename_suffix(ensemble)

    ensemble_group = (
        h5file.require_group('by_ensemble').require_group(ens_name)
    )
    attribute_hdf5_obj(ensemble_group, ensemble)

    if ftype == 'cfggeneration':
        logging.info('Processing %s as configuration generation', filename)
        gen_type, start, generation_log_data = read_cfggeneration(filename)
        ds = h5file.require_group('generation_logs').create_dataset(
            name=ens_name, data=generation_log_data
        )
        attribute_hdf5_obj(
            ds, ensemble, {'start': start, 'gen_type': gen_type}
        )
        ensemble_group['generation_log'] = ds
    elif ftype == 'eigs':
        logging.info('Processing %s as eigenvalues', filename)
        indexes, eigvals = read_eigvals(filename)
        ds = h5file.require_group('eigenvalues').create_dataset(
            name=ens_name, data=eigvals
        )
        attribute_hdf5_obj(ds, ensemble)
        ds.attrs['trajectory_indexes'] = indexes
        ensemble_group['eigenvalues'] = ds
    elif ftype == 'corr':
        logging.info('Processing %s as correlators', filename)
        indexes, correlators = read_correlators(filename)
        corr_group = h5file.require_group('correlators').require_group(
            ens_name
        )
        corr_group.attrs['trajectory_indexes'] = indexes
        attribute_hdf5_obj(corr_group, ensemble)

        for (mass, rep), mr_correlator in correlators.items():
            probe_group = corr_group.require_group(f'{mass}_{rep}')
            probe_attrs = {'probe_mass': mass, 'probe_rep': rep}
            attribute_hdf5_obj(probe_group, ensemble, probe_attrs)

            for channel, correlator in mr_correlator.items():
                ds = probe_group.create_dataset(name=channel, data=correlator)
                attribute_hdf5_obj(ds, ensemble, probe_attrs)

        ensemble_group['correlators'] = corr_group


def main():
    args = get_args()
    logging.basicConfig(level=logging.INFO)

    with h5py.File(args.output_filename, 'w') as h5file:
        for filename in args.filenames:
            logging.info('Processing %s', filename)
            process_file(filename, h5file)


if __name__ == '__main__':
    main()
